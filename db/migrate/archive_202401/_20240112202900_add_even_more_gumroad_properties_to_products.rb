class AddEvenMoreGumroadPropertiesToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :summary, :text
    add_column :products, :p_attributes, :json, default: {}
    add_column :products, :analytics, :json, default: {}
    add_column :products, :has_third_party_analytics, :boolean, default: false
    add_column :products, :ppp_details, :json, default: {}
    add_column :products, :refund_policy, :text
    add_column :products, :seller, :json
    add_column :products, :covers, :json, array: true, default: [], null: false
  end
end
