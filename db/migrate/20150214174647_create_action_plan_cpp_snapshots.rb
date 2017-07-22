class CreateActionPlanCppSnapshots < ActiveRecord::Migration
  def change
    create_table :action_plan_cpp_snapshots do |t|
    	t.integer :career_pathway_plan_id, null:false
    	t.integer :employment_readiness_plan_id
    	t.integer :client_id
    	t.integer :household_id
    	t.integer :program_unit_id
    	t.integer :action_plan_type
    	t.integer :action_plan_status
    	t.integer :required_participation_hours
    	t.date :start_date
    	t.date :end_date
    	t.date :client_agreement_date
    	t.text :notes
    	 t.integer :action_plan_created_by
    	 t.integer :action_plan_updated_by
    	 t.timestamp :action_plan_created_at
    	 t.timestamp :action_plan_updated_at
    	 t.integer :created_by, null:false
      	 t.integer :updated_by, null:false
      t.timestamps
    end
  end
end

