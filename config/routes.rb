require "sidekiq/web"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # === Product Discover module ===
  constraints RoutesConstraints::DiscoverSubdomain do
    get '/', to: "modules#discover"
    get "*path", to: "modules#discover", via: :all
  end
  # - Creator and Product sections -
  constraints RoutesConstraints::WildcardSubdomain do
    get '/', to: "modules#creator"
    get "*path", to: "modules#creator", via: :all
  end

  # # === Creator Dashboard module === 
  # constraints RoutesConstraints::DashboardSubdomain do
  #   get '/', to: "modules#dashboard"
  #   get "*path", to: "modules#dashboard", via: :all
  # end

  # Direct non-subdomain requests to landing page
  constraints RoutesConstraints::NoSubdomain do
    root to: "modules#landing"
  end

  # devise_for :creators, controllers: {
  #   sessions: 'creators/sessions'
  # }

  # === Miscellaneous ===
  # API routes
  namespace :api do
    namespace :v1 do 
      resources :categories, only: [:index, :show], param: :long_slug
      get 'products/search', to: 'products#index'
      get 'products/random', to: 'products#show'
      resources :products, only: [:show,:index]
      resources :creators, param: :username, only: [:index, :show] do 
        resources :products, only: [:index, :show], param: :permalink
      end
      resources :tags, only: [:index]
    end
  end


  # Sidekiq dashboard
  if ENV['SIDEKIQ_LOGIN'].present? && ENV['SIDEKIQ_PASSWORD'].present?
    Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
      username == ENV['SIDEKIQ_LOGIN'] && password == ENV['SIDEKIQ_PASSWORD']
    end
  end
  mount Sidekiq::Web => "/sidekiq"

  # Check deployment status (used by Dokku in app.json)
  get "/check.txt", to: proc { [200, {}, ["deployed"]] }

  # Catch-all route for React Router
  # get "/404", to: "modules#landing", via: :all
  get "*path", to: "modules#landing", via: :all
end
