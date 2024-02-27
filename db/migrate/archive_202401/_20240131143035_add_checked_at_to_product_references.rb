class AddCheckedAtToProductReferences < ActiveRecord::Migration[7.1]
  def change
    add_column :product_references, :checked_at, :timestamp
  end
end
