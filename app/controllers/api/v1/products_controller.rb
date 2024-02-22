class Api::V1::ProductsController < Api::V1::ApiController
  include Api::V1::ResponseCacheable

  # Scopes for filtering and searching
  has_scope :by_name, as: :name
  has_scope :by_username, as: :creator
  has_scope :by_min_rating, as: :rating
  has_scope :by_category, as: :category
  has_scope :by_query, as: :query

  has_scope :staff_picks, type: :boolean
  has_scope :featured, type: :boolean
  has_scope :hot_and_new, type: :boolean
  
  def index
    render_with_cache(key: to_key(query_params.to_param)) do
      products, total_count, top_tags = search_products
      render_template_string 'api/v1/products/index', products: products, total_count: total_count, top_tags: top_tags
    end
  end

  def show
    product = if request.path.include?('random')
      Product.find(Product.published.pluck(:id).sample)
    elsif params.key?(:creator_username) && params.key?(:permalink)
      Product.find_by_username_and_permalink(params[:creator_username], params[:permalink])
    end
    raise AppErrors::API::RecordNotFoundError, "Product not found" unless product.present?
    render_template 'show', product: product
  end

  private
  
  def query_params
    params.permit(:name, :min_price, :max_price, :rating, :category, :sort, :staff_picks, :featured, :hot_and_new, :creator, :tags, :from, :limit, :query, :pwyw)
  end

  def tag_params
    unescape(query_params[:tags]).split(',')
  end

  def search_products
    # General scopes
    products = apply_scopes(Product).published

    # Pricing
    if query_params[:pwyw] == 'true' || query_params[:pwyw] == '1'
      products = products.pwyw
    else
      products = products.by_min_price(query_params[:min_price]) if params[:min_price].present?
      products = products.by_max_price(query_params[:max_price]) if params[:max_price].present?
    end

    # Tags
    # Wrapped in a secondary query as a workaround for top_tags_for subquery
    products = Product.where(id: products.by_tags(tag_params).pluck(:id)) if params[:tags].present?
    top_tags = []
    top_tags = ActsAsTaggableOn::Tag.top_tags_for(products, 'Product', limit: DEFAULT_LIMIT[:tags]) if request.path.include?('search')

    # Sorting, Limits and Offsets
    total_count = products.count
    default_limit = DEFAULT_LIMIT[:products]
    sort = params[:sort] ? query_params[:sort].to_sym : nil
    offset = params[:from] ? query_params[:from].to_i : 0
    limit = [query_params[:limit].to_i, default_limit].min.nonzero? || default_limit

    products = products.includes(:creator, :covers, :product_options)
                        .sorted_by(sort)
                        .offset(offset)
                        .limit(limit)

    [products, total_count, top_tags]
  end
end 
