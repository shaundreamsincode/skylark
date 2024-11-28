class Admin::PageViewsController < Admin::BaseController
  def index
    @page_views = PageView.all
  end
end
