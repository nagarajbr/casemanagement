class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
    	t.references :client, index: true, null:false
    	t.string :employer_name , null:false, limit: 35
    	t.string :employer_contact, limit: 25
    	t.string :employer_address1, limit: 30
    	t.string :employer_address2, limit: 30
    	t.string :employer_phone, limit: 10
    	t.string :employer_phone_ext, limit: 5
    	t.date   :effective_begin_date ,null:false
    	t.date   :effective_end_date
    	t.string :position_title, limit: 35
        t.text   :duties
        t.integer :leave_reason
        t.integer :employment_level
        t.integer :placement_ind
        t.integer :health_ins_covered
        t.string :occupation_code, limit: 11
    	t.integer :created_by , null:false
        t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
