require 'sidekiq'
require 'sidekiq/cron'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1") }
end
Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1") }
end

if Rails.env.production?
  Sidekiq.configure_server do |_config|
    schedule_file = Rails.root.join("config/schedule.yml") 
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file) && Sidekiq.server?
  end
end