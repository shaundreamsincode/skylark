class SearchController < ApplicationController
  def index
    @query = params[:q]&.strip
    return if @query.blank?

    @projects = Project.where("title ILIKE ?", "%#{@query}%")
    @organizations = Organization.where("name ILIKE ?", "%#{@query}%")
    @tags = Tag.where("name ILIKE ?", "%#{@query}%")
    @categories = Category.where("name ILIKE ?", "%#{@query}%")
  end
end
