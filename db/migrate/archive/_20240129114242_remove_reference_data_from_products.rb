class RemoveReferenceDataFromProducts < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :main_cover_id
    remove_column :products, :thumbnail_url
    remove_column :products, :quantity_remaining
    remove_column :products, :currency_code
    remove_column :products, :long_url
    remove_column :products, :is_sales_limited
    remove_column :products, :price_cents
    remove_column :products, :rental_price_cents
    remove_column :products, :is_legacy_subscription
    remove_column :products, :is_tiered_membership
    remove_column :products, :is_physical
    remove_column :products, :custom_view_content_button_text
    remove_column :products, :custom_button_text_option
    remove_column :products, :is_custom_delivery
    remove_column :products, :is_multiseat_license
    remove_column :products, :permalink
    remove_column :products, :preorder
    remove_column :products, :description_html
    remove_column :products, :is_compliance_blocked
    remove_column :products, :is_published
    remove_column :products, :duration_in_months
    remove_column :products, :rental
    remove_column :products, :is_stream_only
    remove_column :products, :is_quality_enabled
    remove_column :products, :sales_count
    remove_column :products, :summary
    remove_column :products, :p_attributes
    remove_column :products, :analytics
    remove_column :products, :has_third_party_analytics
    remove_column :products, :ppp_details
    remove_column :products, :refund_policy
    remove_column :products, :seller
    remove_column :products, :covers

    remove_column :products, :pwyw
    remove_column :products, :free_trial
    remove_column :products, :recurrences

    remove_column :products, :bundle_products
    remove_column :products, :options

    remove_column :products, :discount_code
    remove_column :products, :purchase
  end
end
