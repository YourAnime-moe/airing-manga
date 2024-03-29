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

ActiveRecord::Schema[7.1].define(version: 2022_11_13_151127) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "mangadex_users", force: :cascade do |t|
    t.string "session"
    t.string "refresh"
    t.string "username", null: false
    t.string "mangadex_user_id", null: false
    t.datetime "session_valid_until"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_mangadex_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "youranime_users", force: :cascade do |t|
    t.string "access_token"
    t.string "refresh_token"
    t.string "username", null: false
    t.string "uuid", null: false
    t.datetime "access_token_expires_on"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_youranime_users_on_user_id"
  end

end
