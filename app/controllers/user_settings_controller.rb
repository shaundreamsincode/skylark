class UserSettingsController < ApplicationController
  before_action :require_login

  def show
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to user_settings_path, notice: "Settings updated successfully."
    else
      flash[:alert] = "Failed to update settings."
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
