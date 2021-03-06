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

ActiveRecord::Schema.define(version: 20160722210522) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "claim_comments", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.text     "body"
    t.uuid     "user_id"
    t.uuid     "claim_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",       default: false
  end

  create_table "claim_files", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "claim_id"
    t.uuid     "edt_file_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "edt_file_type"
  end

  create_table "claim_items", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "claim_id",                null: false
    t.date     "day",                     null: false
    t.string   "diagnosis",  default: "", null: false
    t.string   "time_in"
    t.string   "time_out"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "claim_items", ["claim_id"], name: "index_claim_items_on_claim_id", using: :btree

  create_table "claim_rows", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "item_id",                        null: false
    t.string   "code",           default: "",    null: false
    t.integer  "fee"
    t.integer  "paid"
    t.integer  "units"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "override_fee",   default: false, null: false
    t.boolean  "override_units", default: false, null: false
  end

  add_index "claim_rows", ["item_id", "fee"], name: "index_claim_rows_on_item_id_and_fee", using: :btree
  add_index "claim_rows", ["item_id"], name: "index_claim_rows_on_item_id", using: :btree

  create_table "claims", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id"
    t.uuid     "photo_id"
    t.integer  "status",                     default: 0
    t.json     "details",                    default: {}
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
    t.uuid     "original_id"
    t.integer  "submitted_fee",              default: 0
    t.integer  "paid_fee",                   default: 0
    t.string   "specialty",                  default: "family_medicine", null: false
    t.string   "patient_name",               default: "",                null: false
    t.string   "patient_number",             default: "",                null: false
    t.string   "patient_province",           default: "ON",              null: false
    t.date     "patient_birthday"
    t.string   "patient_sex",                default: "F",               null: false
    t.string   "hospital"
    t.string   "referring_physician"
    t.boolean  "most_responsible_physician", default: false,             null: false
    t.date     "admission_on"
    t.date     "first_seen_on"
    t.boolean  "first_seen_consult",         default: false,             null: false
    t.date     "last_seen_on"
    t.boolean  "last_seen_discharge",        default: false,             null: false
    t.boolean  "icu_transfer",               default: false,             null: false
    t.string   "consult_type"
    t.string   "consult_time_in"
    t.string   "consult_time_out"
    t.string   "consult_premium_visit"
    t.boolean  "consult_premium_first",      default: false,             null: false
    t.boolean  "consult_premium_travel",     default: false,             null: false
    t.string   "referring_laboratory"
    t.string   "payment_program"
    t.string   "payee"
    t.boolean  "manual_review_indicator",    default: false,             null: false
    t.string   "service_location"
    t.string   "last_code_generation"
    t.jsonb    "diagnoses",                  default: [],                null: false
  end

  add_index "claims", ["number", "user_id"], name: "index_claims_on_number_and_user_id", unique: true, using: :btree

  create_table "diagnoses", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "diagnoses", ["name"], name: "index_diagnoses_on_name", unique: true, using: :btree

  create_table "edt_files", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "status",          default: 0
    t.text     "contents"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sequence_number"
    t.string   "filename_base"
    t.uuid     "user_id"
    t.uuid     "parent_id"
    t.string   "batch_id"
  end

  add_index "edt_files", ["filename_base"], name: "index_edt_files_on_filename_base", using: :btree
  add_index "edt_files", ["user_id", "batch_id"], name: "index_edt_files_on_user_id_and_batch_id", unique: true, using: :btree
  add_index "edt_files", ["user_id", "filename_base", "sequence_number"], name: "index_edt_files_on_filename", unique: true, using: :btree
  add_index "edt_files", ["user_id"], name: "index_edt_files_on_user_id", using: :btree

  create_table "error_report_explanatory_codes", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "error_report_rejection_conditions", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hospitals", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hospitals", ["name"], name: "index_hospitals_on_name", unique: true, using: :btree

  create_table "photos", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "remittance_advice_codes", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_codes", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.integer  "fee"
    t.date     "effective_date"
    t.date     "termination_date"
    t.boolean  "requires_specialist",      default: false, null: false
    t.boolean  "requires_diagnostic_code", default: false, null: false
  end

  add_index "service_codes", ["code"], name: "index_service_codes_on_code", using: :btree
  add_index "service_codes", ["name"], name: "index_service_codes_on_name", unique: true, using: :btree

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.uuid     "agent_id"
    t.string   "pin"
    t.string   "specialties",                      default: [],                  array: true
    t.integer  "provider_number"
    t.string   "group_number",         limit: 4,   default: "0000"
    t.string   "office_code",          limit: 1
    t.integer  "specialty_code"
    t.integer  "role",                             default: 0,      null: false
    t.string   "default_specialty",    limit: 255
    t.datetime "token_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
