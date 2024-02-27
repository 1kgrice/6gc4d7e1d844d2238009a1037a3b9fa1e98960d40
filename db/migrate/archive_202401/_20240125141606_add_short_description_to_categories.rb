class AddShortDescriptionToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :short_description, :string
  end
end
