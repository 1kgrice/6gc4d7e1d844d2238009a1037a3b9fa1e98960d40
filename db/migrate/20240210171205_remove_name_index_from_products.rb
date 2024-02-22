class RemoveNameIndexFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_index :products, name: "index_products_on_name"
  end
end
