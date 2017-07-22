class CreateCareerPathwayPlans < ActiveRecord::Migration
  def change
    create_table :career_pathway_plans do |t|
 	t.integer :client_assessment_id
     t.integer :employment_readyness_plan_id
     t.integer :client_signature
     t.date :client_signed_date
     t.integer :case_worker_signature
     t.date :case_worker_signed_date
     t.integer :supervisor_signature
     t.date :supervisor_signed_date
      t.integer :created_by , null:false
	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
