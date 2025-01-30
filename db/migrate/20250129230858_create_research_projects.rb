class CreateResearchProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :research_projects do |t|
      t.string :title, null: false
      t.text :summary
      t.text :description
      t.references :sponsor, null: false, foreign_key: { to_table: :users }
      t.integer :visibility, default: 0, null: false

      t.timestamps
    end
  end
end
