class RemoveKnownCountFromCategories < ActiveRecord::Migration[7.0]
  def change
    remove_column :categories, :known_count
  end
end
