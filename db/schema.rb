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

ActiveRecord::Schema.define(:version => 20120610082546) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "answer_text"
    t.string   "youtube_link"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "contributor_id"
  end

  create_table "concept_bundles", :force => true do |t|
    t.integer  "page_id"
    t.string   "title",                :limit => 760
    t.integer  "contributor_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.text     "bundle_elements_hash"
  end

  create_table "concept_bundles_questions", :id => false, :force => true do |t|
    t.integer "concept_bundle_id"
    t.integer "question_id"
  end

  add_index "concept_bundles_questions", ["concept_bundle_id"], :name => "index_concept_bundles_questions_on_concept_bundle_id"
  add_index "concept_bundles_questions", ["question_id"], :name => "index_concept_bundles_questions_on_question_id"

  create_table "concept_videos", :force => true do |t|
    t.integer  "concept_bundle_id"
    t.text     "description"
    t.string   "video"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "html",       :limit => 16777215
    t.string   "url",        :limit => 760
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "wiki_name",  :limit => 760
  end

  add_index "pages", ["url"], :name => "index_pages_on_url", :unique => true

  create_table "pages_prerequisites", :id => false, :force => true do |t|
    t.integer "prerequisite_id"
    t.integer "page_id"
  end

  add_index "pages_prerequisites", ["page_id"], :name => "index_pages_prerequisites_on_page_id"
  add_index "pages_prerequisites", ["prerequisite_id"], :name => "index_pages_prerequisites_on_prerequisite_id"

  create_table "prerequisites", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "prerequisites", ["url"], :name => "index_prerequisites_on_url", :unique => true

  create_table "questions", :force => true do |t|
    t.integer  "concept_bundle_id"
    t.text     "question_text"
    t.string   "difficulty_level",  :limit => 1
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "contributor_id"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",                      :null => false
    t.integer  "item_id",                        :null => false
    t.string   "event",                          :null => false
    t.string   "whodunnit"
    t.text     "object",     :limit => 16777215
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
