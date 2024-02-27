require 'open-uri'
require 'nokogiri'

class FetchCreatorMetaDataChainJob
  include Sidekiq::Worker
  sidekiq_options queue: 'web_parsing'
  
  def perform(creator_id)
    creator = Creator.find_by(id: creator_id)
    return unless creator
    FetchCreatorMetaDataJob.new.perform(creator_id)
    next_creator = Creator.where("id > ?", creator_id).order(:id).first
    return unless next_creator
    self.class.perform_in(1.second, next_creator.id)
  end
end