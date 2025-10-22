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

ActiveRecord::Schema[8.0].define(version: 2025_10_14_093434) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "postgis"

  create_table "event_members", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.string "ticket_qr_code", limit: 36, null: false
    t.integer "rating", limit: 2
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "rating"], name: "index_rated_event_members_by_event", where: "(rating IS NOT NULL)"
    t.index ["event_id"], name: "index_event_members_on_event_id"
    t.index ["ticket_qr_code"], name: "index_event_members_on_ticket_qr_code", unique: true
    t.index ["user_id"], name: "index_event_members_on_user_id"
    t.check_constraint "rating IS NULL OR rating >= 1 AND rating <= 5", name: "rating_range"
  end

  create_table "events", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "location", null: false
    t.geography "coordinates", limit: {srid: 4326, type: "st_point", geographic: true}
    t.datetime "start_date", null: false
    t.datetime "finish_date"
    t.integer "participant_capacity"
    t.decimal "ticket_price", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 4, null: false
    t.text "review_comment"
    t.string "proposed_title", limit: 128
    t.text "proposed_desc"
    t.geography "proposed_location", limit: {srid: 4326, type: "st_point", geographic: true}
    t.index ["coordinates"], name: "index_events_on_coordinates", using: :gist
    t.index ["start_date"], name: "index_events_on_start_date"
    t.index ["title"], name: "index_events_on_title", unique: true
    t.check_constraint "participant_capacity >= 0", name: "participant_capacity_non_negative"
    t.check_constraint "ticket_price >= 0::numeric", name: "ticket_price_non_negative"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "user_roles", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "email", limit: 128, null: false
    t.string "password_digest", limit: 64, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.check_constraint "email::text = lower(btrim(email::text))", name: "users_email_is_lower_and_trimmed"
  end

  add_foreign_key "event_members", "events"
  add_foreign_key "event_members", "users"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
end
