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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121208182052) do

  create_table "genres", :force => true do |t|
    t.integer "show_id"
    t.string  "genre"
  end

  add_index "genres", ["show_id", "genre"], :name => "index_genres_on_show_id_and_genre", :unique => true

  create_table "histories", :force => true do |t|
    t.integer  "user_id"
    t.integer  "show_id"
    t.integer  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "histories", ["show_id", "user_id"], :name => "index_histories_on_show_id_and_user_id", :unique => true

  create_table "preferences", :force => true do |t|
    t.integer "user_id"
    t.integer "hot_sid"
    t.integer "not_sid"
  end

  add_index "preferences", ["hot_sid", "not_sid", "user_id"], :name => "index_preferences_on_hot_sid_and_not_sid_and_user_id", :unique => true
  add_index "preferences", ["not_sid"], :name => "not_sid"
  add_index "preferences", ["user_id", "hot_sid", "not_sid"], :name => "index_preferences_on_user_id_and_hot_sid_and_not_sid"

  create_table "tvshows", :primary_key => "show_id", :force => true do |t|
    t.string   "name"
    t.integer  "year"
    t.integer  "seasons"
    t.integer  "episode_length"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
