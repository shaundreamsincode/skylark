#   get "/login", to: "sessions#new"

Rails.application.routes.draw do
  root "home#index"

  get "/login", to: "sessions#new", as: "login"
  delete "/logout", to: "sessions#destroy", as: "logout"
  resources :sessions, only: [:create, :destroy]

  get "dashboard", to: "dashboard#index"

  resources :projects do
    scope module: :projects do
      resources :preview, only: :index
      resources :admin_panel, only: :index
      resources :memberships, only: [:new, :create, :update]
      resources :notes, only: [:index, :show, :new, :create]
    end
  end

  resources :organizations, only: [:show]

  resources :categories, only: [:show]
  resources :tags, only: [:show]
  resources :explore, only: :index

  resource :user_settings, only: [:show, :update]

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end

  ### SUPER ADMIN
  namespace :super_admin do
    get "dashboard", to: "dashboard#index"

    resources :users
    resources :organizations
  end
end
