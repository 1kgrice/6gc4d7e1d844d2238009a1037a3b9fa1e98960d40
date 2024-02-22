class RemoveColumnProcessedFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :processed
  end
end
