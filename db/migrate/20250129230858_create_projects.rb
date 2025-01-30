class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :summary
      t.text :description
      t.references :user, null: false
      t.integer :visibility, default: 0, null: false

      t.timestamps
    end
  end
end
