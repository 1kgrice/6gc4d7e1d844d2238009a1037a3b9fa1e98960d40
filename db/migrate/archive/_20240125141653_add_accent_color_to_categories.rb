class AddAccentColorToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :accent_color, :string
  end
end
