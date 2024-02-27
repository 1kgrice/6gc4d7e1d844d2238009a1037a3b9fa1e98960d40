class RemoveNoLongerAvailableFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :no_longer_available
  end
end
