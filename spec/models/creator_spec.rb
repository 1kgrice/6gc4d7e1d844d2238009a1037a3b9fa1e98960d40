require 'rails_helper'

RSpec.describe Creator, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:products).dependent(:nullify) }
  end

  describe 'devise modules' do
    it 'includes Devise modules for authentication' do
      devise_modules = [:database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :jwt_authenticatable]
      expect(Creator.devise_modules).to include(*devise_modules)
    end
  end  

  describe '#profile_url' do
    let(:creator) { create(:creator, username: 'testuser') }

    before do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("development"))
      stub_const("Creator::BASE_DOMAIN", "example.com")
    end

    it 'returns the correct profile URL in development' do
      expect(creator.profile_url).to eq("http://testuser.example.com")
    end

    it 'returns the correct profile URL in production' do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new("production"))
      expect(creator.profile_url).to eq("https://testuser.example.com")
    end
  end
end
