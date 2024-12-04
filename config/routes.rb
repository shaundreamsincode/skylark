Rails.application.routes.draw do
  root "home#index"

  # Authentication routes
  get '/login', to: 'sessions#new', as: 'login'
  post '/sessions', to: 'sessions#create', as: 'sessions'

  delete "/logout", to: "sessions#destroy", as: "logout"

  # delete '/sessions', to: 'sessions#destroy'
  # post "/logout", to: "sessions#destroy", as: "logout"

  # Dashboard route
  get "/dashboard", to: "dashboard#index"

  resources :inquiries, only: [:new, :create]

  ## PAGES
  get "about", to: "about#index"
  get "amenities", to: "amenities#index"
  get "investment_opportunities", to: "investment_opportunities#index"
  get "contact_us", to: "contact_us#index"
  get "photos", to: "photos#index"

  # Admin namespace
  namespace :admin do
    root to: "home#index"

    resources :users do
      member do
        get :export_page_views_csv
      end
    end

    resources :page_views, only: [:index] do
      collection do
        get :export_csv
      end
    end

    resources :inquiries, only: [:index, :show, :destroy]
  end
end
