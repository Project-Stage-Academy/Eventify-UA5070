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

ActiveRecord::Schema[8.0].define(version: 2025_09_28_132824) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "postgis"

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
    t.integer "event_status", default: 0, null: false
    t.integer "review_status", default: 0, null: false
    t.text "review_comment"
    t.index ["coordinates"], name: "index_events_on_coordinates", using: :gist
    t.index ["start_date"], name: "index_events_on_start_date"
    t.check_constraint "participant_capacity >= 0", name: "participant_capacity_non_negative"
    t.check_constraint "ticket_price >= 0::numeric", name: "ticket_price_non_negative"
  end
end
