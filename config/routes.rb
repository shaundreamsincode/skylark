Rails.application.routes.draw do
  root "home#index"
  #
  # get "/about", to: "pages#about"
  # get "/projects", to: "pages#projects"
  # get "/resume", to: "pages#resume"
  # get "/photos", to: "pages#photos"
  # get "/contact", to: "pages#contact"
=begin
  get "/contact.html.erb", to: "pages#contact.html.erb"
  # get "/about", to: "pages#about"
=end
end


# <%= link_to "About", about_path, class: "hover:underline" %>
#         <%= link_to "Resume", resume_path, class: "hover:underline" %>
# <%= link_to "Projects", projects_path, class: "hover:underline" %>
#         <%= link_to "Photos", photos_path, class: "hover:underline" %>
# <%= link_to "Music", music_path, class: "hover:underline" %>
