require 'open-uri'
require 'nokogiri'

class FetchCreatorMetaDataJob
  include Sidekiq::Worker
  sidekiq_options queue: 'limited'

  extend Limiter::Mixin
  # Throttle this job to 8 executions per 60 seconds
  limit_method :fetch_creator_meta_data, rate: 8, interval: 60, balanced: true
  

  def perform(creator_id, attempt = 0)
    fetch_creator_meta_data(creator_id, attempt)
  end

  private 

  def fetch_creator_meta_data(creator_id, attempt = 0)
    creator = Creator.find_by(id: creator_id)
    return unless creator

    url = "https://#{creator.username}.gumroad.com"
    uri = URI.parse(url)
    
    response = Net::HTTP.get_response(uri)

    if response.code == '429'
      Rails.logger.warn "Rate limit hit for Creator ##{creator_id}, retrying in 1 hour"
      self.class.perform_in((attempt+1)*60.minutes, creator_id, attempt+1)
      return
    end

    meta_script_content = Nokogiri.parse(response.body).css(".js-react-on-rails-component").text.strip

    creator.update(meta_script: meta_script_content)
    rescue StandardError => e
      Rails.logger.error "Failed to fetch meta script for Creator ##{creator_id}: #{e.message}"
  end
end