class AddImageToGProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :g_products, :image, :string
  end
end
