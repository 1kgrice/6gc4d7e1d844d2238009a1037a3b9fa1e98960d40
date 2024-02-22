class AddPriceCentsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :price_cents, :integer, default: 0, null: false
  end
end
