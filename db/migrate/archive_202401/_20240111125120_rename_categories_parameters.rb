class RenameCategoriesParameters < ActiveRecord::Migration[7.0]
  def change
    rename_column :categories, :isRoot, :is_root
    rename_column :categories, :isNested, :is_nested
  end
end
