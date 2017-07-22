class CreateProgramUnitSizeStandardDetails < ActiveRecord::Migration
  def change
    create_table :program_unit_size_standard_details do |t|
    	t.date :effective_date
	    t.string :standard_type
		t.integer :program_unit_size
		t.decimal :program_limit_amount, precision: 8, scale: 2
	    t.integer :created_by , null:false
	    t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
