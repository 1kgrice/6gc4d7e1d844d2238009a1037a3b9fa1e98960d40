class AddReviewCountTotalToProductReferences < ActiveRecord::Migration[7.1]
  def change
    add_column :product_references, :review_count_total, :integer, default: 0
  end
end
