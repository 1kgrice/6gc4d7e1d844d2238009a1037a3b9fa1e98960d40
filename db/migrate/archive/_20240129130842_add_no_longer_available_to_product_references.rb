class AddNoLongerAvailableToProductReferences < ActiveRecord::Migration[7.1]
  def change
    add_column :product_references, :no_longer_available, :boolean
  end
end
