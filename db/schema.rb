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

ActiveRecord::Schema.define(:version => 20120521072815) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "instance_id",                        :null => false
    t.string   "type",        :default => "article", :null => false
  end

  add_index "articles", ["instance_id"], :name => "index_articles_on_instance_id"

  create_table "availabilities", :force => true do |t|
    t.integer  "user_id"
    t.datetime "date"
    t.boolean  "value"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "instance_id", :null => false
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
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "instance_id", :null => false
  end

  add_index "links", ["instance_id"], :name => "index_links_on_instance_id"

  create_table "notifications", :force => true do |t|
    t.string   "notification_type", :default => "article"
    t.string   "message"
    t.string   "href"
    t.boolean  "is_read"
    t.integer  "user_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "instance_id",                              :null => false
  end

  add_index "notifications", ["instance_id"], :name => "index_notifications_on_instance_id"

  create_table "relationships", :force => true do |t|
    t.integer "user_id",     :null => false
    t.integer "instance_id", :null => false
  end

  add_index "relationships", ["instance_id"], :name => "index_relationships_on_instance_id"
  add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                :default => "",    :null => false
    t.string   "email",               :default => "",    :null => false
    t.boolean  "is_admin",            :default => false, :null => false
    t.string   "login",               :default => "",    :null => false
    t.string   "encrypted_password",  :default => "",    :null => false
    t.datetime "remember_created_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "color",               :default => "000", :null => false
    t.string   "lang",                :default => "en",  :null => false
    t.string   "avatar",                                 :null => false
    t.string   "superadmin",          :default => "0",   :null => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
