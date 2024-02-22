FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    sequence(:slug) { |n| "category-#{n}" }
    order { rand(0..100) }
    is_root { false }
    is_nested { false }
    short_description { "A short description of the category." }
    accent_color { %w[red teal yellow dark-yellow purple].sample }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
    parent_id { nil }

    after(:build) do |category|
      # Ensure the long_slug logic aligns with your model's expectations
      category.long_slug = category.parent ? "#{category.parent.long_slug}/#{category.slug}" : category.slug
    end

    trait :root do
      is_root { true }
      parent_id { nil }
      after(:build) { |category| category.long_slug = category.slug }
    end

    trait :with_parent do
      after(:build) do |category|
        # Using FactoryBot's `build` to avoid database persistence for parent
        parent_category = build(:category, :root) # Ensures parent is a root category
        category.parent = parent_category
        category.is_root = false
        category.long_slug = "#{parent_category.long_slug}/#{category.slug}"
      end
    end

    trait :with_children do
      transient { children_count { 3 } }

      after(:create) do |category, evaluator|
        # This will create a specified number of child categories
        create_list(:category, evaluator.children_count, parent: category)
        category.update_column(:is_nested, true) # Direct database update to avoid callbacks
      end
    end

    trait :with_deep_nesting do
      transient { nesting_level { 2 } }

      after(:create) do |category, evaluator|
        # Recursively creates nested children categories
        create_nested_children(category, evaluator.nesting_level)
      end
    end
  end

  trait :with_specific_slug do
    transient do
      specific_slug { 'default-slug' } # Default value to ensure it always has a value
    end

    after(:build) do |category, evaluator|
      category.slug = evaluator.specific_slug
      category.long_slug = evaluator.specific_slug # Adjust based on your needs
    end
  end

  # Recursive method to create nested children categories
  def create_nested_children(parent, levels)
    return if levels <= 0

    child = create(:category, :with_parent, parent: parent)
    create_nested_children(child, levels - 1)
  end
end
