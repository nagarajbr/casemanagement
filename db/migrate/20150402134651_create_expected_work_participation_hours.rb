class CreateExpectedWorkParticipationHours < ActiveRecord::Migration
  def change
    create_table :expected_work_participation_hours do |t|
    	t.integer :service_program_id, null: false
    	t.integer :case_type, null: false
    	t.string :work_participation_mandatory_deferred
    	t.string :work_participation_condition
    	t.integer :min_core_hours, null: false
    	t.integer :non_core_hours, null: false
    	t.string :comments
    	t.integer :created_by , null:false
    	t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
