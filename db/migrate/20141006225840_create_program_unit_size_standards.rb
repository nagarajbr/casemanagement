class CreateProgramUnitSizeStandards < ActiveRecord::Migration
  def change
    create_table :program_unit_size_standards do |t|
	    t.date :effective_date
	    t.string :standard_type
		t.decimal :percent_of_grant, precision: 5, scale: 2
		t.decimal :addtl_member_amt, precision: 8, scale: 2
	    t.integer :created_by , null:false
	    t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
