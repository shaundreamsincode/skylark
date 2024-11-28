class HomeController < ApplicationController
  skip_before_action :require_login

  def index
    if current_user.present?
      redirect_to "/dashboard"
    end
  end
end
