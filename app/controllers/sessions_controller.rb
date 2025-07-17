class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
    redirect_to dashboard_path if logged_in?
  end

  def create
    @user = User.find_by(email: params[:email].downcase)

    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id

      redirect_to dashboard_path
    else
      flash[:alert] = "Invalid email or password. Please try again."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You have successfully signed out."
  end
end
