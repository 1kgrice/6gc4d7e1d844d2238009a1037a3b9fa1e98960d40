include_ancestors = local_assigns[:include_ancestors] || false
include_children = local_assigns[:include_children] || false

json.category do
  json.cache! ['api', 'v1', 'category', object_cache_key(category), include_ancestors, include_children], expires_in: 1.hour do
    json.partial! partial: 'api/v1/categories/category', locals: { 
      category: category, 
      include_children: include_children,
      include_ancestors: include_ancestors
    }
  end
end
