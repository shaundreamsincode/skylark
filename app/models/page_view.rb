class PageView < ApplicationRecord
  self.per_page = 10

  belongs_to :user, optional: true # Optional for non-logged-in users

  MAP = {
    "home#index" => "Visit home page",
    "sessions#new" => "Visits login page",
    "sessions#create" => "Attempts login",
    "sessions#destroy" => "Logs out",
    "inquiries#new" => "Visits create inquiry page",
    "inquiries#create" => "Attempts to submits inquiry",
    "dashboard#index" => "Visits dashboard page",
    "about#index" => "Visits about page",
    "investment_opportunities#index" => "Visits investment opportunities page",
    "contact_us#index" => "Visits contact.html.erb us page"
  }

  def display_name
    MAP[page_name] || page_name
  end
end
