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

ActiveRecord::Schema.define(version: 20170222171850) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "ecourts_results", force: :cascade do |t|
    t.integer  "state_code",    limit: 4
    t.integer  "dist_code",     limit: 4
    t.string   "court_type",    limit: 255
    t.string   "court_code",    limit: 255
    t.string   "name",          limit: 255
    t.integer  "year",          limit: 4
    t.string   "response_code", limit: 255
    t.text     "response_body", limit: 4294967295
    t.integer  "search_id",     limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "ecourts_searches", force: :cascade do |t|
    t.string   "state_code", limit: 255
    t.string   "dist_code",  limit: 255
    t.text     "params",     limit: 65535
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "status",     limit: 255
    t.integer  "kase_id",    limit: 4
  end

  create_table "high_courts_bombay_party_wise_details", force: :cascade do |t|
    t.string   "link",                                    limit: 255
    t.string   "response_code",                           limit: 255
    t.text     "response_body",                           limit: 4294967295
    t.integer  "high_courts_bombay_party_wise_result_id", limit: 4
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  create_table "high_courts_bombay_party_wise_results", force: :cascade do |t|
    t.string   "name",                                    limit: 255
    t.string   "year",                                    limit: 255
    t.string   "bench",                                   limit: 255
    t.string   "jurisdiction",                            limit: 255
    t.string   "pet_or_res",                              limit: 255
    t.string   "response_code",                           limit: 255
    t.text     "response_body",                           limit: 4294967295
    t.integer  "high_courts_bombay_party_wise_search_id", limit: 4
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  create_table "high_courts_bombay_party_wise_searches", force: :cascade do |t|
    t.string   "status",     limit: 255
    t.text     "params",     limit: 65535
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "kase_id",    limit: 4
  end

  create_table "kases", force: :cascade do |t|
    t.string   "no",         limit: 255
    t.string   "name",       limit: 255
    t.integer  "from_year",  limit: 4
    t.integer  "to_year",    limit: 4
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "supreme_court_case_numbers", force: :cascade do |t|
    t.string   "case_type",     limit: 255
    t.string   "case_number",   limit: 255
    t.string   "year",          limit: 255
    t.string   "response_code", limit: 255
    t.text     "response_body", limit: 65535
    t.integer  "search_id",     limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "supreme_court_case_title_results", force: :cascade do |t|
    t.string   "title",                              limit: 255
    t.string   "year",                               limit: 255
    t.string   "response_code",                      limit: 255
    t.text     "response_body",                      limit: 4294967295
    t.integer  "supreme_court_case_title_search_id", limit: 4
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  create_table "supreme_court_case_title_searches", force: :cascade do |t|
    t.string   "status",     limit: 255
    t.text     "params",     limit: 65535
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "kase_id",    limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.boolean  "admin"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
