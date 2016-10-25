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

ActiveRecord::Schema.define(version: 20161025201134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "spud_permissions", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "tag",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tag"], name: "index_spud_permissions_on_tag", unique: true, using: :btree
  end

  create_table "spud_role_permissions", force: :cascade do |t|
    t.integer  "spud_role_id",        null: false
    t.string   "spud_permission_tag", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["spud_permission_tag"], name: "index_spud_role_permissions_on_spud_permission_tag", using: :btree
    t.index ["spud_role_id"], name: "index_spud_role_permissions_on_spud_role_id", using: :btree
  end

  create_table "spud_roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spud_user_settings", force: :cascade do |t|
    t.integer  "spud_user_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spud_users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "super_admin"
    t.string   "login",                                    null: false
    t.string   "email",                                    null: false
    t.string   "crypted_password",                         null: false
    t.string   "password_salt",                            null: false
    t.string   "persistence_token",                        null: false
    t.string   "single_access_token",                      null: false
    t.string   "perishable_token",                         null: false
    t.integer  "login_count",              default: 0,     null: false
    t.integer  "failed_login_count",       default: 0,     null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
    t.integer  "spud_role_id"
    t.boolean  "requires_password_change", default: false
    t.index ["email"], name: "index_spud_users_on_email", using: :btree
    t.index ["login"], name: "index_spud_users_on_login", using: :btree
    t.index ["spud_role_id"], name: "index_spud_users_on_spud_role_id", using: :btree
  end

end
