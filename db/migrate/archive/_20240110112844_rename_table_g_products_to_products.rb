class RenameTableGProductsToProducts < ActiveRecord::Migration[7.0]
  def change
    rename_table :g_products, :products
  end
end
