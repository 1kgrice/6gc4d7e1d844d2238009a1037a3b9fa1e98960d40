class AddSellerAndCoversToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :seller, :json
    add_column :products, :covers, :json, array: true, default: [], null: false
  end
end
