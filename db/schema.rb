# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_05_012150) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrators", force: :cascade do |t|
    t.string "name"
    t.string "email_address"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.string "name"
    t.string "postcode"
    t.string "country"
    t.string "email_address"
    t.integer "number_of_people"
    t.string "estimated_arrival_time"
    t.string "preferred_payment_method"
    t.date "arrival_date"
    t.date "departure_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact_number"
    t.integer "cost"
    t.string "status"
  end

  create_table "price_rules", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.string "period_type"
    t.integer "min_people"
    t.integer "max_people"
    t.date "start_date"
    t.date "end_date"
    t.integer "min_stay_duration"
    t.integer "max_stay_duration"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
