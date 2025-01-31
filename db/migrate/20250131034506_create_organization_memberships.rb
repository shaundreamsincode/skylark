class CreateOrganizationMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :organization_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
