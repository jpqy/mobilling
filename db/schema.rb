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

ActiveRecord::Schema.define(version: 20140925131546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "admin_users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.integer  "role",                        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree

  create_table "claim_comments", force: true do |t|
    t.text     "body"
    t.uuid     "user_id"
    t.string   "user_type",  limit: 255
    t.uuid     "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "claims", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id"
    t.uuid     "photo_id"
    t.integer  "status",                              default: 0
    t.json     "details",                             default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
    t.string   "accounting_number",       limit: 255
    t.uuid     "submission_id"
    t.uuid     "batch_acknowledgment_id"
    t.uuid     "remittance_advice_id"
    t.uuid     "error_report_id"
  end

  add_index "claims", ["accounting_number"], name: "index_claims_on_accounting_number", unique: true, using: :btree
  add_index "claims", ["number", "user_id"], name: "index_claims_on_number_and_user_id", unique: true, using: :btree
  add_index "claims", ["submission_id"], name: "index_claims_on_submission_id", using: :btree

  create_table "diagnoses", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "diagnoses", ["name"], name: "index_diagnoses_on_name", unique: true, using: :btree

  create_table "edt_files", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.integer  "status",                      default: 0
    t.text     "contents"
    t.string   "type",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sequence_number"
    t.string   "filename_base",   limit: 255
    t.uuid     "user_id"
    t.uuid     "parent_id"
    t.string   "batch_id",        limit: 255
  end

  add_index "edt_files", ["filename_base"], name: "index_edt_files_on_filename_base", using: :btree
  add_index "edt_files", ["user_id", "batch_id"], name: "index_edt_files_on_user_id_and_batch_id", unique: true, using: :btree
  add_index "edt_files", ["user_id", "filename_base", "sequence_number"], name: "index_edt_files_on_filename", unique: true, using: :btree
  add_index "edt_files", ["user_id"], name: "index_edt_files_on_user_id", using: :btree

  create_table "hospitals", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hospitals", ["name"], name: "index_hospitals_on_name", unique: true, using: :btree

  create_table "photos", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.uuid     "user_id"
    t.string   "file",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_codes", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",                limit: 255
    t.integer  "fee"
    t.date     "effective_date"
    t.date     "termination_date"
    t.boolean  "requires_specialist",             default: false, null: false
  end

  add_index "service_codes", ["code"], name: "index_service_codes_on_code", using: :btree
  add_index "service_codes", ["name"], name: "index_service_codes_on_name", unique: true, using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: true do |t|
    t.string   "name",                 limit: 255
    t.string   "email",                limit: 255
    t.string   "password_digest",      limit: 255
    t.string   "authentication_token", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "agent_id"
    t.string   "pin",                  limit: 255
    t.string   "specialties",                      default: [],     array: true
    t.integer  "provider_number"
    t.string   "group_number",         limit: 4,   default: "0000"
    t.string   "office_code",          limit: 1
    t.integer  "specialty_code"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
