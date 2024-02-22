class AddIndexOnRatingCountsTotalToProducts < ActiveRecord::Migration[7.1]
  def change
    add_index :products, :rating_counts_total
  end
end
