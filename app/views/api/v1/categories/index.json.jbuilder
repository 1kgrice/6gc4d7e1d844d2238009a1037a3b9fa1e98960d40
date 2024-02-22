include_ancestors = local_assigns[:include_ancestors] || false
include_children = local_assigns[:include_children] || false
total_count = local_assigns[:total_count] || categories.length

json.cache! ['api', 'v1', 'categories', collection_cache_key(categories)], expires_in: 1.hour do
  json.total total_count
  json.categories do 
    json.array!(categories) do |category|
      json.partial! partial: 'api/v1/categories/category', 
      locals: {
        category: category, 
        category_stats: category.stats,
        include_children: include_children, 
        include_ancestors: include_ancestors
      }
    end
  end
end