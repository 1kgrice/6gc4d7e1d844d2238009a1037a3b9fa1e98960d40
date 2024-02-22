module Api::V1::JsonCacheHelper
  def collection_cache_key(collection)
    collection&.map(&:id)&.join('-')
  end

  def object_cache_key(obj)
    "#{obj&.id}-#{obj&.updated_at&.to_i}"
  end
end