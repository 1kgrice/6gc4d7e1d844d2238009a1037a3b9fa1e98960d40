class ProductAttribute < ApplicationRecord
  belongs_to :product

  validates :name, presence: true
  validates :value, presence: true
end
