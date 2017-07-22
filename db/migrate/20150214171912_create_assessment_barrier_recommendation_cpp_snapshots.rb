class CreateAssessmentBarrierRecommendationCppSnapshots < ActiveRecord::Migration
  def change
    create_table :assessment_barrier_recommendation_cpp_snapshots do |t|
    	 t.integer :career_pathway_plan_id, null:false
    	 t.integer :client_assessment_id, null:false
    	 t.integer :barrier_id
    	 t.integer :recommendation_id
    	 t.text :comments
    	 t.integer :assessment_barrier_recommendation_created_by
    	 t.integer :assessment_barrier_recommendation_updated_by
    	 t.timestamp :assessment_barrier_recommendation_created_at
    	 t.timestamp :assessment_barrier_recommendation_updated_at
    	  t.integer :created_by, null:false
      	 t.integer :updated_by, null:false
      t.timestamps
    end
  end
end



