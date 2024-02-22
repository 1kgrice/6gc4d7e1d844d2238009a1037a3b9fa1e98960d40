BASE_DOMAIN =  Rails.env.production? ? ENV.fetch('API_HOST') : "localhost:#{ENV.fetch('PORT',3000)}"
BASE_URL =  Rails.env.production? ? "https://#{BASE_DOMAIN}" : "http://##{BASE_DOMAIN}"
