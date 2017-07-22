class CreateActionPlanDetailCppSnapshots < ActiveRecord::Migration
  def change
    create_table :action_plan_detail_cpp_snapshots do |t|
    	t.integer :career_pathway_plan_id, null:false
    	 t.integer :action_plan_id
    	 t.integer :barrier_id
    	 t.integer :provider_id
    	 t.integer :reference_id
    	 t.integer :activity_classfication
    	 t.integer :activity_type
    	 t.integer :component_type
    	 t.integer :entity_type
    	 t.integer :activity_status
    	 t.integer :hours_per_day
    	 t.date :start_date
    	 t.date :end_date
    	 t.date :client_agreement_date
    	 t.text :notes
       t.integer :action_plan_detail_created_by
    	 t.integer :action_plan_detail_updated_by
    	 t.timestamp :action_plan_detail_created_at
    	 t.timestamp :action_plan_detail_updated_at
    	 t.integer :created_by, null:false
      	 t.integer :updated_by, null:false
      t.timestamps
    end
  end
end


