class Admin::InquiriesController < Admin::BaseController
  def index
    @inquiries = Inquiry.order(created_at: :desc)
  end

  def show
    @inquiry = Inquiry.find(params[:id])
  end

  def destroy
    @inquiry = Inquiry.find(params[:id])
    @inquiry.destroy
    redirect_to admin_inquiries_path, notice: "Inquiry deleted successfully."
  end
end
