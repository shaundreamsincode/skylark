class SuperAdmin::TagsController < SuperAdmin::SuperAdminController
  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to super_admin_tags_path, notice: "Tag created successfully."
    else
      render :new
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update(tag_params)
      redirect_to super_admin_tags_path, notice: "Tag updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to super_admin_tags_path, notice: "Tag deleted successfully."
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
