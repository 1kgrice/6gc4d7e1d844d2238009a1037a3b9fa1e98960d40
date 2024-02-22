require 'oembed'
class EmbedMedia < ApplicationRecord
  # before_validation :fetch_oembed_data, on: :create
  belongs_to :mediaable, polymorphic: true

  after_update :update_main_cover_id
  before_destroy :reassign_or_clear_main_cover_id

  private

  def fetch_oembed_data
    return unless original_url.present?
    response = OEmbed::Providers.get(original_url)
    
    self.url = response.html 
    self.thumbnail = response.thumbnail_url
    self.external_id = SecureRandom.hex(20)
    self.media_type = 'oembed'
    self.width = response.width
    self.height = response.height
  rescue OEmbed::Error => e
    Rails.logger.warn "OEmbed fetch failed: #{e.message}"
  end

  def update_main_cover_id
    return unless mediaable_type == 'Product'
    product = mediaable
    return unless product.main_cover_id == external_id
    product.select_new_main_cover(self)
  end

  def reassign_or_clear_main_cover_id
    return unless mediaable_type == 'Product'
    product = mediaable
    return unless product.main_cover_id == external_id
    product.select_new_main_cover(self, removing: true)
  end
end
