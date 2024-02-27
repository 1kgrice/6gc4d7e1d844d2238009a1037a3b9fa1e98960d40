class AddMetaPropertiesToProductReferences < ActiveRecord::Migration[7.1]
  def change
    add_column :product_references, :name, :string
    add_column :product_references, :meta_url, :string
    add_column :product_references, :meta_script, :text
    add_column :product_references, :main_cover_id, :string
    add_column :product_references, :thumbnail_url, :string
    add_column :product_references, :quantity_remaining, :integer, null: true
    add_column :product_references, :currency_code, :string
    add_column :product_references, :long_url, :string
    add_column :product_references, :is_sales_limited, :boolean, default: false
    add_column :product_references, :price_cents, :integer, default: 0, null: false
    add_column :product_references, :rental_price_cents, :integer, null: true
    add_column :product_references,
               :rating_counts,
               :integer,
                array: true,
                default: [0, 0, 0, 0, 0],
                null: true
    add_column :product_references, :is_legacy_subscription, :boolean, default: false
    add_column :product_references, :is_tiered_membership, :boolean, default: false
    add_column :product_references, :is_physical, :boolean, default: false
    add_column :product_references, :custom_view_content_button_text, :string
    add_column :product_references, :custom_button_text_option, :string
    add_column :product_references, :is_custom_delivery, :boolean, default: false
    add_column :product_references, :is_multiseat_license, :boolean, default: false
    add_column :product_references, :permalink, :string
    add_column :product_references, :preorder, :integer, null: true
    add_column :product_references, :description_html, :text
    add_column :product_references, :is_compliance_blocked, :boolean, default: false
    add_column :product_references, :is_published, :boolean, default: false
    add_column :product_references, :duration_in_months, :integer, null: true
    add_column :product_references, :rental, :integer, null: true
    add_column :product_references, :is_stream_only, :boolean, default: false
    add_column :product_references, :is_quality_enabled, :boolean, default: false
    add_column :product_references, :sales_count, :integer, null: true
    add_column :product_references, :summary, :text
    add_column :product_references, :p_attributes, :json, default: {}
    add_column :product_references, :analytics, :json, default: {}
    add_column :product_references, :has_third_party_analytics, :boolean, default: false
    add_column :product_references, :ppp_details, :json, default: {}
    add_column :product_references, :refund_policy, :text
    add_column :product_references, :seller, :json
    add_column :product_references, :covers, :json, array: true, default: [], null: false

    add_column :product_references, :pwyw, :text
    add_column :product_references, :free_trial, :text
    add_column :product_references, :recurrences, :text

    add_column :product_references, :bundle_products, :json, default: {}
    add_column :product_references, :options, :json, default: {}

    add_column :product_references, :discount_code, :text
    add_column :product_references, :purchase, :text

    add_index :product_references, :name
    add_index :product_references, :permalink
    add_index :product_references, :price_cents
    add_index :product_references, :long_url
    add_index :product_references, :meta_url
  end
end
