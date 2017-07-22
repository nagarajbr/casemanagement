class CreateAssessmentBarrierDetailsCppSnapshots < ActiveRecord::Migration
  def change
    create_table :assessment_barrier_details_cpp_snapshots do |t|
    	 t.integer :career_pathway_plan_id, null:false
    	 t.integer :client_assessment_id, null:false
    	 t.integer :assessment_barrier_id
    	 t.integer :assessment_sub_section_id
    	 t.text :comments
    	 t.integer :display_order
    	 t.integer :assessment_barrier_detail_created_by
    	 t.integer :assessment_barrier_detail_updated_by
    	 t.timestamp :assessment_barrier_detail_created_at
    	 t.timestamp :assessment_barrier_detail_updated_at
    	 t.integer :created_by, null:false
      	 t.integer :updated_by, null:false
      t.timestamps
    end
  end
end

