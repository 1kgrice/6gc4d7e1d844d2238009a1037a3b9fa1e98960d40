class RenameCategoriesLongNameToLongSlug < ActiveRecord::Migration[7.1]
  def change
    rename_column :categories, :long_name, :long_slug
  end
end
