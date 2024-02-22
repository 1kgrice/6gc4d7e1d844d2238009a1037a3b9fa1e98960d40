class Api::V1::TagsController < Api::V1::ApiController
  include Api::V1::ResponseCacheable

  def index
    render_with_cache(key: to_key(query_params)) do
      params_hash = query_params.to_h.symbolize_keys
      
      products = Product.published
      products = products.by_category(category_param) if params_hash.key?(:category)
      
      top_tags = ActsAsTaggableOn::Tag.top_tags_for(products, 'Product', limit: DEFAULT_LIMIT[:tags])

      render_template_string 'api/v1/tags/index', tags: top_tags
    end
  end

  protected

  def query_params
    params.permit(:category)
  end

  def category_param
    unescape(query_params[:category])
  end
end