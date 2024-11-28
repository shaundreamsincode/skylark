Rails.application.routes.draw do
  root "home#index"

  get '/login', to: 'sessions#new', as: 'login'
  post '/sessions', to: 'sessions#create', as: 'sessions'
  delete '/sessions', to: 'sessions#destroy'

  get "/dashboard", to: "dashboard#index"
end
