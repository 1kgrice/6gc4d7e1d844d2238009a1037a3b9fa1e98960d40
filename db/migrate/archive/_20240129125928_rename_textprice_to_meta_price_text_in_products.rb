class RenameTextpriceToMetaPriceTextInProducts < ActiveRecord::Migration[7.1]
  def change
    rename_column :products, :textprice, :meta_price_text
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
