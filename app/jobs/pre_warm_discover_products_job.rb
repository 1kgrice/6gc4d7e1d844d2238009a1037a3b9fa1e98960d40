class PreWarmDiscoverProductsJob < ApplicationJob
  queue_as :default

  def perform
    categories = Category.root
    queries = []

    queries << { best_selling: true, limit: 3 }
    queries += categories.map do |category|
      {
        best_selling: true,
        category: category.long_slug,
        limit: 3
      }
    end
    queries << { hot_and_new: true, limit: 3 }
    queries += categories.map do |category|
      {
        hot_and_new: true,
        category: category.long_slug,
        limit: 3
      }
    end
    queries << { featured: true, limit: 5 }
    queries += categories.map do |category|  
      {
        featured: true,
        category: category.long_slug,
        limit: 5
      }
    end
    queries << { pwyw: true, limit: 3 }
    queries += categories.map do |category|  
      {
        pwyw: true,
        sort: 'most_reviewed',
        category: category.long_slug,
        limit: 3
      }
    end

    queries.each do |query|
      products = ProductQueryService.new(query).call
      cache_key = build_cache_key(to_key(query), controller: 'products')
      serialized_data = render_jbuilder('api/v1/products/index', products: products, total_count: products.count)
      Rails.cache.write(cache_key, serialized_data, expires_in: 1.hour)
    end
  end
end
