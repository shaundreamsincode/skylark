#   get "/login", to: "sessions#new"

Rails.application.routes.draw do
  root "home#index"
  get "/login", to: "sessions#new"
  get "dashboard", to: "dashboard#index"

  resources :sessions, only: [:create, :destroy]

  resources :projects do
    resources :project_memberships, only: [:create, :index, :update]
    resources :project_notes, only: [:create, :index]
  end

  resources :explore_projects, only: :index

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end
end
