class AddIndexOnSalesCountToProductReferences < ActiveRecord::Migration[7.1]
  def change
    add_index :product_references, :sales_count
  end
end
