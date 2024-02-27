class AddRatingCountsTotalToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :rating_counts_total, :integer, default: 0
  end
end
