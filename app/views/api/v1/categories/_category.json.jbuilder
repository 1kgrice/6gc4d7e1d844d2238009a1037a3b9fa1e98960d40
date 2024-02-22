include_ancestors = local_assigns[:include_ancestors] || false
include_children = local_assigns[:include_children] || false
category_stats = local_assigns[:category_stats]


json.id category.id
json.name category.name
json.slug category.slug
json.long_slug category.long_slug
json.order category.order
json.is_root category.is_root
json.is_nested category.is_nested
json.short_description category.short_description
json.accent_color category.accent_color
json.partial! partial: 'api/v1/partials/timestamp', locals: { record: category }
json.ancestors do
  json.array!(category.ancestors) do |ancestor| 
    json.partial! partial: 'api/v1/categories/category', locals: {category: ancestor, include_children: false}
  end
end if include_ancestors
json.children do 
  json.array!(category.children.published.order(order: :asc)) do |category| 
    json.partial! partial: 'api/v1/categories/category', locals: {category: category, include_children: false}
  end
end if include_children

json.product_count category_stats&.product_count
json.creator_count category_stats&.creator_count
json.sales_count category_stats&.sales_count

