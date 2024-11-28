require 'csv'

class Admin::PageViewsController < Admin::BaseController
  def index
    @page_views = PageView.page(params[:page])
  end

  def export_csv
    @page_views = PageView.all

    csv_data = CSV.generate(headers: true) do |csv|
      # Define CSV headers
      csv << ["Page", "User", "IP Address", "Date"]

      # Add rows for each PageView record
      @page_views.each do |page_view|
        csv << [
          page_view.display_name,
          page_view.user ? page_view.user.email : "Guest",
          page_view.ip_address,
          page_view.created_at.strftime("%Y-%m-%d %H:%M:%S")
        ]
      end
    end

    # Send the CSV file to the user
    respond_to do |format|
      format.csv { send_data csv_data, filename: "page_views_#{Time.now.to_i}.csv" }
    end
  end
end
