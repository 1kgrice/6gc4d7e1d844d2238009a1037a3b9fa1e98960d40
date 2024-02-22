module Api::V1::ResponseCacheable
  extend ActiveSupport::Concern

  included do
      before_action :set_cache_key_prefix
  end

  def to_key(query_params)
    case query_params
    when String
      query_params
    when Hash
      sorted_params = query_params.sort.to_h
      URI.encode_www_form(sorted_params)
    when ActionController::Parameters
      sorted_params = query_params.to_unsafe_h.sort.to_h
      sorted_params.to_query
    else
      raise ArgumentError, "Unsupported type for cache key generation"
    end
  end

  private

  def render_with_cache(key:, expires_in: 1.hour)
    cache_key = build_cache_key(key)
    cached_data = Rails.cache.read(cache_key)

    if cached_data
      render json: cached_data
    else
      json_response = yield if block_given?
      Rails.cache.write(cache_key, json_response, expires_in: expires_in)
      render json: json_response
    end
  end

  def build_cache_key(key, controller: controller_name)
    [@cache_key_prefix, controller, key.to_param].compact.join('/')
  end

  def set_cache_key_prefix
    @cache_key_prefix = 'api/v1'
  end

  # Allows controllers to override the default cache key prefix
  def cache_key_prefix(prefix)
    @cache_key_prefix = prefix
  end
end
