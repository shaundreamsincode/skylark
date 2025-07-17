class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    if logged_in?
      redirect_to dashboard_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Welcome to Skylark! Your account has been created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :bio)
  end
end
