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

ActiveRecord::Schema.define(version: 20160101145856) do

  create_table "messageables", force: :cascade do |t|
    t.string   "name"
    t.string   "topic"
    t.string   "purpose"
    t.string   "external_id"
    t.string   "type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "messageables", ["type", "external_id"], name: "index_messageables_on_type_and_external_id", unique: true

  create_table "messages", force: :cascade do |t|
    t.string   "text"
    t.string   "external_id"
    t.integer  "user_id"
    t.string   "messageable_type"
    t.integer  "messageable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "messages", ["external_id"], name: "index_messages_on_external_id"
  add_index "messages", ["messageable_id"], name: "index_messages_on_messageable_id"
  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "external_id"
    t.string   "real_name"
    t.string   "image_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "users", ["external_id"], name: "index_users_on_external_id", unique: true

end
