require 'rails_helper'

RSpec.describe ProductOption, type: :model do
  describe 'associations' do
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:quantity_left).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:price_difference_cents).allow_nil }
  end
end
