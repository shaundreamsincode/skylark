class CreateProjectNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :project_notifications do |t|
      t.references :project, null: false, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
