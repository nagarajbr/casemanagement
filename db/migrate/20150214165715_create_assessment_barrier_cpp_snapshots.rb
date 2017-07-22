class CreateAssessmentBarrierCppSnapshots < ActiveRecord::Migration
  def change
    create_table :assessment_barrier_cpp_snapshots do |t|
    	 t.integer :career_pathway_plan_id, null:false
    	 t.integer :client_assessment_id, null:false
    	 t.integer :barrier_id, null:false
    	 t.integer :assessment_section_id
    	 t.string :assessment_sub_section_refers
    	 t.integer :assessment_barrier_created_by
    	 t.integer :assessment_barrier_updated_by
    	 t.timestamp :assessment_barrier_created_at
    	 t.timestamp :assessment_barrier_updated_at
    	 t.integer :created_by, null:false
      	 t.integer :updated_by, null:false
	     t.timestamps
    end
  end
end



