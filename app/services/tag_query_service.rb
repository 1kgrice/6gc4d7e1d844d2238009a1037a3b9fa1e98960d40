class TagQueryService
  SCOPE_MAPPING = {
    category: :by_category
  }.freeze

  def initialize(params = {})
    @params = params
  end

  def call
    apply_scopes
    @tags
  end

  private

  def apply_scopes
    products = Product.published
    products = products.by_category(@params[:category]) if @params.key?(:category)  
    tags = ActsAsTaggableOn::Tag.top_tags_for(products, 'Product', limit: DEFAULT_LIMIT[:tags])
  end
end
