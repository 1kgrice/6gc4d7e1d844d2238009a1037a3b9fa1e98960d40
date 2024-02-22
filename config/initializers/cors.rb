Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # if Rails.env.production?
    #   # origins 'https://gumtective.com',
    #   # 'https://discover.gumtective.com', 
    #   # 'https://app.gumtective.com'
    # else
    #   origins '*'
    # end

    origins '*' #open access for demo purposes

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
      # credentials: true 
  end
end