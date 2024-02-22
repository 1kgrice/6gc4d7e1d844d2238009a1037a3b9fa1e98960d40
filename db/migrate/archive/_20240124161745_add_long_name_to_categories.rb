class AddLongNameToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :long_name, :string
  end
end
