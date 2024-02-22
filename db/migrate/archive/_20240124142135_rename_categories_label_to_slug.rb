class RenameCategoriesLabelToSlug < ActiveRecord::Migration[7.1]
  def change
    rename_column :categories, :label, :slug
  end
end
