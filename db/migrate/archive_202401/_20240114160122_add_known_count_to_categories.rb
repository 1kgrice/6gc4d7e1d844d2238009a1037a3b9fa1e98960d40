class AddKnownCountToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :known_count, :integer
  end
end
