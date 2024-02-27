class AddIndexOnLongSlugToCategories < ActiveRecord::Migration[7.1]
  def change
    add_index :categories, :long_slug, unique: true, where: "(long_slug IS NOT NULL AND long_slug != '')"
  end
end
