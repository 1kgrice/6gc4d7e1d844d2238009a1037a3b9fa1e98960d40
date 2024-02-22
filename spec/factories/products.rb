# spec/factories/products.rb
FactoryBot.define do
  factory :product do
    association :creator
    name { Faker::Commerce.product_name }
    url { Faker::Internet.url }
    price_cents { rand(100..10_000) }
    currency_code { "usd" }
    published { Faker::Boolean.boolean }
    category_slugs { [] }
    images { [] }
    nsfw { Faker::Boolean.boolean }
    rating_counts { Array.new(5) { rand(0..100) } }
    is_pwyw { Faker::Boolean.boolean }
    pwyw_suggested_price_cents { rand(100..10_000) }
    sequence(:permalink) { |n| "#{Faker::Internet.slug}#{n}" }
    
    rating_counts_total { rating_counts.sum }
    rating { rating_counts.sum.positive? ? rating_counts.each_with_index.sum { |count, index| (index + 1) * count }.to_f / rating_counts.sum : 0 }

    transient do
      tags { [] }
    end

    after(:create) do |product, evaluator|
      product.tag_list.add(*evaluator.tags, parse: true)
      product.save
    end

    trait :published do
      published { true }
    end

    trait :unpublished do
      published { false }
    end

    trait :pwyw do
      is_pwyw { true }
    end

    trait :not_pwyw do
      is_pwyw { false }
    end

    trait :with_price do
      price_cents { rand(100..10_000) }
    end

    trait :with_ratings do
      rating_counts { Array.new(5) { rand(1..100) } }
      after(:create, &:recalculate_rating!)
    end

    trait :without_ratings do
      rating_counts { [0, 0, 0, 0, 0] }
      rating_counts_total { 0 }
      rating { 0 }
    end

    trait :with_attributes do
      after(:create) do |product|
        create_list(:product_attribute, 3, product: product)
      end
    end

    trait :with_options do
      after(:create) do |product|
        create_list(:product_option, 3, product: product)
      end
    end
  end
end
