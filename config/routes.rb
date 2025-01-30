# Routes
#
# Rails.application.routes.draw do
#   root "dashboard#index"
#
#   resource :dashboard, only: [:index]
#
#   namespace :sponsors do
#     resources :research_projects do
#       resources :participation_requests, only: [:index, :update, :destroy]
#       resources :participation_notes, only: [:index]
#     end
#   end
#
#   namespace :investigators do
#     resources :research_projects, only: [:index, :show] do
#       resources :participation_requests, only: [:create]
#       resources :participation_notes, only: [:create, :index]
#     end
#   end
#
#   resources :research_projects, only: [:index, :show]
#
#   resources :notifications, only: [:index] do
#     member do
#       patch :mark_as_read
#     end
#   end
# end
#
#
# Rails.application.routes.draw do
#   root "home#index"
#
#   get "dashboard", to: "dashboard#index", as: :dashboard
#   get "/login", to: "sessions#new"
#
#   namespace :sponsors do
#     resources :research_projects do
#       resources :contribution_requests, only: [:index, :update, :destroy]
#       resources :contributor_notes, only: [:index]
#     end
#   end
#
#   namespace :contributors do
#     resources :research_projects, only: [:index, :show] do
#       resources :contribution_requests, only: [:create]
#       resources :contributor_notes, only: [:create, :index]
#     end
#   end
#
#   resources :research_projects, only: [:index, :show]
#
#   resources :notifications, only: [:index] do
#     member do
#       patch :mark_as_read
#     end
#   end
# end

Rails.application.routes.draw do
  root "home#index"
  get "/login", to: "sessions#new"
  get "dashboard", to: "dashboard#index"

  resources :sessions, only: [:create, :destroy]

  resources :research_projects do
    resources :contribution_requests, only: [:create, :index, :update]
    resources :contributor_notes, only: [:create, :index]
  end

  resources :notifications, only: [:index] do
    member do
      patch :mark_as_read
    end
  end
end
