json.creator do
  json.array!(creators) do |creator|
    json.cache! ['api', 'v1', 'creators', collection_cache_key(creators)], expires_in: 1.hour do
      json.partial! partial: 'api/v1/creators/creator', locals: { creator: creator, show_in_full: false}
    end
  end
end