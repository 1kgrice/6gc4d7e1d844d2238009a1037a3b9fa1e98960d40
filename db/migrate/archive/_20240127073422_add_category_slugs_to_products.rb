class AddCategorySlugsToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :category_slugs, :string, array: true, default: []
    add_index :products, :category_slugs, using: 'gin'
  end
end
