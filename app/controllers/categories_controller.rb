class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @projects = Project.joins(:tags).where(tags: { id: @category.tags.pluck(:id) }).distinct
  end
end
