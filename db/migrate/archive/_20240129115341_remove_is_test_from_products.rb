class RemoveIsTestFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :is_test
  end
end
