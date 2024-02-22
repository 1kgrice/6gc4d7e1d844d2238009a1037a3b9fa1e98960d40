class RemoveDescriptionFromProducts < ActiveRecord::Migration[7.1]
  def up
    remove_column :products, :description
  end

  def down
    add_column :products, :description, :string
  end
end
