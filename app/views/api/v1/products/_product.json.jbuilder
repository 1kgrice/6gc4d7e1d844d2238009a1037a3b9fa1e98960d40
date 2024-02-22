show_in_full = local_assigns[:show_in_full] || false

json.id product.id
json.permalink product.permalink
json.name product.name
json.creator do
  json.cache! ['api', 'v1', 'product-creator', object_cache_key(product.creator)], expires_in: 1.hour do
    json.partial! partial: 'api/v1/creators/creator', locals: { creator: product.creator, variant: :brief }
  end
end 
json.ratings do
  json.count product.rating_counts
  json.average product.avg_rating
end
json.sales_count product.sales_count
json.price product.price_cents
json.currency product.currency_code
json.is_pay_what_you_want product.is_pwyw
json.pwyw_suggested_price_cents product.pwyw_suggested_price_cents
json.url product.full_url
json.covers do
  json.cache! ['api', 'v1', 'product-covers', collection_cache_key(product.covers)], expires_in: 1.hour do
    json.array! product.covers do |cover|
      json.partial! partial: 'api/v1/partials/embed_media', locals: { media: cover }
    end
  end
end
json.options do
  json.cache! ['api', 'v1', 'product-options', collection_cache_key(product.product_options)], expires_in: 1.hour do
    json.array! product.product_options do |option|
      json.partial! partial: 'api/v1/products/product_option', locals: { product_option: option }
    end
  end
end

if show_in_full
  json.description_html product.description_html
  json.summary product.summary
  json.p_attributes do
    json.array! product.product_attributes do |attribute|
      json.name attribute.name
      json.value attribute.value
    end
  end
  json.custom_button_text_option product.custom_button_text_option
  json.custom_view_content_button_text product.custom_view_content_button_text
end

json.main_cover_id product.main_cover_id
json.carousel_items product.images
