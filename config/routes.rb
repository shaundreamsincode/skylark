Rails.application.routes.draw do
  root "home#index"
  
  # Health check endpoint for Docker/CI testing
  get '/health', to: proc { [200, {}, ['OK']] }

  get "/login", to: "sessions#new", as: "login"
  get "/signup", to: "users#new", as: "signup"
  delete "/logout", to: "sessions#destroy", as: "logout"
  resources :sessions, only: [:create, :destroy]

  get "dashboard", to: "dashboard#index"

  resources :projects do
    scope module: :projects do
      resources :preview, only: :index
      resources :admin_panel, only: :index
      resources :memberships, only: [:new, :create, :update]
      resources :information_requests

      resources :notes, only: [:index, :show, :new, :create] do
        collection do
          get :export, format: :csv
        end
      end
    end
  end

  resources :organizations, only: [:show]

  resources :categories, only: [:show]
  resources :tags, only: [:show]
  resources :explore, only: :index
  resources :community, only: :index
  resources :search, only: :index

  resources :users, only: [:index, :show, :new, :create]
  resource :user_settings, only: [:show, :update]

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end

  # Public, short-link access for Information Requests
  get "/request_for_information/confirm_submission", to: "public_requests#confirm_submission", as: "confirm_submission"
  get "/request_for_information/success", to: "public_requests#success", as: "public_request_success"
  get "/request_for_information/:token", to: "public_requests#show", as: "public_request_form"
  post "/request_for_information/:token", to: "public_requests#submit", as: "public_request_submit"

  ### SUPER ADMIN
  namespace :super_admin do
    root to: "dashboard#index"
    get "dashboard", to: "dashboard#index"

    resources :users
    resources :organizations do
      member do
        post "add_member"
        delete "remove_member"
        patch "update_role"
      end
    end
    resources :tags
    resources :categories
  end
end
