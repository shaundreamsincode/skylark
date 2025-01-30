class CreateCollaborationRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :collaboration_requests do |t|
      t.references :research_project, null: false, foreign_key: true

      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
