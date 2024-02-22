module Scrapable
  extend ActiveSupport::Concern

  META_ATTRIBUTES = [
    :name, :seller, :covers, :main_cover_id, :thumbnail_url, :quantity_remaining, :currency_code,
    :long_url, :is_sales_limited, :price_cents, :rental_price_cents, :pwyw,
    :rating_counts, :is_legacy_subscription, :is_tiered_membership, :is_physical,
    :custom_view_content_button_text, :custom_button_text_option, :is_custom_delivery, 
    :is_multiseat_license, :permalink, :preorder, :description_html, :is_compliance_blocked,
    :is_published, :duration_in_months, :rental, :is_stream_only, :is_quality_enabled,
    :sales_count, :free_trial, :summary, :attributes, :recurrences, :options,
    :analytics, :has_third_party_analytics, :ppp_details, :refund_policy, :bundle_products
  ].freeze

  included do
    include AppErrors

    scope :with_meta_script, -> { where.not(meta_script: ["", nil]) }
    scope :processed, -> { where(processed: true) }
    scope :available, -> { where(available: true) }
    scope :unavailable, -> { where(available: false) }

    def fetch_meta_data!
      new_meta_script = fetch_meta_script_from_url(long_url)

      update(meta_script: new_meta_script, available: true, checked_at: DateTime.now) if 
        new_meta_script.present? && new_meta_script != meta_script
    rescue StandardError => e
      handle_meta_data_fetch_error(e)
    end

    def process_meta_data!
      return unless meta_script.present?
      json_data = JSON.parse(meta_script, symbolize_names: true)
      product_data = extract_relevant_meta_data(json_data)
      update!(product_data)
    end
  end

  private

  def fetch_meta_script_from_url(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    Nokogiri.parse(response.body).css(".js-react-on-rails-component").last.text
  end

  def handle_meta_data_fetch_error(_error)
    update(available: false, checked_at: DateTime.now)
  end

  def extract_relevant_meta_data(json_data)
    product_data = json_data.slice(:product, :discount_code, :purchase)
    filtered_product_data = product_data[:product].transform_keys(&:to_sym).slice(*META_ATTRIBUTES)
    filtered_product_data[:p_attributes] = filtered_product_data.delete(:attributes)
    filtered_product_data.merge(
      discount_code: product_data[:discount_code] || "",
      purchase: product_data[:purchase] || ""
    )
  end

  # def normalize_meta_url!
  #   return self if meta_url.start_with?("https://discover.gumroad.com/")
  #   new_meta_url = URI.join("https://discover.gumroad.com", meta_url).to_s
  #   update(meta_url: new_meta_url)
  # rescue StandardError => e
  #   handle_meta_data_fetch_error(e)
  # end
end
