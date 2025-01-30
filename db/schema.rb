# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_01_30_035305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collaboration_requests", force: :cascade do |t|
    t.bigint "research_project_id", null: false
    t.bigint "user_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["research_project_id"], name: "index_collaboration_requests_on_research_project_id"
    t.index ["user_id"], name: "index_collaboration_requests_on_user_id"
  end

  create_table "collaborator_notes", force: :cascade do |t|
    t.bigint "research_project_id", null: false
    t.bigint "user_id", null: false
    t.integer "entry_type", default: 0, null: false
    t.text "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["research_project_id"], name: "index_collaborator_notes_on_research_project_id"
    t.index ["user_id"], name: "index_collaborator_notes_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "target_id", null: false
    t.string "target_type", null: false
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "research_projects", force: :cascade do |t|
    t.string "title", null: false
    t.text "summary"
    t.text "description"
    t.bigint "sponsor_id", null: false
    t.integer "visibility", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sponsor_id"], name: "index_research_projects_on_sponsor_id"
  end

  create_table "roles", force: :cascade do |t|
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.text "bio"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "collaboration_requests", "research_projects"
  add_foreign_key "collaboration_requests", "users"
  add_foreign_key "collaborator_notes", "research_projects"
  add_foreign_key "collaborator_notes", "users"
  add_foreign_key "research_projects", "users", column: "sponsor_id"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
