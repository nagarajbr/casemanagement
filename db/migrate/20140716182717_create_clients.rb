class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|

    t.string  :first_name, null: false , limit: 35
    t.string  :last_name, null: false , limit: 35
    t.string  :middle_name , limit: 35
    t.string  :suffix , limit: 4
    t.string  :middle_inital , limit: 1
    t.string  :ssn , limit: 9
    t.date    :dob
    t.integer :sex
    t.integer :marital_status
    t.string  :citizenship, limit: 1
    t.string  :verfication_doc_type, limit: 12
    t.date    :verfication_date
    t.date    :death_date
    t.integer :primary_language
    t.string  :ethnicity, limit: 1
    t.string  :exempt, limit: 1
    t.string  :ssn_change, limit: 1
    t.string  :dob_change, limit: 1
    t.string  :name_change, limit: 1
    t.integer :enum_counter, default: 0
    t.integer :sves_type
    t.string  :sves_status, limit: 1
    t.date    :sves_send_date
	t.date    :sves_verified_date
	t.integer :created_by , null:false
    t.integer :updated_by , null:false
    t.timestamps
    end
  end
end
