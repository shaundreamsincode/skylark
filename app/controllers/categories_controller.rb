class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @tags = @category.tags
    @projects = Project.joins(:tags).where(tags: { id: @category.tags.pluck(:id) }).distinct
  end
end
