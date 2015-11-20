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

ActiveRecord::Schema.define(version: 20151120190954) do

  create_table "days", force: :cascade do |t|
    t.integer  "machine_id", limit: 4
    t.date     "day"
    t.integer  "shifts",     limit: 4
    t.integer  "hours",      limit: 4
    t.integer  "busy",       limit: 4
    t.integer  "available",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.time     "start_time"
    t.integer  "minutes",    limit: 4
  end

  add_index "days", ["machine_id"], name: "index_days_on_machine_id", using: :btree

  create_table "has_leftovers", force: :cascade do |t|
    t.integer  "order_id",    limit: 4
    t.integer  "leftover_id", limit: 4
    t.float    "quantity",    limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "has_leftovers", ["leftover_id"], name: "index_has_leftovers_on_leftover_id", using: :btree
  add_index "has_leftovers", ["order_id"], name: "index_has_leftovers_on_order_id", using: :btree

  create_table "has_procedures", force: :cascade do |t|
    t.integer  "machine_id",   limit: 4
    t.integer  "procedure_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "has_procedures", ["machine_id"], name: "index_has_procedures_on_machine_id", using: :btree
  add_index "has_procedures", ["procedure_id"], name: "index_has_procedures_on_procedure_id", using: :btree

  create_table "leftovers", force: :cascade do |t|
    t.float    "quantity",           limit: 24
    t.float    "quantity_available", limit: 24
    t.string   "um",                 limit: 255
    t.float    "weight",             limit: 24
    t.string   "location",           limit: 255
    t.integer  "order_origin",       limit: 4
    t.integer  "sheet_id",           limit: 4
    t.integer  "sheet_version",      limit: 4
    t.date     "entry_date"
    t.string   "disposition",        limit: 255
    t.string   "sheet_composite",    limit: 255
    t.string   "place_origin",       limit: 255
    t.string   "state",              limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "machines", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "press",      limit: 255
  end

  create_table "measurements", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "state",                     limit: 255,   default: "activo"
    t.float    "weight",                    limit: 24
    t.integer  "repeat",                    limit: 4
    t.integer  "scheduled_meters",          limit: 4
    t.date     "date_offer"
    t.integer  "outsourced_id",             limit: 4
    t.string   "outsourced_name",           limit: 255
    t.integer  "outsourced_tolerance_down", limit: 4
    t.integer  "outsourced_tolerance_up",   limit: 4
    t.date     "order_date_request"
    t.integer  "order_number",              limit: 4
    t.float    "order_quantity",            limit: 24
    t.string   "order_type",                limit: 255
    t.string   "order_um",                  limit: 255
    t.float    "order_unit_value",          limit: 24
    t.float    "sheet_caliber",             limit: 24
    t.integer  "sheet_client",              limit: 4
    t.string   "sheet_composite",           limit: 255
    t.string   "sheet_cut_type",            limit: 255
    t.string   "sheet_film",                limit: 255
    t.float    "sheet_guillotine",          limit: 24
    t.float    "sheet_height",              limit: 24
    t.float    "sheet_height_planned",      limit: 24
    t.integer  "sheet_id",                  limit: 4
    t.float    "sheet_meters_roll",         limit: 24
    t.integer  "sheet_number",              limit: 4
    t.boolean  "sheet_print"
    t.string   "sheet_product_type",        limit: 255
    t.text     "sheet_route",               limit: 65535
    t.integer  "sheet_spaces",              limit: 4
    t.integer  "sheet_version",             limit: 4
    t.float    "sheet_width",               limit: 24
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.integer  "route_id",                  limit: 4
  end

  add_index "orders", ["route_id"], name: "index_orders_on_route_id", using: :btree

  create_table "procedures", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.boolean  "press"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "routes", force: :cascade do |t|
    t.float    "waste",      limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "standards", force: :cascade do |t|
    t.integer  "index",      limit: 4
    t.integer  "machine_id", limit: 4
    t.string   "um",         limit: 255
    t.integer  "per_hour",   limit: 4
    t.float    "waste",      limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "standards", ["machine_id"], name: "index_standards_on_machine_id", using: :btree

  create_table "subprocesses", force: :cascade do |t|
    t.integer  "order_id",     limit: 4
    t.integer  "procedure_id", limit: 4
    t.integer  "standard_id",  limit: 4
    t.integer  "minutes",      limit: 4
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer  "meter",        limit: 4
    t.integer  "sequence",     limit: 4
    t.string   "state",        limit: 255
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "day_id",       limit: 4
    t.integer  "setup_time",   limit: 4,   default: 0
  end

  add_index "subprocesses", ["day_id"], name: "index_subprocesses_on_day_id", using: :btree
  add_index "subprocesses", ["order_id"], name: "index_subprocesses_on_order_id", using: :btree
  add_index "subprocesses", ["procedure_id"], name: "index_subprocesses_on_procedure_id", using: :btree
  add_index "subprocesses", ["standard_id"], name: "index_subprocesses_on_standard_id", using: :btree

  add_foreign_key "days", "machines"
  add_foreign_key "has_leftovers", "leftovers"
  add_foreign_key "has_leftovers", "orders"
  add_foreign_key "has_procedures", "machines"
  add_foreign_key "has_procedures", "procedures"
  add_foreign_key "orders", "routes"
  add_foreign_key "standards", "machines"
  add_foreign_key "subprocesses", "days"
  add_foreign_key "subprocesses", "orders"
  add_foreign_key "subprocesses", "procedures"
  add_foreign_key "subprocesses", "standards"
end
