class RenameNoLongerAvailableInProductReferencesToAvailable < ActiveRecord::Migration[7.1]
  def change
    rename_column :product_references, :no_longer_available, :available
  end
end
