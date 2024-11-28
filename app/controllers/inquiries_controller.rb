class InquiriesController < ApplicationController
  skip_before_action :require_login

  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save
      redirect_to root_path, notice: "Your inquiry has been sent. We will get back to you shortly!"
    else
      flash[:alert] = "There was an error sending your inquiry. Please check the form for issues."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :subject, :body)
  end
end
