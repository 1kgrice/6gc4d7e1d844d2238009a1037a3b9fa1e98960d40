json.creator do
  json.cache! ['api', 'v1', 'creator', object_cache_key(creator)], expires_in: 1.hour do
    json.partial! partial: 'api/v1/creators/creator', locals: { creator: creator, show_in_full: true}
  end
end