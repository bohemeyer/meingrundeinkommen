# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141229150910) do

  create_table "chances", force: true do |t|
    t.date     "dob"
    t.boolean  "is_child"
    t.integer  "country_id"
    t.string   "city"
    t.boolean  "confirmed_publication"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "code2"
    t.boolean  "crowdbar_verified",     default: false
    t.boolean  "ignore_double_chance",  default: false
    t.boolean  "remember_data",         default: false
  end

  add_index "chances", ["first_name", "last_name", "dob"], name: "index_chances_on_first_name_and_last_name_and_dob", unique: true
  add_index "chances", ["user_id"], name: "index_chances_on_user_id"

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.text     "text"
    t.string   "static_name"
    t.string   "static_avatar"
    t.string   "name"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crowdcards", force: true do |t|
    t.integer  "user_id"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "street"
    t.text     "house_number"
    t.text     "zip_code"
    t.text     "city"
    t.text     "country",         default: "de"
    t.integer  "number_of_cards", default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flags", force: true do |t|
    t.integer  "user_id"
    t.text     "name"
    t.boolean  "value_boolean"
    t.text     "value_text"
    t.integer  "value_integer"
    t.date     "value_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", force: true do |t|
    t.string   "follower_type"
    t.integer  "follower_id"
    t.string   "followable_type"
    t.integer  "followable_id"
    t.datetime "created_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows"

  create_table "likes", force: true do |t|
    t.string   "liker_type"
    t.integer  "liker_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "fk_likeables"
  add_index "likes", ["liker_id", "liker_type"], name: "fk_likes"

  create_table "notifications", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.string   "text"
    t.text     "answer"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes",      default: 1
  end

  create_table "state_users", force: true do |t|
    t.text     "story"
    t.integer  "user_id"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visibility", default: false
  end

  create_table "states", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suggestions", force: true do |t|
    t.string   "email"
    t.text     "initial_wishes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supports", force: true do |t|
    t.string   "nickname"
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.float    "amount_total"
    t.float    "amount_internal"
    t.float    "amount_for_income"
    t.string   "company"
    t.string   "street"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.string   "payment_method"
    t.boolean  "payment_completed"
    t.text     "comment"
    t.boolean  "anonymous"
    t.boolean  "recurring"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "todos", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_wishes", force: true do |t|
    t.text     "story"
    t.integer  "user_id"
    t.integer  "wish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "name",                   default: "",    null: false
    t.string   "initial_wishes",         default: ""
    t.string   "initial_conditions",     default: ""
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "sign_up_ip"
    t.string   "number_of_signups"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
    t.boolean  "datenschutz",            default: false
    t.boolean  "newsletter",             default: false
    t.boolean  "has_crowdbar",           default: false
    t.string   "browser"
    t.string   "os"
    t.boolean  "crowdbar_not_found",     default: false
    t.integer  "winner",                 default: 0
    t.boolean  "admin",                  default: false
    t.string   "provider",               default: "",    null: false
    t.string   "uid",                    default: "",    null: false
    t.text     "tokens"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "wishes", force: true do |t|
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
