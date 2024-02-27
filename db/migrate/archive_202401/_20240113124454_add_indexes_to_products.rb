class AddIndexesToProducts < ActiveRecord::Migration[7.0]
  def change
    add_index :products, :name
    add_index :products, :permalink
    add_index :products, :price_cents
    add_index :products, :url
    add_index :products, :meta_url
    add_index :products, :processed
  end
end
