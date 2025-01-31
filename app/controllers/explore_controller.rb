class ExploreController < ApplicationController
  def index
    @tags = Tag.all
    @categories = Category.all

    @projects = Project.all

    if params[:search].present?
      @projects = @projects.where("title ILIKE ?", "%#{params[:search]}%")
    end

    if params[:tag].present?
      @projects = @projects.joins(:tags).where(tags: { name: params[:tag] }).distinct
    end
  end
end
