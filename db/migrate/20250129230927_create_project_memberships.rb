class CreateProjectMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :project_memberships do |t|
      t.references :project, null: false, foreign_key: true

      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0, null: false

      t.text :request_message, default: "", null: false

      t.timestamps
    end
  end
end
