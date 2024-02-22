module ProductCallbacks
  extend ActiveSupport::Concern

  included do
    after_create :create_product_reference!, unless: :meta
    after_save :recalculate_rating!, if: -> { saved_change_to_attribute?(:rating_counts) }
  end
end