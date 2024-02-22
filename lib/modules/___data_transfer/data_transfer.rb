# frozen_string_literal: true

module DataTransfer
  class DataTransfer
    # DOMAIN = 'http://localhost:3000'
    DOMAIN = "https://gumtective.com"
    API_BASE = "/api/v1/service/"

    def self.transfer(klass, object)
      serialized_product_json = serialize(klass, object)
      uri = build_uri(klass)
      headers = default_headers

      puts "Sending #{klass} to #{uri}"
      Net::HTTP.post(uri, serialized_product_json, headers)
    end

    def self.serialize(klass, object)
      serializer_class = case klass.to_s
      when 'Product'
        'ProductSerializer'
      when 'ProductReference'
        'ProductReferenceSerializer'
      end
      Object.const_get(serializer_class).new(object).serializable_hash.to_json
    end

    def self.build_uri(klass)
      endpoint = case klass.to_s
      when 'Product'
        'products'
      when 'ProductReference'
        'product_references'
      end
      URI.parse("#{DOMAIN}#{API_BASE}#{endpoint}")
    end

    def self.default_headers
      {
        "Content-Type" => "application/json",
        "GOLDEN_TICKET" => 'ilemojuba'
      }
    end
  end
end
