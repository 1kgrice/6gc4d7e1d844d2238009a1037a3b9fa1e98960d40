class PreWarmDiscoverCategoriesJob < ApplicationJob
  queue_as :default

  def perform
    categories = Category.all
    queries = []
    queries << { root: true }
    queries += categories.map do |category|
      {
        by_long_slug: category.long_slug
      }
    end
    single_queries = []
    single_queries += categories.map do |category|
      {
        long_slug: category.long_slug
      }
    end

    queries.each do |query|
      categories = CategoryQueryService.new(query).call
      cache_key = build_cache_key(to_key(query), controller: 'categories')
      serialized_data = render_jbuilder('api/v1/categories/index', categories: categories, total_count: categories.count, include_children: true)
      Rails.cache.write(cache_key, serialized_data, expires_in: 1.hour)
    end

    single_queries.each do |query|
      category = CategoryQueryService.new(query).call_single
      cache_key = build_cache_key(to_key(query), controller: 'categories')
      serialized_data = render_jbuilder('api/v1/categories/show', category: category, include_children: true, include_ancestors: true)
      Rails.cache.write(cache_key, serialized_data, expires_in: 1.hour)
    end
  end
end
