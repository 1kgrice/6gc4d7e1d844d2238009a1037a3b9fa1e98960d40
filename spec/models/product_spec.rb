require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should belong_to(:creator).optional }
    it { should have_one(:product_reference).dependent(:nullify) }
    it { should have_many(:product_attributes).dependent(:destroy) }
    it { should have_many(:product_options).dependent(:destroy) }
    it { should have_many(:covers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(Product::MAX_NAME_LENGTH) }
    it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_numericality_of(:price_cents).is_greater_than_or_equal_to(0).allow_nil }
    it { should allow_value("example-permalink").for(:permalink) }
    it { should_not allow_value("example permalink").for(:permalink) }
  end

  describe 'methods' do
    describe '#recalculate_rating!' do
      let(:product) { create(:product, rating_counts: [1, 2, 3, 4, 5]) }

      it 'correctly recalculates and updates the product rating' do
        product.recalculate_rating!
        expect(product.rating).to eq(3.6666666666666665) # (1*1 + 2*2 + 3*3 + 4*4 + 5*5) / 15
        expect(product.rating_counts_total).to eq(15) # sum of rating_counts
      end
    end


    describe '#rating_total' do
      let(:product) { create(:product, rating_counts: [1, 2, 3, 4, 5]) }

      it 'returns the correct total of rating counts' do
        expect(product.rating_total).to eq(15) # sum of [1, 2, 3, 4, 5]
      end
    end

    describe '#avg_rating' do
      let(:product) { create(:product, rating_counts: [1,1,1,1,2]) } #3.333333333

      it 'returns the average rating rounded to two decimal places' do
        expect(product.avg_rating).to eq(3.33)
      end
    end
  
    describe '#full_url' do
      let(:creator) { create(:creator, username: 'dvassalo') }
      let(:product) { create(:product, creator: creator, permalink: 'smallbets') }

      it 'returns the correct full URL of the product' do
        expect(product.full_url).to eq('https://dvassalo.localhost:3000/l/smallbets')
      end
    end

    describe '#select_new_main_cover' do
      let(:product) { create(:product) }
      let!(:cover1) { create(:embed_media, mediaable: product, created_at: 1.day.ago) }
      let!(:cover2) { create(:embed_media, mediaable: product) }

      context 'when a cover is removed and multiple covers exist' do
        it 'selects a new main cover' do
          product.select_new_main_cover(cover2, removing: true)
          expect(product.main_cover_id).to eq(cover1.external_id)
        end
      end

      context 'when the last cover is being removed' do
        it 'does not select a new main cover' do
          product.covers.destroy_all
          product.select_new_main_cover(cover1, removing: true)
          expect(product.main_cover_id).to be_nil
        end
      end

      context 'when adding a new cover' do
        it 'selects the oldest cover as the new main cover' do
          new_cover = create(:embed_media, mediaable: product)
          product.select_new_main_cover
          expect(product.main_cover_id).to eq(cover1.external_id)
        end
      end
    end
  end

  describe 'validations' do
    it 'validates price_cents is greater than or equal to MIN_SEARCHABLE_PRICE_CENT' do
      product = build(:product, price_cents: Product::MIN_SEARCHABLE_PRICE_CENT - 1)
      expect(product).not_to be_valid
      expect(product.errors[:price_cents]).to include("must be greater than or equal to #{Product::MIN_SEARCHABLE_PRICE_CENT}")
    end
  
    it 'validates price_cents is less than or equal to MAX_SEARCHABLE_PRICE_CENT' do
      product = build(:product, price_cents: Product::MAX_SEARCHABLE_PRICE_CENT + 1)
      expect(product).not_to be_valid
      expect(product.errors[:price_cents]).to include("must be less than or equal to #{Product::MAX_SEARCHABLE_PRICE_CENT}")
    end
  end

  describe 'validations' do
    it 'validates length of name does not exceed MAX_NAME_LENGTH' do
      product = build(:product, name: 'a' * (Product::MAX_NAME_LENGTH + 1))
      expect(product).not_to be_valid
      expect(product.errors[:name]).to include("is too long (maximum is #{Product::MAX_NAME_LENGTH} characters)")
    end
  end

  # In your spec
  describe 'validations' do
  it 'allows only valid currency codes' do
      valid_currency = Product::CURRENCY_CODES.sample
      invalid_currency = 'invalid'
      product_with_valid_currency = build(:product, currency_code: valid_currency)
      product_with_invalid_currency = build(:product, currency_code: invalid_currency)

      expect(product_with_valid_currency).to be_valid
      expect(product_with_invalid_currency).not_to be_valid
      expect(product_with_invalid_currency.errors[:currency_code]).to include("#{invalid_currency} is not a valid currency")
    end
  end

  describe 'scopes' do
    describe '.published' do
      let!(:published_product) { create(:product, published: true) }
      let!(:unpublished_product) { create(:product, published: false) }
    
      it 'returns only published products' do
        expect(Product.published).to include(published_product)
        expect(Product.published).not_to include(unpublished_product)
      end
    end

    describe '.available' do
      let!(:available_product) { create(:product, product_reference: create(:product_reference, available: true)) }
      let!(:unavailable_product) { create(:product, product_reference: create(:product_reference, available: false)) }
    
      it 'returns products based on availability' do
        expect(Product.available).to include(available_product)
        expect(Product.available).not_to include(unavailable_product)
      end
    end

    describe '.by_name' do
      let!(:product) { create(:product, name: 'UniqueProductName') }
    
      it 'returns products matching the name' do
        expect(Product.by_name('UniqueProductName')).to include(product)
        expect(Product.by_name('Nonexistent')).to be_empty
      end
    end
    
    describe 'numeric filters' do
      let!(:cheap_product) { create(:product, price_cents: 1000) }
      let!(:expensive_product) { create(:product, price_cents: 100000) }
    
      describe '.by_min_price' do
        it 'returns products with price above or equal to min price' do
          expect(Product.by_min_price(5000)).to include(expensive_product)
          expect(Product.by_min_price(5000)).not_to include(cheap_product)
        end
      end
    
      describe '.by_max_price' do
        it 'returns products with price below or equal to max price' do
          expect(Product.by_max_price(50000)).to include(cheap_product)
          expect(Product.by_max_price(50000)).not_to include(expensive_product)
        end
      end
    end
    
    describe '.newest' do
      let!(:older_product) { create(:product, created_at: 2.days.ago) }
      let!(:newer_product) { create(:product, created_at: 1.day.ago) }
    
      it 'returns products in descending order of creation' do
        expect(Product.newest).to eq([newer_product, older_product])
      end
    end
    
    describe '.best_selling' do
      let!(:best_seller) { create(:product, sales_count: 100) }
      let!(:average_seller) { create(:product, sales_count: 50) }
    
      it 'orders products by sales_count descending' do
        expect(Product.best_selling).to eq([best_seller, average_seller])
      end
    end
    
    describe '.by_category' do
      let!(:matching_product) { create(:product, category_slugs: ['match-slug', 'another-slug']) }
      let!(:non_matching_product) { create(:product, category_slugs: ['different-slug']) }
  
      it 'returns products with the specified category slug' do
        expect(Product.by_category('match-slug')).to include(matching_product)
        expect(Product.by_category('match-slug')).not_to include(non_matching_product)
      end
    end
  end

  describe 'Callbacks' do
    describe 'after_create :create_product_reference!' do
      context 'when product has no reference data' do
        let!(:product_without_reference) { create(:product, product_reference: nil) }
  
        it 'creates a product reference' do
          expect(product_without_reference.product_reference).not_to be_nil
        end
      end
    end

    describe 'after_save :recalculate_rating!' do
      let!(:product) { create(:product, rating_counts: [1, 1, 1, 1, 1]) }
    
      it 'recalculates rating when rating_counts change' do
        expect(product).to receive(:recalculate_rating!)
        product.update(rating_counts: [2, 2, 2, 2, 2])
      end
    
      it 'does not recalculate rating when other attributes change' do
        expect(product).not_to receive(:recalculate_rating!)
        product.update(name: 'New Product Name')
      end
    end
  end  
  describe 'Associations' do
    it 'has many product attributes' do
      product = create(:product)
      product_attributes = create_list(:product_attribute, 2, product: product)
      expect(product.product_attributes.size).to eq(2)
    end
  
    it 'deletes associated product attributes on product deletion' do
      product = create(:product)
      create(:product_attribute, product: product)
      expect { product.destroy }.to change(ProductAttribute, :count).by(-1)
    end
  end
  
end
