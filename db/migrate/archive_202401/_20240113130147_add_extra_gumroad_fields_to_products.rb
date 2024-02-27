class AddExtraGumroadFieldsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :pwyw, :text
    add_column :products, :free_trial, :text
    add_column :products, :recurrences, :text

    add_column :products, :bundle_products, :json, default: {}
    add_column :products, :options, :json, default: {}

    add_column :products, :discount_code, :text
    add_column :products, :purchase, :text
  end
end
