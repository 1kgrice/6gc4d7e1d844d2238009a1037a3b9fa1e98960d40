class ProductQueryService
  DEFAULT_LIMIT = 9

  # Scopes for filtering and searching
  SCOPE_MAPPING = {
    name: :by_name,
    min_price: :min_price,
    max_price: :max_price,
    rating: :by_min_rating,
    category: :by_category,
    sort: :sorted_by,
    staff_picks: :staff_picks,
    featured: :featured,
    hot_and_new: :hot_and_new,
    creator: :by_username,
    tags: :by_any_tags,
    from: :offset,
    limit: :limit,
    published: :published
  }.freeze
  BOOLEAN_SCOPES = [
    :staff_picks, :featured, :hot_and_new, :published
  ].freeze

  # Scopes
  def initialize(params = {}, products = Product.all)
    @products = products.includes(:creator, :product_reference).published
    @params = params
  end

  def call
    apply_scopes
    @products
  end

  private

  def apply_scopes
    SCOPE_MAPPING.each do |param_key, scope_name|
      next unless @params[param_key] && @products.respond_to?(scope_name)

      value = @params[param_key]
      puts "Applying scope #{scope_name} with value #{value}"
      @products = value.present? && !BOOLEAN_SCOPES.include?(param_key.to_sym) ? @products.public_send(scope_name, value) : @products.public_send(scope_name)
    end
  end
end
