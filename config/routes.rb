#   get "/login", to: "sessions#new"

Rails.application.routes.draw do
  root "home#index"

  get "/login", to: "sessions#new", as: "login"
  delete "/logout", to: "sessions#destroy", as: "logout"
  resources :sessions, only: [:create, :destroy]

  get "dashboard", to: "dashboard#index"

  resources :projects do
    scope module: :projects do
      get :request_membership, to: "request_membership#index"
      post :request_membership, to: "request_membership#create"

      # resources :memberships, only: [:new, :create]
      resources :notes, only: [:new, :create]

      namespace :admin do
        get :dashboard, to: "dashboard#index"
      end
    end
  end

  resources :explore_projects, only: :index
  resource :user_settings, only: [:show, :update]

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end
end
