class CreateCollaboratorNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :collaborator_notes do |t|
      t.references :research_project, null: false, foreign_key: true

      t.references :user, null: false, foreign_key: true
      t.integer :entry_type, default: 0, null: false # enum
      t.text :content, null: false

      t.timestamps
    end
  end
end
