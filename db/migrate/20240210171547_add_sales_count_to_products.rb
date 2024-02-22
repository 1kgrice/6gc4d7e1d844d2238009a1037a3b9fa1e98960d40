class AddSalesCountToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :sales_count, :integer, default: 0
    add_index :products, :sales_count
  end
end
