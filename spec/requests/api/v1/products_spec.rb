require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :request do
  describe 'GET /api/v1/products' do
    let!(:products) { create_list(:product, 9, :published) }
    let!(:unpublished_products) { create_list(:product, 5, :unpublished) }

    context 'without parameters' do
      before { get '/api/v1/products' }

      it 'returns all published products' do
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['products'].count).to eq(products.count)
      end

      it 'does not return unpublished products' do
        unpublished_ids = unpublished_products.map(&:id)
        returned_ids = JSON.parse(response.body)['products'].map { |p| p['id'] }
        expect(returned_ids & unpublished_ids).to be_empty
      end
    end

    context 'with from parameter' do
      before { get '/api/v1/products', params: { from: 5 } }

      it 'returns products starting from the offset' do
        expect(response).to have_http_status(:success)
        returned_ids = JSON.parse(response.body)['products'].map { |p| p['id'] }
        expect(returned_ids).to eq(products[5..].map(&:id))
      end
    end

    context 'with rating parameter' do
      before(:each) do
        DatabaseCleaner.clean_with(:truncation)
      end
      
      # Define products with varying ratings
      let!(:rating_1_product) { create(:product, :published, rating_counts: [100, 0, 0, 0, 0]) } # rating: 1.0
      let!(:rating_2_product) { create(:product, :published, rating_counts: [0, 100, 0, 0, 0]) } # rating: 2.0
      let!(:rating_3_product) { create(:product, :published, rating_counts: [0, 0, 100, 0, 0]) } # rating: 3.0
      let!(:rating_4_product) { create(:product, :published, rating_counts: [0, 0, 0, 100, 0]) } # rating: 4.0
      let!(:rating_5_product) { create(:product, :published, rating_counts: [0, 0, 0, 0, 100]) } # rating: 5.0
    
      # Dynamically generate tests for each rating value
      (1..5).each do |rating|
        context "when rating is #{rating}" do
          before { get '/api/v1/products', params: { rating: rating } }
    
          it "returns products with rating greater than or equal to #{rating}" do
            expect(response).to have_http_status(:success)
            json_response = JSON.parse(response.body)
            returned_ids = json_response['products'].map { |p| p['id'] }
    
            expected_ids = (rating..5).map { |r| send("rating_#{r}_product").id }
            expected_ids.each do |id|
              expect(returned_ids).to include(id), "Expected returned IDs to include product with rating #{rating} but got #{returned_ids}"
            end
    
            # Ensure products with lower ratings are not included
            (1...rating).each do |r|
              expect(returned_ids).not_to include(send("rating_#{r}_product").id)
            end
          end
        end
      end
    end
    

  end

  context 'with creator parameter' do
    let!(:creator) { create(:creator) }
    let!(:other_creator) { create(:creator) }
  
    let!(:product_from_creator) do 
      create(:product, :published, creator: creator, price_cents: 5000) 
    end
    let!(:product_from_other_creator) do 
      create(:product, :published, creator: other_creator, price_cents: 5000) 
    end
  
    before { get '/api/v1/products', params: { creator: creator.username } }
  
    it 'returns products by the specified creator only' do
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      returned_ids = json_response['products'].map { |p| p['id'] }
  
      expect(returned_ids).to include(product_from_creator.id)
      expect(returned_ids).not_to include(product_from_other_creator.id)
    end
  end
  

  context 'with min_price and max_price parameters' do
    before do
      DatabaseCleaner.clean_with(:truncation)
    end
    let!(:cheap_product) { create(:product, :published, price_cents: 1000) }
    let!(:expensive_product) { create(:product, :published, price_cents: 9000) }

    before { get '/api/v1/products', params: { min_price: 2000, max_price: 8000 } }

    it 'returns products within the price range' do
      expect(response).to have_http_status(:success)
      returned_ids = JSON.parse(response.body)['products'].map { |p| p['id'] }
      expect(returned_ids).not_to include(cheap_product.id)
      expect(returned_ids).not_to include(expensive_product.id)
    end
  end

  context "with is_pwyw parameter" do
    let!(:pwyw_products) { create_list(:product, 3, :published, :pwyw) }
    let!(:fixed_price_products) { create_list(:product, 3, :published, :not_pwyw) }

    before do
      get '/api/v1/products', params: { pwyw: true }
    end

    it 'returns only pay what you want products' do
      expect(response).to have_http_status(:success)
      returned_ids = JSON.parse(response.body)['products'].map { |p| p['id'] }
      expect(returned_ids).to include(*pwyw_products.map(&:id))
      expect(returned_ids).not_to include(*fixed_price_products.map(&:id))
    end
  end


  describe 'from named scope' do
    let!(:creator1) { create(:creator) }
    let!(:creator2) { create(:creator) }
    let!(:creator3) { create(:creator) }
    let!(:products) do
      [
        create(:product, :published, rating_counts: [0,0,50,0,0], sales_count: 30, created_at: 2.days.ago, creator_id: creator1.id),
        create(:product, :published, rating_counts: [0,0,0,0,100], sales_count: 60, created_at: 1.day.ago, creator_id: creator2.id),
        create(:product, :published, rating_counts: [0,0,0,75,0], sales_count: 45, created_at: 3.days.ago, creator_id: creator3.id)
      ]
    end

    context 'staff picks' do
      before { get '/api/v1/products', params: { staff_picks: true } }

      it 'returns products sorted by rating desc, rating_counts_total desc, and created_at desc' do
        expect(response).to have_http_status(:success)
        returned_ids = JSON.parse(response.body)['products'].map { |p| p['id'] }
        expected_order = products.sort_by { |p| [-p.rating, -p.rating_counts_total, -p.created_at.to_i] }.map(&:id)
        expect(returned_ids).to eq(expected_order)
      end
    end

    context 'featured' do
      let!(:product1_creator1) do
        create(:product, creator_id: creator1.id, sales_count: 100, rating_counts: [0,0,0,0,100], created_at: 1.week.ago)
      end
      let!(:product2_creator1) do
        create(:product, creator_id: creator1.id, sales_count: 200, rating_counts: [0,0,0,200,0], created_at: 2.days.ago)
      end
      let!(:product1_creator2) do
        create(:product, creator_id: creator2.id, sales_count: 50, rating_counts: [0,0,0,0,50], created_at: 3.days.ago)
      end
      let!(:product2_creator2) do
        create(:product, creator_id: creator2.id, sales_count: 150, rating_counts: [0,0,0,150,0], created_at: 4.days.ago)
      end
      let!(:product1_creator3) do
        create(:product, creator_id: creator3.id, sales_count: 200, rating_counts: [0,0,0,200,0], created_at: 2.days.ago)
      end

      it 'returns the best selling product for each creator' do
        # Call the featured scope
        featured_products = Product.featured.to_a

        # Expectations
        expect(featured_products).to include(product2_creator1, product2_creator2, product1_creator3)
        expect(featured_products).not_to include(product1_creator1, product1_creator2)

        # Ensure only the best selling products per creator are included
        expect(featured_products.size).to eq(3)
      end
    end
  end

  context 'with name parameter' do
    let!(:specific_product) { create(:product, :published, name: 'UniqueName') }

    before { get '/api/v1/products', params: { name: 'UniqueName' } }

    it 'returns products with the specified name' do
      expect(response).to have_http_status(:success)
      returned_ids = JSON.parse(response.body)['products'].map { |p| p['id'] }
      expect(returned_ids).to include(specific_product.id)
    end
  end

  describe "GET /api/v1/products/search" do
    let!(:tech_product) { create(:product, published: true, tags: ['tech', 'innovation']) }
    let!(:sale_product) { create(:product, published: true, tags: ['sale', 'offer']) }
    let!(:combo_product) { create(:product, published: true, tags: ['tech', 'sale']) }

    context "without parameters" do
      before { get '/api/v1/products/search' }
    
      it "returns products along with top tags" do
    
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        
        expect(json_response).to have_key("top_tags")
        top_tags = json_response["top_tags"]
    
        expect(top_tags).to include({"name" => "tech", "taggings_count" => 2})
        expect(top_tags).to include({"name" => "innovation", "taggings_count" => 1})
        expect(top_tags).to include({"name" => "sale", "taggings_count" => 2})
      end
    end

    context 'with a single tag parameter' do
      it 'returns products tagged with that tag' do
        get '/api/v1/products/search', params: { tags: 'tech' }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        product_ids = json_response['products'].map { |p| p['id'] }
        expect(product_ids).to match_array([tech_product.id, combo_product.id])
      end
    end

    context 'with multiple tag parameters' do
      it 'returns products tagged with both tags' do
        get '/api/v1/products/search', params: { tags: 'tech,sale' }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        product_ids = json_response['products'].map { |p| p['id'] }
        expect(product_ids).to contain_exactly(combo_product.id)
      end
    end

    context 'wich excessive tag parameters' do
      it 'returns no products' do
        get '/api/v1/products/search', params: { tags: 'tech,innovation,sale' }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response['products']).to be_empty
      end
    end
  end

  describe "GET /api/v1/products/search with complex parameters" do
    context "without offset" do
      let!(:category_3d_avatars) { create(:category, name: 'Avatars', slug: 'avatars', long_slug: '3d/avatars') }
      let!(:category_other) { create(:category, name: 'Other', slug: 'other', long_slug: 'other') }
      let!(:product_in_category_with_tags_and_price) do
        create(:product, published: true, category_slugs: [category_3d_avatars.long_slug], tags: ['tag1', 'tag2'], price_cents: 2000, rating_counts: [0, 0, 100, 0, 0]) # $20, rating: 3
      end
      let!(:product_out_of_price_range) do
        create(:product, published: true, category_slugs: [category_3d_avatars.long_slug], tags: ['tag1', 'tag2'], price_cents: 5000, rating_counts: [0, 0, 100, 0, 0]) # $50, rating: 3
      end
      let!(:product_in_category_with_different_tags) do
        create(:product, published: true, category_slugs: [category_3d_avatars.long_slug], tags: ['tag3'], price_cents: 2000, rating_counts: [0, 0, 100, 0, 0]) # $20, rating: 3
      end
      let!(:product_in_different_category) do
        create(:product, published: true, category_slugs: [category_other.long_slug], tags: ['tag1', 'tag2'], price_cents: 2000, rating_counts: [0, 0, 100, 0, 0]) # $20, rating: 3
      end
    
      before do
        get '/api/v1/products/search', params: {
          category: category_3d_avatars.long_slug,
          rating: 3,
          tags: 'tag1,tag2',
          min_price: 1000,
          max_price: 3000
        }
      end
    
      it "filters products by category, rating, tags, and price range" do
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        product_ids = json_response['products'].map { |p| p['id'] }
        
        expect(product_ids).to contain_exactly(product_in_category_with_tags_and_price.id)
        expect(product_ids).not_to include(product_out_of_price_range.id)
        expect(product_ids).not_to include(product_in_category_with_different_tags.id)
        expect(product_ids).not_to include(product_in_different_category.id)
      end
    end  
    context "with 'from' parameter" do
      let!(:creator1) { create(:creator) }
      let!(:creator2) { create(:creator) }
      let!(:category_3d_avatars) { create(:category, name: 'Avatars', slug: 'avatars', long_slug: '3d/avatars') }
      let!(:products_creator1) do
        create_list(:product, 20, published: true, creator: creator1, category_slugs: [category_3d_avatars.long_slug], tags: ['tag1', 'tag2'], price_cents: 2000, rating_counts: [0, 0, 100, 0, 0]) # $20, rating: 3
      end
      let!(:products_creator2) do
        create_list(:product, 20, published: true, creator: creator2, price_cents: 2000, rating_counts: [0, 0, 100, 0, 0]) # $20, rating: 3
      end
      let(:from) { 10 }
      it "offsets products by the provided 'from' value and respects the maximum batch limit" do
        get '/api/v1/products/search', params: {
          category: category_3d_avatars.long_slug,
          rating: 3,
          tags: 'tag1,tag2',
          min_price: 1000,
          max_price: 3000,
          from: from
        }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        product_ids = json_response['products'].map { |p| p['id'] }
        
        limit = from+DEFAULT_LIMIT[:products]-1
        expected_products_ids_after_offset = products_creator1.pluck(:id)[from..limit]
        expect(product_ids).to contain_exactly(*expected_products_ids_after_offset)
      end

      it "filters by creator and offsets products by the provided 'from' value" do
        get '/api/v1/products/search', params: {
          creator: creator2.username,
          from: from
        }
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        product_ids = json_response['products'].map { |p| p['id'] }
    
        creator_products = products_creator2
        limit = from + DEFAULT_LIMIT[:products] - 1
        expected_products_ids_after_offset = products_creator2.pluck(:id)[from..limit]
        expect(product_ids).to contain_exactly(*expected_products_ids_after_offset)
      end
    end
  end
end