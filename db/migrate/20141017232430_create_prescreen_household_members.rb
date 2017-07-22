class CreatePrescreenHouseholdMembers < ActiveRecord::Migration
  def change
    create_table :prescreen_household_members do |t|
    	t.references :prescreen_household,null: false, index: true
    	t.string  :first_name, null: false , limit: 35
   		t.string  :last_name, null: false , limit: 35
   		t.integer :age, null: false
   		t.string :citizenship_flag, null: false, limit: 1
   		t.string :residency_flag, null: false, limit: 1
   		t.integer :highest_education_grade_completed
   		t.string :primary_member_flag,null: false, limit: 1
      t.timestamps
    end
  end
end
