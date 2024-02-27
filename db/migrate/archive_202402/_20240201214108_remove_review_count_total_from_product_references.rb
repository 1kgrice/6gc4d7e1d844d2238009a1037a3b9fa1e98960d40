class RemoveReviewCountTotalFromProductReferences < ActiveRecord::Migration[7.1]
  def change
    remove_column :product_references, :review_count_total
  end
end
