class AddIndexOnSlugToCategories < ActiveRecord::Migration[7.1]
  def change
    add_index :categories, :slug
  end
end
