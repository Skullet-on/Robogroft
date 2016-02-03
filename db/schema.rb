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

ActiveRecord::Schema.define(version: 20160126122618) do

  create_table "tasks", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "status"
    t.string   "cmd"
    t.float    "progress"
    t.string   "file"
    t.string   "email"
    t.integer  "timeout"
    t.boolean  "restore"
    t.integer  "number"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks_vms", id: false, force: true do |t|
    t.integer "task_id"
    t.integer "vm_id"
  end

  add_index "tasks_vms", ["task_id"], name: "index_tasks_vms_on_task_id"
  add_index "tasks_vms", ["vm_id"], name: "index_tasks_vms_on_vm_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                  default: "",     null: false
    t.string   "role",                   default: "user", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vms", force: true do |t|
    t.string   "name"
    t.string   "vhash"
    t.string   "subname"
    t.string   "state",      default: "waiting", null: false
    t.integer  "timeout"
    t.float    "progress",   default: 0.0,       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vms", ["vhash"], name: "index_vms_on_vhash", unique: true

end
