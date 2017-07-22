class CreateEmploymentReadinessPlanCppSnapshots < ActiveRecord::Migration
  def change
    create_table :employment_readiness_plan_cpp_snapshots do |t|
    	 t.integer :career_pathway_plan_id, null:false
    	 t.integer :client_assessment_id, null:false
    	 t.integer :core_hours
    	 t.integer :non_core_hours
    	 t.integer :supportive_services_hours
   	  	 t.integer :other_hours
    	 t.text :comments
    	 t.integer :employment_readiness_plan_created_by
    	 t.integer :employment_readiness_plan_updated_by
    	 t.timestamp :employment_readiness_plan_created_at
    	 t.timestamp :employment_readiness_plan_updated_at
    	 t.integer :created_by, null:false
      	 t.integer :updated_by, null:false

      t.timestamps
    end
  end
end



