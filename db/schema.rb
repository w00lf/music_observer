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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131120121848) do

  create_table "artist_users", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "artist_id",                     :null => false
    t.string   "type"
    t.boolean  "track",      :default => false, :null => false
    t.boolean  "show",       :default => true,  :null => false
    t.integer  "listeners",  :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.string   "mbid"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "year_from"
    t.datetime "year_to"
    t.integer  "listeners"
    t.text     "description"
    t.string   "api_link"
  end

  create_table "artists_tags", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "artist_id"
  end

  create_table "concert_user_entries", :force => true do |t|
    t.integer "concert_id"
    t.integer "user_id"
    t.boolean "is_show",    :default => true, :null => false
  end

  create_table "concerts", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "api_link"
    t.string   "country"
    t.string   "sity"
    t.string   "street"
    t.integer  "artist_id"
    t.datetime "start_date"
    t.integer  "api_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "libraries", :force => true do |t|
    t.boolean  "track",      :default => false, :null => false
    t.integer  "listened",   :default => 0,     :null => false
    t.boolean  "show",       :default => true,  :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "scheduled_tasks", :force => true do |t|
    t.string   "cron"
    t.string   "name"
    t.string   "queue"
    t.text     "description"
    t.string   "job_class"
    t.string   "args"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "api_link"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",               :default => "",    :null => false
    t.string   "encrypted_password",  :default => "",    :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",     :default => 0,     :null => false
    t.datetime "locked_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.boolean  "notification",        :default => false, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
