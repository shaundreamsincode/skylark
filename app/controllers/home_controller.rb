class HomeController < ApplicationController
  skip_before_action :require_login

  def index
    if logged_in?
      redirect_to "/dashboard"
    end
  end
end
