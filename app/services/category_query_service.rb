class CategoryQueryService
  DEFAULT_LIMIT = 9

  # Scopes for filtering and searching
  SCOPE_MAPPING = {
    root: :root,
    by_long_slug: :by_long_slug,
  }.freeze
  BOOLEAN_SCOPES = [
    :root
  ].freeze

  # Scopes
  def initialize(params = {}, categories = Category.all)
    @categories = categories.includes(:stats)
    @params = params
  end

  def call
    apply_scopes
    @categories
  end

  def call_single
    value = @params[:long_slug]
    Category.find_by(long_slug: value) if value.present?
  end

  private

  def apply_scopes
    SCOPE_MAPPING.each do |param_key, scope_name|
      next unless @params[param_key] && @categories.respond_to?(scope_name)

      value = @params[param_key]
      @categories = value.present? && !BOOLEAN_SCOPES.include?(param_key.to_sym) ? @categories.public_send(scope_name, value) : @categories.public_send(scope_name)
    end
  end
end
