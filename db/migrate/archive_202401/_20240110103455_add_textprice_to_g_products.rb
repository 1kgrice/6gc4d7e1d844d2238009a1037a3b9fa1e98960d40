class AddTextpriceToGProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :g_products, :textprice, :string
  end
end
