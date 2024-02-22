class ModifyReviewCountsColumnInProducts < ActiveRecord::Migration[7.0]
  def change
    change_column :products,
                  :rating_counts,
                  :integer,
                  array: true,
                  default: [0, 0, 0, 0, 0],
                  null: true
  end
end
