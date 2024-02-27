class AddMetaCountToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :meta_count, :integer
  end
end
