class AddPwywAttributesToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :is_pwyw, :boolean, default: false
    add_column :products, :pwyw_suggested_price_cents, :integer, default: 0
  end
end
