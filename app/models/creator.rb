class Creator < ApplicationRecord
  include Rails.application.routes.url_helpers

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :products, dependent: :nullify
  scope :by_name, ->(name) { where(arel_table[:name].matches("%#{sanitize_sql_like(name)}%")) }

  def profile_url
    base_url = Rails.env.development? ? root_url(host: "#{username}.#{BASE_DOMAIN}") : "https://#{username}.#{BASE_DOMAIN}"
    base_url.chomp('/')
  end
end
