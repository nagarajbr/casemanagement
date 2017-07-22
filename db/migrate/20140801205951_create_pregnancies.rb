class CreatePregnancies < ActiveRecord::Migration
  def change
    create_table :pregnancies do |t|
	    t.references :client, index: true, null: false
	    t.string :pregnancy_status, limit: 1,:default => "Y"
	    t.date :pregnancy_due_date, null: false
	    t.integer :number_of_unborn, null: false
	    t.date  :pregnancy_termination_date
		t.integer :created_by , null:false
	    t.integer :updated_by , null:false
     	t.timestamps
    end
  end
end


