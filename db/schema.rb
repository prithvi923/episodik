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

ActiveRecord::Schema.define(:version => 20121113014253) do

  create_table "genres", :id => false, :force => true do |t|
    t.integer "show_id",                :null => false
    t.string  "genre",   :limit => 100, :null => false
  end

  create_table "tvshow", :primary_key => "show_id", :force => true do |t|
    t.string  "name",           :limit => 100, :null => false
    t.integer "year",                          :null => false
    t.integer "seasons",                       :null => false
    t.string  "network",        :limit => 100, :null => false
    t.integer "episode_length",                :null => false
  end

  add_index "tvshow", ["name", "year"], :name => "name", :unique => true

  create_table "tvshow_complete", :primary_key => "show_id", :force => true do |t|
    t.string  "name",           :limit => 100, :null => false
    t.integer "year",                          :null => false
    t.string  "genre",          :limit => 100, :null => false
    t.integer "seasons",                       :null => false
    t.string  "network",        :limit => 100, :null => false
    t.integer "episode_length",                :null => false
  end

  add_index "tvshow_complete", ["name", "year"], :name => "name", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
  end

end
