class AddIsTestToGProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :g_products, :is_test, :boolean, default: false
  end
end
