class SuperAdmin::CategoriesController < SuperAdmin::SuperAdminController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to super_admin_categories_path, notice: "Category created successfully."
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to super_admin_categories_path, notice: "Category updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to super_admin_categories_path, notice: "Category deleted successfully."
  end

  private

  def require_super_admin
    unless current_user&.super_admin?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def category_params
    params.require(:category).permit(:name, tag_ids: [])
  end
end
