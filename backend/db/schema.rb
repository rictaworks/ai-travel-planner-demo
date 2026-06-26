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

ActiveRecord::Schema[8.1].define(version: 2026_06_26_225326) do
  create_table "itineraries", force: :cascade do |t|
    t.integer "budget_total"
    t.datetime "created_at", null: false
    t.string "expected_weather"
    t.string "owner_session_id"
    t.text "preference_json"
    t.string "status", default: "draft", null: false
    t.integer "trip_days"
    t.datetime "updated_at", null: false
  end

  create_table "itinerary_days", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "day_number"
    t.integer "itinerary_id", null: false
    t.datetime "updated_at", null: false
    t.index ["itinerary_id"], name: "index_itinerary_days_on_itinerary_id"
  end

  create_table "itinerary_items", force: :cascade do |t|
    t.integer "cost"
    t.datetime "created_at", null: false
    t.integer "itinerary_day_id", null: false
    t.integer "sequence_order"
    t.integer "spot_id", null: false
    t.string "time_slot_end"
    t.string "time_slot_start"
    t.datetime "updated_at", null: false
    t.index ["itinerary_day_id"], name: "index_itinerary_items_on_itinerary_day_id"
    t.index ["spot_id"], name: "index_itinerary_items_on_spot_id"
  end

  create_table "regions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "spots", force: :cascade do |t|
    t.string "category"
    t.integer "cost"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "duration_min"
    t.string "indoor_outdoor"
    t.string "name"
    t.integer "region_id", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_spots_on_region_id"
  end

  add_foreign_key "itinerary_days", "itineraries"
  add_foreign_key "itinerary_items", "itinerary_days"
  add_foreign_key "itinerary_items", "spots"
  add_foreign_key "spots", "regions"
end
