FactoryBot.define do
  factory :product_option do
    association :product
    name { "Default Option Name" }
    quantity_left { rand(0..100) } 
    price_difference_cents { rand(0..5000) }
  end
end