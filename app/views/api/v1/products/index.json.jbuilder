total_count = local_assigns[:total_count] || products.length
top_tags = local_assigns[:top_tags]

json.total total_count
json.count products.length
json.products do 
  json.array!(products) do |product|
    json.cache! ['api', 'v1', 'product', object_cache_key(product)], expires_in: 1.hour do
      json.partial! partial: 'api/v1/products/product', locals: {product: product}
    end
  end
end

json.top_tags do 
  json.array!(top_tags) do |tag|
    json.partial! partial: 'api/v1/tags/tag', locals: {tag: tag}
  end
end if top_tags.present?
