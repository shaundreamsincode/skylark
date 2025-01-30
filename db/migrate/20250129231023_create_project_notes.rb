class CreateProjectNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :project_notes do |t|
      t.references :project, null: false, foreign_key: true

      t.references :user, null: false, foreign_key: true
      t.integer :entry_type, default: 0, null: false # enum
      t.text :content, null: false

      t.timestamps
    end
  end
end
