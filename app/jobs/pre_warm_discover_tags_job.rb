class PreWarmDiscoverTagsJob < ApplicationJob
  queue_as :default

  def perform
    categories = Category.root
    queries = []

    queries = [{}]
    queries += categories.map do |category|
      {
        category: category.long_slug
      }
    end

    queries.each do |query|
      tags = TagQueryService.new(query).call
      cache_key = build_cache_key(to_key(query), controller: 'tags')
      serialized_data = render_jbuilder('api/v1/tags/index', tags: tags)
      Rails.cache.write(cache_key, serialized_data, expires_in: 1.hour)
    end
  end
end
