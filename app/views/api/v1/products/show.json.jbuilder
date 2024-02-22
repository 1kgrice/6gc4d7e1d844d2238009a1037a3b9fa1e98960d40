json.product do
  json.cache! ['api', 'v1', 'product', object_cache_key(product)], expires_in: 1.hour do
    json.partial! partial: 'api/v1/products/product', locals: { product: product, show_in_full: true}
  end
end