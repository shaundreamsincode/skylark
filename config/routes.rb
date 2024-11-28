Rails.application.routes.draw do
  root "home#index"

  # Authentication routes
  get '/login', to: 'sessions#new', as: 'login'
  post '/sessions', to: 'sessions#create', as: 'sessions'
  delete '/sessions', to: 'sessions#destroy'

  # Dashboard route
  get "/dashboard", to: "dashboard#index"

  resources :inquiries, only: [:new, :create]

  # Admin namespace
  namespace :admin do
    root to: "home#index"

    resources :users
    resources :page_views, only: [:index]
    resources :inquiries, only: [:index, :show, :destroy]
  end
end
