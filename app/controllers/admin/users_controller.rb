require 'csv'

class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @page_views = @user.page_views.page(params[:page]).order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save!
      redirect_to admin_users_path, notice: "User created successfully."
    else
      flash[:alert] = "There was an error creating the user. Please check the form for issues."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User updated successfully."
    else
      flash[:alert] = "There was an error updating the user. Please check the form for issues."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  def export_page_views_csv
    @user = User.find(params[:id])
    @page_views = @user.page_views.order(created_at: :desc)

    csv_data = CSV.generate(headers: true) do |csv|
      # Define CSV headers
      csv << ["Page", "IP Address", "Date"]

      # Add rows for each PageView record
      @page_views.each do |page_view|
        csv << [
          page_view.display_name,
          page_view.ip_address,
          page_view.created_at.strftime("%Y-%m-%d %H:%M:%S")
        ]
      end
    end

    # Send the CSV file to the user
    respond_to do |format|
      format.csv { send_data csv_data, filename: "user_#{params[:id]}_page_views_#{Time.now.to_i}.csv" }
      format.html { redirect_to admin_user_path(@user), alert: "Invalid request format." }
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
