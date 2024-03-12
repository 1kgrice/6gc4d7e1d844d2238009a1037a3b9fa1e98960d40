source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Redis cache API
gem "redis-rails", "~> 5.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  
  # Dotenv for loading environment variables from .env
  gem "dotenv", "~> 2.8"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Quickly format html.erb files
  gem "htmlbeautifier", "~> 1.4"

  # Docker integration for Rails applications
  gem "dockerfile-rails", ">= 1.5"

  # RuboCop is a Ruby static code analyzer and formatter, based on the community Ruby style guide.
  gem "rubocop", "~> 1.57"
  gem 'ruby-lsp'

  # Processing data for import
  gem "smarter_csv", "~> 1.10"

  # Database optimizations
  gem "lol_dba", "~> 2.4"
end

# ViewComponent for building reusable view components
gem "view_component", "~> 3.1"

# Foreman for managing multiple processes during development
gem "foreman", "~> 0.87.2"

# Nokogiri for parsing HTML and XML
gem "nokogiri", "~> 1.15"

# Selenium WebDriver for integration testing
gem "selenium-webdriver", "~> 4.13"

# Sidekiq for background job processing
gem "sidekiq", "~> 7.1"
gem "sidekiq-cron", "~> 1.12"

# Kaminari for pagination
gem "kaminari", "~> 1.2"

# HasScope for filtering resources based on given conditions
gem "has_scope", "~> 0.8.2"

# Rack-CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors", "~> 2.0"

# RSpec for testing
gem "rspec", "~> 3.12"

# Ransack for object-based searching
gem "ransack", "~> 4.1"

# CarrierWave for file uploads
gem "carrierwave", "~> 3.0"

# Fog-AWS for integrating CarrierWave with Amazon S3
gem "fog-aws", "~> 3.21"

group :test do
  # RSpec Rails for testing Rails applications
  gem "rspec_junit_formatter", require: false
  gem "rspec-rails", "~> 6.1"

  # FactoryBot Rails for setting up Ruby objects as test data
  gem "factory_bot_rails", "~> 6.4"

  # Shoulda Matchers for simple one-liner tests for common Rails functionality
  gem "shoulda-matchers", "~> 6.1"

  # Database cleaner for cleaning up the database between test runs
  gem "database_cleaner", "~> 2.0"

  # Faker for generating fake data
  gem "faker", "~> 3.2"

  # Test the number of SQL queries performed
  gem "rspec-sqlimit", "~> 0.0.6"

  # N+1 query detection
  gem "bullet", "~> 7.1"
end

# Enforce safe migrations
gem "strong_migrations", "~> 1.7"

# User & Authentication management
gem "devise", "~> 4.9"
gem "devise-jwt", "~> 0.11.0"

# Tag functionality
gem "acts-as-taggable-on", "~> 10.0"

# Bulk data import 
gem "activerecord-import", "~> 1.5"

# Data serialization
gem "active_model_serializers", "~> 0.10.14"

# Media embeddings
gem "ruby-oembed", "~> 0.16.1"

gem "ruby-limiter", "~> 2.3"
