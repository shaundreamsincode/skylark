class CreateInformationRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :information_requests do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :token, null: false, index: { unique: true }
      t.datetime :expires_at

      t.timestamps
    end
  end
end
