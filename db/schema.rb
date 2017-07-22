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

ActiveRecord::Schema.define(version: 20140829201333) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_rights", force: true do |t|
    t.integer  "role_id"
    t.integer  "ruby_element_id"
    t.string   "access",          limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "access_rights", ["role_id"], name: "index_access_rights_on_role_id", using: :btree
  add_index "access_rights", ["ruby_element_id"], name: "index_access_rights_on_ruby_element_id", using: :btree

  create_table "addresses", force: true do |t|
    t.integer  "address_type",                    null: false
    t.string   "address_line1",        limit: 50, null: false
    t.string   "address_line2",        limit: 50
    t.string   "city",                 limit: 50, null: false
    t.integer  "state",                           null: false
    t.string   "zip",                  limit: 5,  null: false
    t.string   "zip_suffix",           limit: 4
    t.date     "effective_begin_date"
    t.date     "effective_end_date"
    t.integer  "county"
    t.string   "in_care_of",           limit: 20
    t.integer  "created_by",                      null: false
    t.integer  "updated_by",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "address_notes"
  end

  create_table "aliens", force: true do |t|
    t.integer  "client_id",                   null: false
    t.date     "alien_DOE"
    t.integer  "refugee_status"
    t.integer  "country_of_origin"
    t.string   "alien_no"
    t.integer  "non_citizen_type"
    t.string   "residency",         limit: 1
    t.integer  "created_by",                  null: false
    t.integer  "updated_by",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "aliens", ["client_id"], name: "index_aliens_on_client_id", using: :btree

  create_table "assignments", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["role_id"], name: "index_assignments_on_role_id", using: :btree
  add_index "assignments", ["user_id"], name: "index_assignments_on_user_id", using: :btree

  create_table "benefits", force: true do |t|
    t.integer  "budget_unit_id",                                  null: false
    t.integer  "warrant_number"
    t.date     "date_of_payment_extract"
    t.integer  "payment_type"
    t.decimal  "check_amount",            precision: 8, scale: 2
    t.integer  "sanction_type"
    t.decimal  "grant_amount",            precision: 8, scale: 2
    t.decimal  "retro_amount",            precision: 8, scale: 2
    t.decimal  "recoup_amount",           precision: 8, scale: 2
    t.integer  "county"
    t.integer  "service_program_id"
    t.integer  "number_of_adults"
    t.integer  "number_of_children"
    t.integer  "created_by",                                      null: false
    t.integer  "updated_by",                                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "benefits", ["budget_unit_id"], name: "index_benefits_on_budget_unit_id", using: :btree


  create_table "client_addresses", force: true do |t|
    t.integer  "client_id"
    t.integer  "address_id"
    t.integer  "created_by", null: false
    t.integer  "updated_by", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_addresses", ["address_id"], name: "index_client_addresses_on_address_id", using: :btree
  add_index "client_addresses", ["client_id"], name: "index_client_addresses_on_client_id", using: :btree

  create_table "client_barriers", force: true do |t|
    t.integer  "client_id",  null: false
    t.integer  "created_by", null: false
    t.integer  "updated_by", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_barriers", ["client_id"], name: "index_client_barriers_on_client_id", using: :btree

  create_table "client_characteristics", force: true do |t|
    t.integer  "client_id"
    t.integer  "characteristic_id"
    t.string   "characteristic_type"
    t.integer  "created_by",          null: false
    t.integer  "updated_by",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_characteristics", ["client_id"], name: "index_client_characteristics_on_client_id", using: :btree

  create_table "client_expenses", force: true do |t|
    t.integer  "client_id"
    t.integer  "expense_id"
    t.integer  "created_by", null: false
    t.integer  "updated_by", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_expenses", ["client_id"], name: "index_client_expenses_on_client_id", using: :btree
  add_index "client_expenses", ["expense_id"], name: "index_client_expenses_on_expense_id", using: :btree

  create_table "client_incomes", force: true do |t|
    t.integer  "client_id"
    t.integer  "income_id"
    t.integer  "created_by", null: false
    t.integer  "updated_by", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_parental_rspabilities", force: true do |t|
    t.integer  "client_relationship_id",                                    null: false
    t.decimal  "amount_collected",                  precision: 8, scale: 2
    t.decimal  "court_ordered_amount",              precision: 8, scale: 2
    t.string   "good_cause",             limit: 1
    t.string   "married_at_birth",       limit: 1
    t.string   "paternity_established",  limit: 1
    t.string   "court_order_number",     limit: 10
    t.integer  "deprivation_code"
    t.integer  "child_support_referral"
    t.integer  "created_by",                                                null: false
    t.integer  "updated_by",                                                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_parental_rspabilities", ["client_relationship_id"], name: "index_client_parental_rspabilities_on_client_relationship_id", using: :btree

  create_table "client_races", force: true do |t|
    t.integer  "client_id"
    t.integer  "race_id"
    t.integer  "created_by", null: false
    t.integer  "updated_by", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_races", ["client_id"], name: "index_client_races_on_client_id", using: :btree

  create_table "client_referrals", force: true do |t|
    t.integer  "client_id",            null: false
    t.integer  "client_barrier_id"
    t.integer  "service_program_id"
    t.date     "referral_datetime"
    t.datetime "appointment_datetime"
    t.text     "appointment_contact"
    t.integer  "barrier_type"
    t.text     "comments"
    t.integer  "created_by",           null: false
    t.integer  "updated_by",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_referrals", ["client_barrier_id"], name: "index_client_referrals_on_client_barrier_id", using: :btree
  add_index "client_referrals", ["client_id"], name: "index_client_referrals_on_client_id", using: :btree

  create_table "client_relationships", force: true do |t|
    t.integer  "from_client_id",    null: false
    t.integer  "relationship_type", null: false
    t.integer  "to_client_id",      null: false
    t.integer  "created_by",        null: false
    t.integer  "updated_by",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "client_resources", force: true do |t|
    t.integer "client_id",   null: false
    t.integer "resource_id", null: false
    t.integer "created_by",  null: false
    t.integer "updated_by",  null: false
  end

  create_table "clients", force: true do |t|
    t.string   "first_name",                      limit: 35,             null: false
    t.string   "last_name",                       limit: 35,             null: false
    t.string   "middle_name",                     limit: 35
    t.string   "suffix",                          limit: 4
    t.string   "middle_inital",                   limit: 1
    t.string   "ssn",                             limit: 9,              null: false
    t.date     "dob"
    t.integer  "gender"
    t.integer  "marital_status"
    t.string   "citizenship",                     limit: 1
    t.date     "identification_verfication_date"
    t.date     "death_date"
    t.integer  "primary_language"
    t.string   "ethnicity",                       limit: 1
    t.string   "ssn_change",                      limit: 1
    t.string   "dob_change",                      limit: 1
    t.string   "name_change",                     limit: 1
    t.integer  "enum_counter",                               default: 0
    t.integer  "sves_type"
    t.string   "sves_status",                     limit: 1
    t.date     "sves_send_date"
    t.date     "sves_verified_date"
    t.integer  "created_by",                                             null: false
    t.integer  "updated_by",                                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ssn_enumeration_type"
    t.integer  "identification_type"
    t.string   "exempt_from_immunization",        limit: 1
    t.string   "other_identification_document",   limit: 15
  end

  create_table "code_tables", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "codetable_items", force: true do |t|
    t.integer  "code_table_id"
    t.string   "short_description"
    t.string   "long_description"
    t.boolean  "system_defined"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active"
    t.string   "type"
    t.integer  "parent_id"
    t.string   "parent_type"
  end

  add_index "codetable_items", ["code_table_id"], name: "index_codetable_items_on_code_table_id", using: :btree

  create_table "disabilities", force: true do |t|
    t.integer  "client_id",              null: false
    t.integer  "disiability_type"
    t.date     "review_expiration_date"
    t.integer  "created_by",             null: false
    t.integer  "updated_by",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "disabilities", ["client_id"], name: "index_disabilities_on_client_id", using: :btree

  create_table "educations", force: true do |t|
    t.integer  "client_id",          null: false
    t.integer  "school_type"
    t.integer  "school_name"
    t.integer  "attendance_type"
    t.text     "school_address_1"
    t.text     "school_address_2"
    t.date     "effective_beg_date"
    t.date     "effective_end_date"
    t.text     "major_study"
    t.integer  "high_grade_level",   null: false
    t.date     "expected_grad_date"
    t.integer  "degree_obtained"
    t.text     "effort"
    t.integer  "created_by",         null: false
    t.integer  "updated_by",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "educations", ["client_id"], name: "index_educations_on_client_id", using: :btree

  create_table "employment_details", force: true do |t|
    t.integer  "employment_id"
    t.date     "effective_begin_date",                         null: false
    t.date     "effective_end_date"
    t.integer  "hours_per_period",                             null: false
    t.decimal  "salary_pay_amt",       precision: 8, scale: 2, null: false
    t.integer  "salary_pay_frequency",                         null: false
    t.integer  "position_type"
    t.integer  "current_status",                               null: false
    t.integer  "created_by",                                   null: false
    t.integer  "updated_by",                                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employment_details", ["employment_id"], name: "index_employment_details_on_employment_id", using: :btree

  create_table "employments", force: true do |t|
    t.integer  "client_id",                       null: false
    t.string   "employer_name",        limit: 35, null: false
    t.string   "employer_contact",     limit: 25
    t.string   "employer_address1",    limit: 30
    t.string   "employer_address2",    limit: 30
    t.string   "employer_phone",       limit: 10
    t.string   "employer_phone_ext",   limit: 5
    t.date     "effective_begin_date",            null: false
    t.date     "effective_end_date"
    t.string   "position_title",       limit: 35
    t.text     "duties"
    t.integer  "leave_reason"
    t.integer  "employment_level"
    t.integer  "placement_ind"
    t.integer  "health_ins_covered"
    t.string   "occupation_code",      limit: 11
    t.integer  "created_by",                      null: false
    t.integer  "updated_by",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employments", ["client_id"], name: "index_employments_on_client_id", using: :btree

  create_table "expense_details", force: true do |t|
    t.integer  "expense_id"
    t.date     "expense_due_date"
    t.decimal  "expense_amount",             precision: 8, scale: 2
    t.integer  "expense_use_code"
    t.integer  "payment_method"
    t.integer  "payment_status"
    t.string   "expense_calc_ind", limit: 1
    t.integer  "created_by",                                         null: false
    t.integer  "updated_by",                                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expense_details", ["expense_id"], name: "index_expense_details_on_expense_id", using: :btree

  create_table "expenses", force: true do |t|
    t.integer  "expensetype",                                           null: false
    t.decimal  "amount",                        precision: 8, scale: 2
    t.date     "effective_beg_date"
    t.date     "effective_end_date"
    t.string   "creditor_name",      limit: 35
    t.string   "creditor_contact",   limit: 35
    t.string   "creditor_phone",     limit: 10
    t.string   "creditor_ext",       limit: 5
    t.integer  "payment_status"
    t.integer  "frequency"
    t.integer  "payment_method"
    t.string   "verified",           limit: 1
    t.text     "notes"
    t.integer  "use_code"
    t.integer  "exp_calc_months"
    t.string   "budget_recalc_ind",  limit: 1
    t.integer  "created_by",                                            null: false
    t.integer  "updated_by",                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "household_members", force: true do |t|
    t.integer  "household_id",                   null: false
    t.integer  "client_id",                      null: false
    t.integer  "household_member_role",          null: false
    t.integer  "household_participation_status", null: false
    t.date     "household_participation_date",   null: false
    t.integer  "created_by",                     null: false
    t.integer  "updated_by",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "household_members", ["client_id"], name: "index_household_members_on_client_id", using: :btree
  add_index "household_members", ["household_id"], name: "index_household_members_on_household_id", using: :btree

  create_table "households", force: true do |t|
    t.integer  "created_by", null: false
    t.integer  "updated_by", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "immunizations", force: true do |t|
    t.integer  "client_id",         null: false
    t.integer  "vaccine_type",      null: false
    t.integer  "provider_id"
    t.date     "date_administered"
    t.integer  "created_by",        null: false
    t.integer  "updated_by",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "immunizations", ["client_id"], name: "index_immunizations_on_client_id", using: :btree

  create_table "income_detail_adjust_reasons", force: true do |t|
    t.integer  "income_detail_id"
    t.decimal  "adjusted_amount",  precision: 8, scale: 2
    t.integer  "adjusted_reason"
    t.integer  "created_by",                               null: false
    t.integer  "updated_by",                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "income_detail_adjust_reasons", ["income_detail_id"], name: "index_income_detail_adjust_reasons_on_income_detail_id", using: :btree

  create_table "income_details", force: true do |t|
    t.integer  "income_id"
    t.integer  "check_type"
    t.date     "date_received"
    t.decimal  "gross_amt",                     precision: 8, scale: 2
    t.decimal  "adjusted_total",                precision: 8, scale: 2
    t.decimal  "net_amt",                       precision: 8, scale: 2
    t.string   "cnt_for_convert_ind", limit: 1
    t.integer  "created_by",                                            null: false
    t.integer  "updated_by",                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "income_details", ["income_id"], name: "index_income_details_on_income_id", using: :btree

  create_table "incomes", force: true do |t|
    t.integer  "incometype",                                           null: false
    t.decimal  "amount",                       precision: 8, scale: 2
    t.integer  "frequency"
    t.integer  "classification"
    t.text     "source"
    t.date     "effective_beg_date"
    t.date     "effective_end_date"
    t.text     "notes"
    t.string   "verified",           limit: 1
    t.decimal  "contract_amt",                 precision: 8, scale: 2
    t.integer  "intended_use_mos"
    t.date     "inc_avg_beg_date"
    t.string   "recal_ind",          limit: 1
    t.integer  "created_by",                                           null: false
    t.integer  "updated_by",                                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", force: true do |t|
    t.integer  "client_id"
    t.integer  "phone_type"
    t.string   "number",     limit: 10
    t.string   "extension",  limit: 5
    t.integer  "created_by",            null: false
    t.integer  "updated_by",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phones", ["client_id"], name: "index_phones_on_client_id", using: :btree

  create_table "pregnancies", force: true do |t|
    t.integer  "client_id",                                          null: false
    t.string   "pregnancy_status",           limit: 1, default: "Y"
    t.date     "pregnancy_due_date",                                 null: false
    t.integer  "number_of_unborn",                                   null: false
    t.date     "pregnancy_termination_date"
    t.integer  "created_by",                                         null: false
    t.integer  "updated_by",                                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pregnancies", ["client_id"], name: "index_pregnancies_on_client_id", using: :btree

  create_table "program_standard_details", force: true do |t|
    t.integer  "program_standard_id",                                   null: false
    t.date     "effective_date",                                        null: false
    t.decimal  "program_standard_limit_amount", precision: 8, scale: 2
    t.decimal  "program_standard_max_shelter",  precision: 8, scale: 2
    t.integer  "created_by",                                            null: false
    t.integer  "updated_by",                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "program_standard_details", ["program_standard_id"], name: "index_program_standard_details_on_program_standard_id", using: :btree

  create_table "program_standards", force: true do |t|
    t.text     "program_standard_name"
    t.text     "program_standard_description"
    t.string   "program_standard_unit_of_measurement", limit: 1
    t.integer  "created_by",                                     null: false
    t.integer  "updated_by",                                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_adjustments", force: true do |t|
    t.integer  "resource_detail_id"
    t.decimal  "resource_adj_amt",   precision: 8, scale: 2
    t.date     "receipt_date"
    t.integer  "reason_code"
    t.date     "adj_begin_date"
    t.date     "adj_end_date"
    t.integer  "adj_num_of_months"
    t.integer  "created_by",                                 null: false
    t.integer  "updated_by",                                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_details", force: true do |t|
    t.integer  "resource_id"
    t.decimal  "resource_value",           precision: 8, scale: 2
    t.date     "resource_valued_date"
    t.decimal  "first_of_month_value",     precision: 8, scale: 2
    t.integer  "res_value_basis"
    t.decimal  "res_ins_face_value",       precision: 8, scale: 2
    t.decimal  "amount_owned_on_resource", precision: 8, scale: 2
    t.date     "amount_owned_as_of_date"
    t.integer  "created_by",                                       null: false
    t.integer  "updated_by",                                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_uses", force: true do |t|
    t.integer  "resource_details_id", null: false
    t.integer  "usage_code"
    t.integer  "created_by",          null: false
    t.integer  "updated_by",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resource_uses", ["resource_details_id"], name: "index_resource_uses_on_resource_details_id", using: :btree

  create_table "resources", force: true do |t|
    t.integer  "resource_type",                                            null: false
    t.decimal  "net_value",                        precision: 8, scale: 2
    t.string   "description",           limit: 50
    t.date     "date_value_determined"
    t.date     "date_assert_acquired"
    t.date     "date_assert_disposed"
    t.string   "verified",              limit: 1
    t.string   "account_number",        limit: 12
    t.decimal  "use_code",                         precision: 4, scale: 1
    t.integer  "number_of_owners"
    t.string   "license_number",        limit: 10
    t.string   "make",                  limit: 20
    t.string   "model",                 limit: 20
    t.string   "year",                  limit: 4
    t.integer  "created_by",                                               null: false
    t.integer  "updated_by",                                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ruby_element_reltns", force: true do |t|
    t.integer  "parent_element_id"
    t.integer  "child_element_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ruby_elements", force: true do |t|
    t.string   "element_name",       limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "element_title",      limit: 50
    t.string   "element_type",       limit: 2
    t.string   "element_microhelp"
    t.string   "element_help_page"
    t.integer  "created_by_user_id"
    t.integer  "updated_by_user_id"
  end

  create_table "sanctions", force: true do |t|
    t.integer  "client_id",                        null: false
    t.integer  "service_program_id",               null: false
    t.integer  "sanction_type",                    null: false
    t.string   "description"
    t.date     "infraction_date"
    t.date     "effective_begin_date",             null: false
    t.integer  "duration_type",                    null: false
    t.string   "not_serviced_indicator", limit: 1
    t.string   "mytodolist_indicator",   limit: 1
    t.integer  "created_by",                       null: false
    t.integer  "updated_by",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sanctions", ["client_id"], name: "index_sanctions_on_client_id", using: :btree
  add_index "sanctions", ["service_program_id"], name: "index_sanctions_on_service_program_id", using: :btree

  create_table "service_programs", force: true do |t|
    t.string   "description",        limit: 250, null: false
    t.string   "title",              limit: 35,  null: false
    t.integer  "service_type"
    t.integer  "usage_type"
    t.string   "schedule_courses",   limit: 1
    t.string   "auto_referral_task", limit: 1
    t.string   "sanction_indicator", limit: 1
    t.integer  "svc_pgm_category"
    t.integer  "created_by",                     null: false
    t.integer  "updated_by",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_param_categories", force: true do |t|
    t.text     "description"
    t.integer  "created_by",  null: false
    t.integer  "updated_by",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_params", force: true do |t|
    t.integer  "system_param_categories_id"
    t.string   "key"
    t.string   "value"
    t.text     "description"
    t.integer  "created_by",                 null: false
    t.integer  "updated_by",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_params", ["system_param_categories_id"], name: "index_system_params_on_system_param_categories_id", using: :btree

  create_table "time_limits", force: true do |t|
    t.integer  "client_id",             null: false
    t.integer  "federal_count"
    t.integer  "tea_state_count"
    t.integer  "work_pays_state_count"
    t.integer  "skip_count"
    t.integer  "out_of_state_count"
    t.date     "payment_month",         null: false
    t.integer  "created_by",            null: false
    t.integer  "updated_by",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "time_limits", ["client_id"], name: "index_time_limits_on_client_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "login",                                        null: false
    t.string   "crypted_password",                             null: false
    t.string   "password_salt",                                null: false
    t.string   "persistence_token",                            null: false
    t.string   "single_access_token",                          null: false
    t.string   "perishable_token",                             null: false
    t.integer  "login_count",                      default: 0, null: false
    t.integer  "failed_login_count",               default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                  limit: 50
    t.string   "title",                 limit: 35
    t.integer  "location"
    t.string   "status",                limit: 1
    t.string   "phone_term",            limit: 4
    t.integer  "language"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "last_passwd_change_at"
    t.integer  "county"
    t.string   "active_directory_id",   limit: 50
    t.string   "asis_emp_num",          limit: 10
    t.integer  "division_code"
    t.string   "email_id",              limit: 50
    t.integer  "cpu"
    t.string   "phone_number",          limit: 10
  end

end
