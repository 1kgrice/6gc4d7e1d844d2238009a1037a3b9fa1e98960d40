require 'rails_helper'

RSpec.describe ProductAttribute, type: :model do
  describe 'associations' do
    it { should belong_to(:product) }
  end

  describe 'validations' do
    subject { create(:product_attribute) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:value) }
  end
end
