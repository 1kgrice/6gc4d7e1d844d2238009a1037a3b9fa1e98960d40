class AddMoreGumroadPropertiesToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products,
               :rating_counts,
               :integer,
               array: true,
               default: [0, 0, 0, 0, 0],
               null: false
    add_column :products, :is_legacy_subscription, :boolean, default: false
    add_column :products, :is_tiered_membership, :boolean, default: false
    add_column :products, :is_physical, :boolean, default: false
    add_column :products, :custom_view_content_button_text, :string
    add_column :products, :custom_button_text_option, :string
    add_column :products, :is_custom_delivery, :boolean, default: false
    add_column :products, :is_multiseat_license, :boolean, default: false
    add_column :products, :permalink, :string
    add_column :products, :preorder, :integer, null: true
    add_column :products, :description_html, :text
    add_column :products, :is_compliance_blocked, :boolean, default: false
    add_column :products, :is_published, :boolean, default: false
    add_column :products, :duration_in_months, :integer, null: true
    add_column :products, :rental, :integer, null: true
    add_column :products, :is_stream_only, :boolean, default: false
    add_column :products, :is_quality_enabled, :boolean, default: false
    add_column :products, :sales_count, :integer, null: true
  end
end
