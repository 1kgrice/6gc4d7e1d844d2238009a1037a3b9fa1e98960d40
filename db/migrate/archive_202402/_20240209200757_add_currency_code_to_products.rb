class AddCurrencyCodeToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :currency_code, :string
  end
end
