class AddMetaCategoryToGProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :g_products, :meta_category, :string
  end
end
