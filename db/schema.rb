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

ActiveRecord::Schema.define(version: 2020_08_12_150905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "graphs", force: :cascade do |t|
    t.date "date", null: false
    t.float "weight", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "date"], name: "index_graphs_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_graphs_on_user_id"
  end

  create_table "records", force: :cascade do |t|
    t.integer "morning_cal"
    t.string "morning_image"
    t.integer "lunch_cal"
    t.string "lunch_image"
    t.integer "dinner_cal"
    t.string "dinner_string"
    t.integer "total_cal"
    t.string "motion"
    t.integer "motion_time"
    t.integer "consumption_cal"
    t.float "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "record_date"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "age"
    t.string "name"
    t.string "gender"
    t.string "user_image"
    t.float "height"
    t.float "weight"
    t.float "basal_metabolism"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "graphs", "users"
end
