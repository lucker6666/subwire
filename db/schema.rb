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

ActiveRecord::Schema.define(:version => 20120712174140) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "instance_id", :default => 1, :null => false
  end

  add_index "articles", ["instance_id"], :name => "index_articles_on_instance_id"

  create_table "availabilities", :force => true do |t|
    t.integer "user_id"
    t.date    "date"
    t.boolean "value"
    t.integer "instance_id", :default => 1, :null => false
  end

  add_index "availabilities", ["instance_id"], :name => "index_availabilities_on_instance_id"
  add_index "availabilities", ["user_id"], :name => "index_availabilities_on_user_id"

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "article_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "instances", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "defaultLanguage", :default => "en",  :null => false
    t.boolean  "advertising",     :default => true,  :null => false
    t.boolean  "planningTool",    :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "links", :force => true do |t|
    t.string   "name"
    t.string   "href"
    t.string   "icon"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "instance_id", :default => 1, :null => false
  end

  add_index "links", ["instance_id"], :name => "index_links_on_instance_id"

  create_table "notifications", :force => true do |t|
    t.string   "notification_type", :default => "article"
    t.string   "href"
    t.boolean  "is_read"
    t.integer  "user_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "instance_id",       :default => 1,         :null => false
    t.integer  "created_by"
    t.integer  "provokesUser"
    t.string   "subject"
  end

  add_index "notifications", ["instance_id"], :name => "index_notifications_on_instance_id"

  create_table "relationships", :force => true do |t|
    t.integer "user_id",     :default => 1,    :null => false
    t.integer "instance_id", :default => 1,    :null => false
    t.boolean "admin",       :default => true, :null => false
  end

  add_index "relationships", ["instance_id"], :name => "index_relationships_on_instance_id"
  add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                   :default => "",                           :null => false
    t.string   "email",                  :default => "",                           :null => false
    t.boolean  "is_admin",               :default => false,                        :null => false
    t.string   "encrypted_password",     :default => "",                           :null => false
    t.datetime "remember_created_at"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.string   "lang",                   :default => "en",                         :null => false
    t.string   "timezone",               :default => "Central Time (US & Canada)", :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean  "is_deleted",             :default => false
    t.boolean  "invitation_pending",     :default => false
    t.string   "gravatar"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
