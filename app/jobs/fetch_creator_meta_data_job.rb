require 'open-uri'
require 'nokogiri'

class FetchCreatorMetaDataJob
  include Sidekiq::Worker
  sidekiq_options queue: 'web_parsing'
  

  def perform(creator_id)
    creator = Creator.find_by(id: creator_id)
    return unless creator

    url = "https://#{creator.username}.gumroad.com"
    html = URI.open(url)
    document = Nokogiri::HTML(html)

    meta_script_content = document.css('.js-react-on-rails-component').text.strip
    creator.update(meta_script: meta_script_content)
  rescue StandardError => e
    Rails.logger.error "Failed to fetch meta script for Creator ##{creator_id}: #{e.message}"
  end
end