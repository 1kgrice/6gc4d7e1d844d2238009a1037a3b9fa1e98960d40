class Api::V1::CategoriesController < Api::V1::ApiController
  include Api::V1::ResponseCacheable
  has_scope :root
  has_scope :by_long_slug

  def index
    render_with_cache(key: to_key(query_params)) do
      categories = apply_scopes(Category).published.includes(:stats).order(order: :asc)
      total_count = categories.count
      limit = DEFAULT_LIMIT[:categories]
      categories = categories.limit(limit)

      json_response = render_template_string 'api/v1/categories/index', categories: categories, total_count: total_count, include_children: true
    end
  end

  def show
    query = params.permit(:long_slug)
    render_with_cache(key: to_key(query)) do
      category = Category.find_by(long_slug: unescape(query[:long_slug]))
      raise AppErrors::API::RecordNotFoundError, 'Category not found' unless category.present?
      json_response = render_template_string 'api/v1/categories/show', category: category, include_ancestors: true, include_children: true
    end
  end

  private 

  def query_params
    params.permit(:root, :by_long_slug)
  end
end