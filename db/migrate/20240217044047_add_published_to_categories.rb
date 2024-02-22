class AddPublishedToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :published, :boolean, default: true
  end
end
