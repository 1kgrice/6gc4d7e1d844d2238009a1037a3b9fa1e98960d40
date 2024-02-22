# app/models/product_option.rb
class ProductOption < ApplicationRecord
  belongs_to :product

  validates :name, presence: true
  validates :quantity_left, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :price_difference_cents, numericality: true, allow_nil: true
end
