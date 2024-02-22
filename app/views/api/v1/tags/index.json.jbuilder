json.tags do 
  json.array!(tags) do |tag|
    json.cache! ['api', 'v1', 'tag', object_cache_key(tag)], expires_in: 1.hour do
      json.partial! partial: 'api/v1/tags/tag', locals: { tag: tag }
    end
  end
end