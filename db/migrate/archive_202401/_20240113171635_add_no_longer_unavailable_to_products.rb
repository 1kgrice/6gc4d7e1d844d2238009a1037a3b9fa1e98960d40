class AddNoLongerUnavailableToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :no_longer_available, :boolean, default: false
  end
end
