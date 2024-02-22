require 'cgi'

class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  discard_on ActiveJob::DeserializationError

  private

  def render_jbuilder(template_path, locals = {})
    ApplicationController.renderer.render(template: template_path, formats: :json, locals: locals)
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

  def build_cache_key(key, controller: controller_name)
    [@cache_key_prefix, controller, key.to_param].compact.join('/')
  end

  def set_cache_key_prefix
    @cache_key_prefix = 'api/v1'
  end

  def cache_key_prefix(prefix)
    @cache_key_prefix = prefix
  end
end
