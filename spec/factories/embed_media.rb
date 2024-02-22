FactoryBot.define do
  factory :embed_media do
    association :mediaable, factory: :product

    original_url { "http://example.com/media" }
    url { "<iframe src='http://example.com/embedded_media'></iframe>" }
    thumbnail { "http://example.com/thumbnail.jpg" }
    external_id { SecureRandom.hex(20) }
    media_type { 'oembed' }
    width { 800 }
    height { 600 }
  end
end
