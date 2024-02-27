class AddGumroadPropertiesToProducts < ActiveRecord::Migration[7.0]
  def change
    # enable_extension "hstore"

    add_column :products, :main_cover_id, :string
    add_column :products, :thumbnail_url, :string
    add_column :products, :quantity_remaining, :integer, null: true
    add_column :products, :currency_code, :string
    add_column :products, :long_url, :string
    add_column :products, :is_sales_limited, :boolean, default: false
    add_column :products, :price_cents, :integer, default: 0, null: false
    add_column :products, :rental_price_cents, :integer, null: true
    # add_column :products, :pwyw, :hstore, default: {}, null: false

    # add_column :products,
    #            :rating_counts,
    #            :integer,
    #            array: true,
    #            default: [0, 0, 0, 0, 0],
    #            null: false
    # add_column :products, :is_legacy_subscription, :boolean, default: false
    # add_column :products, :is_tiered_membership, :boolean, default: false
    # add_column :products, :is_physical, :boolean, default: false
    # add_column :products, :custom_view_content_button_text, :string
    # add_column :products, :custom_button_text_option, :string
    # add_column :products, :is_custom_delivery, :boolean, default: false
    # add_column :products, :is_multiseat_license, :boolean, default: false
    # add_column :products, :permalink, :string
    # add_column :products, :preorder, :integer, null: true
    # add_column :products, :description_html, :text
    # add_column :products, :is_compliance_blocked, :boolean, default: false
    # add_column :products, :is_published, :boolean, default: false
    # add_column :products, :duration_in_months, :integer, null: true
    # add_column :products, :rental, :integer, null: true
    # add_column :products, :is_stream_only, :boolean, default: false
    # add_column :products, :is_quality_enabled, :boolean, default: false
    # add_column :products, :sales_count, :integer, null: true

    # add_column :products, :free_trial, (nil)
    ## add_column :products, :summary, :text
    # add_column :products, :attributes, :hstore, default: {}, null: false
    #add_column :products, :recurrences, (nil)
    # add_column :products, :options, (array)
    # add_column :products, :analytics, :hstore, default: {}, null: false
    ##add_column :products, :has_third_party_analytics, :boolean, default: false
    # add_column :products, :ppp_details, :hstore, default: {}, null: false
    ##add_column :products, :refund_policy, :text
  end
end
