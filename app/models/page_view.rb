class PageView < ApplicationRecord
  self.per_page = 10

  belongs_to :user, optional: true # Optional for non-logged-in users

  MAP = {
    "home#index" => "Visit home page",
    "sessions#new" => "Visits login page",
    "sessions#create" => "Attempts login",
    "sessions#destroy" => "Logs out",
    "dashboard#index" => "Visits dashboard page",
    "about#index" => "Visits about page",
    "investment_opportunities#index" => "Visits investment opportunities page",
  }

  def display_name
    MAP[page_name] || page_name
  end
end
