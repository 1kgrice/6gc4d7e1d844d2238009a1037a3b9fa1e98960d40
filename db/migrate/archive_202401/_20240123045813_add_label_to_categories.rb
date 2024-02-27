class AddLabelToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :label, :string
  end
end
