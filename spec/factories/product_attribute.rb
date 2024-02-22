FactoryBot.define do
  factory :product_attribute do
    association :product
    sequence(:name) { |n| "Attribute #{n}" }
    value { "Value for Attribute" }
  end
end
