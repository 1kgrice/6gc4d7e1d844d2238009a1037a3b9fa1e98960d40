json.product do
  json.permalink data[:permalink]
  json.creator do
    json.username data[:username]
  end
end