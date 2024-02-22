require 'rails_helper'

RSpec.describe "Api::V1::Categories", type: :request do
  describe 'GET /api/v1/categories' do
    context 'without parameters' do
      before do
        create_list(:category, 20)
        get '/api/v1/categories'
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the correct total count of categories' do
        expect(json_response['total']).to eq(20)
      end

      it 'paginates results according to the default limit' do
        expect(json_response['categories'].size).to be <= DEFAULT_LIMIT[:categories]
      end
    end

    describe 'GET /api/v1/categories/:long_slug' do
      let!(:category) { create(:category, long_slug: '3d', name: '3D', is_root: true) }
      let!(:child_categories) do
        create_list(:category, 2, parent_id: category.id)
      end
  
      before do
        get "/api/v1/categories/#{category.long_slug}"
      end
  
      it 'returns a successful response' do
        expect(response).to have_http_status(:success)
      end
  
      it 'returns the correct category details focusing on structure' do
        expect(json_response['category']['id']).to eq(category.id)
        expect(json_response['category']['long_slug']).to eq('3d')
        expect(json_response['category']['is_root']).to be true
      end
  
      it 'includes the correct number of children in the response' do
        expect(json_response['category']['children'].size).to eq(child_categories.size)
      end
  
      it 'verifies the structure for the first child category' do
        child = json_response['category']['children'].first
        expect(child['long_slug']).to include('3d/')
        expect(child['is_root']).to be false
      end
    end

    context 'when requesting root categories' do
      let!(:root_categories) { create_list(:category, 5, is_root: true) }
      let!(:non_root_categories) { create_list(:category, 3, is_root: false) }

      before do
        get '/api/v1/categories', params: { root: true }
      end

      it 'returns only root categories' do
        expect(json_response['total']).to eq(root_categories.count)
        expect(json_response['categories'].all? { |c| c['is_root'] }).to be true
      end

      it 'includes expected attributes in the response' do
        category_response = json_response['categories'].first
        expect(category_response).to include('id', 'name', 'slug', 'long_slug', 'is_root', 'short_description', 'created_at', 'updated_at', 'children')
        expect(category_response['is_root']).to be true
      end
    end

    context 'when filtering by long_slug' do
      let!(:root_category) { create(:category, slug: '3d', long_slug: '3d', name: '3D', is_root: true) }
      let!(:category) { create(:category, slug: 'avatars', long_slug: '3d/avatars', name: 'Avatars', parent_id: root_category.id) }
      let!(:child_categories) do
        create_list(:category, 10, parent_id: category.id)
      end
  
      before do
        get '/api/v1/categories', params: { by_long_slug: '3d%2Favatars' }
      end
  
      it 'returns a successful response' do
        expect(response).to have_http_status(:success)
      end
  
      it 'returns the correct category' do
        expect(json_response['total']).to eq(1)
        expect(json_response['categories'].first['id']).to eq(category.id)
        expect(json_response['categories'].first['long_slug']).to eq('3d/avatars')
      end
  
      it 'includes the correct children in the category' do
        expect(json_response['categories'].first['children'].length).to eq(child_categories.count)
        child_slugs = json_response['categories'].first['children'].map { |child| child['slug'] }
        expect(child_slugs).to match_array(child_categories.map(&:slug))
      end
    end
  end
end
