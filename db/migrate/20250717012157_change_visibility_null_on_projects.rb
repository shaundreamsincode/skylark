class ChangeVisibilityNullOnProjects < ActiveRecord::Migration[6.1]
  def change
    change_column_null :projects, :visibility, true
  end
end
