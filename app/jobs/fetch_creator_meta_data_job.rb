#frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

class FetchCreatorMetaDataJob
  include Sidekiq::Worker
  sidekiq_options queue: 'limited'

  extend Limiter::Mixin
  # Throttle this job to 5 executions per 60 seconds
  limit_method :fetch_creator_meta_data, rate: 5, interval: 60, balanced: true

  def perform(creator_id, attempt = 0, comment = '')
    # If the job is scheduled due to a rate limit, don't run it
    return if job_scheduled?(creator_id, 'try_again')

    if is_rate_limited? && comment != 'try_again'
      # When rate has been limited, schedule current job for later (until the previously scheduled one resolves naturally)
      reschedule_job(creator_id, attempt, comment)
    else
      fetch_creator_meta_data(creator_id, attempt)
    end
  end

  private

  def fetch_creator_meta_data(creator_id, attempt = 0)
    creator = Creator.find_by(id: creator_id)
    return unless creator

    response = fetch_data_from_url(creator.username)

    handle_response(response, creator_id, attempt)
  rescue StandardError => e
    Rails.logger.error "Failed to fetch meta script for Creator ##{creator_id}: #{e.message}"
  end

  def fetch_data_from_url(username)
    url = "https://#{username}.gumroad.com"
    uri = URI.parse(url)
    Net::HTTP.get_response(uri)
  end

  def handle_response(response, creator_id, attempt)
    case response.code
    when '429'
      log_and_reschedule_due_to_rate_limit(creator_id, attempt)
    else
      update_creator_meta_script(response, creator_id)
    end
  end

  def log_and_reschedule_due_to_rate_limit(creator_id, attempt)
    return if already_scheduled?(creator_id)
    Rails.logger.warn "Rate limit hit for Creator ##{creator_id}, retrying in 1 hour"
    reschedule_job(creator_id, attempt, 'try_again')
  end

  def update_creator_meta_script(response, creator_id)
    meta_script_content = Nokogiri.parse(response.body).css(".js-react-on-rails-component").text.strip
    Creator.find_by(id: creator_id)&.update(meta_script: meta_script_content)
  end

  def job_scheduled?(creator_id, comment)
    Sidekiq::ScheduledSet.new.any? { |job| job_matches_criteria?(job, creator_id, comment) }
  end

  def job_matches_criteria?(job, creator_id, comment)
    job.queue == 'limited' && job.args[0] == creator_id && job.klass == self.class.name
    criteria &&= job.args[2] == comment if comment
    criteria
  end

  def is_rate_limited?
    Sidekiq::ScheduledSet.new.any? { |job| job.queue == 'limited' && job.args[2] == 'try_again' }
  end

  def reschedule_job(creator_id, attempt, comment)
    self.class.perform_in((attempt + 1) * 40.minutes, creator_id, attempt + 1, comment)
  end
end
