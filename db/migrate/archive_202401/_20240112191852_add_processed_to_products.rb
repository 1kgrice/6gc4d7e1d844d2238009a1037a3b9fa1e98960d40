class AddProcessedToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :processed, :boolean, default: false
  end
end
