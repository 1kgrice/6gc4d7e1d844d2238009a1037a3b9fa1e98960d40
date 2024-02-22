require 'rails_helper'

RSpec.describe Category, type: :model do
  subject(:category) { build(:category) }

  describe 'associations' do
    it { is_expected.to belong_to(:parent).class_name('Category').optional }
    it { is_expected.to have_many(:children).class_name('Category').with_foreign_key('parent_id') }
    it { is_expected.to have_one(:stats).class_name('CategoryStat').dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:meta_url).allow_blank }
    it { is_expected.to validate_uniqueness_of(:long_slug).case_insensitive.allow_blank }
  end

  describe 'callbacks' do
    it 'assigns slugs after saving if name has changed' do
      category.name = "New Category Name"
      category.save
      expect(category.slug).to eq(category.generate_slug)
      expect(category.long_slug).to eq(category.generate_long_slug)
    end
  end

  describe 'methods' do
    describe '#generate_slug' do
      it 'generates a parameterized slug based on the name' do
        category.name = "Test Category & Stuff"
        expect(category.generate_slug).to eq('test-category-and-stuff')
      end
    end

    describe '#generate_long_slug' do
      context 'when the category has multiple ancestors' do
        let(:root_category) { create(:category, :root, name: 'Root') }
        let(:child_category) { create(:category, parent: root_category, name: 'Child') }
        let(:grandchild_category) { create(:category, parent: child_category, name: 'Grandchild') }

        it 'generates a long slug that includes all ancestor slugs' do
          expect(grandchild_category.generate_long_slug).to eq('root/child/grandchild')
        end
      end
    end

    describe 'scopes' do
      describe '.root' do
        let!(:root_category) { create(:category, :root) }
        let!(:non_root_category) { create(:category) }
    
        it 'returns only root categories' do
          expect(Category.root).to include(root_category)
          expect(Category.root).not_to include(non_root_category)
        end
      end
    
      describe '.by_slug' do
        let!(:category) do
          # Create the category with the factory defaults
          cat = create(:category)
          # Directly set the slug to the desired value
          cat.update(slug: 'specific-slug', long_slug: 'specific-slug')
          cat
        end
      
        it 'returns categories with matching slug' do
          # Now, the expectation should match since we've forcefully set the slug
          expect(category.slug).to eq('specific-slug')
          # Test the scope
          expect(Category.by_slug('specific-slug')).to include(category)
        end
      end    
      
    end    
  end

  describe 'Inheritable Concern' do
    describe 'associations and utility methods' do
      let!(:root_category) { create(:category, is_root: true) }
      let!(:child_category) { create(:category, parent: root_category) }
      let!(:grandchild_category) { create(:category, parent: child_category) }

      it 'correctly identifies root and nested categories' do
        expect(root_category.is_root).to be true
        expect(child_category.has_parent?).to be true
        expect(grandchild_category.has_children?).to be false
      end

      it 'correctly finds ancestors and all_children' do
        # Verify the direct parent-child relationships to diagnose the issue
        expect(child_category.parent).to eq(root_category)
        expect(grandchild_category.parent).to eq(child_category)
  
        # Testing the ancestors method
        expect(grandchild_category.ancestors).to contain_exactly(root_category, child_category)
  
        # Testing the all_children method
        expect(root_category.all_children).to contain_exactly(child_category, grandchild_category)
      end

      it 'updates is_nested upon changing children' do
        expect { grandchild_category.destroy }.to change { child_category.reload.is_nested }.from(true).to(false)
      end
    end

    describe 'scopes' do
      let!(:root_category) { create(:category, is_root: true) }
      let!(:nested_category) { create(:category, parent: root_category) }
  
      before do
        # Assuming here that `root_category` should automatically be marked as nested when it gets a child.
        # This might require manually triggering any logic that sets `is_nested` to true for `root_category`.
        root_category.reload # Ensure the state is fresh from the DB.
      end
  
      it 'filters nested categories' do
        # The expectation should verify that `root_category` is included in `Category.nested`,
        # as it has at least one child, making it a "nested" category in the context of your application.
        expect(Category.nested).to include(root_category)
  
        # Additionally, confirming that a child category without its own children is not considered "nested".
        expect(Category.nested).not_to include(nested_category)
      end
    end
  end

end
