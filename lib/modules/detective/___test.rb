require "open-uri"
require "selenium-webdriver"
require "rbconfig"
require "net/http"
require "uri"
require "nokogiri"
require "json"

url = "https://discover.gumroad.com/products/search?sort=featured&taxonomy=design"
uri = URI.parse(url)
response = Net::HTTP.get_response(uri)
parsed_response = JSON.parse(response.body)

puts parsed_response["products"][0]

# meta_script = parsed_response.css(".js-react-on-rails-component").last.text
