json.meta do
  json.page pagination[:page]
  json.per_page pagination[:per_page]
  json.total_pages pagination[:total_pages]
  json.next_page pagination[:next_page] if pagination[:next_page]
  json.previous_page pagination[:previous_page] if pagination[:previous_page]
  json.total_count pagination[:total_count] if pagination[:total_count]
end