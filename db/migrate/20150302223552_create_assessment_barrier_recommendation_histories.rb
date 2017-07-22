class CreateAssessmentBarrierRecommendationHistories < ActiveRecord::Migration
  def change
    create_table :assessment_barrier_recommendation_histories do |t|
    	t.integer :client_assessment_history_id,null:false
    	t.integer :parent_primary_key_id,null:false
    	t.integer :client_assessment_id,null:false
    	t.integer :barrier_id,null:false
    	t.integer :recommendation_id,null:false
    	t.text :comments
    	t.integer :client_assessment_barrier_recommendation_created_by,null:false
    	t.integer :client_assessment_barrier_recommendation_updated_by,null:false
    	t.timestamp :client_assessment_barrier_recommendation_created_at,null:false
      	t.timestamp :client_assessment_barrier_recommendation_updated_at,null:false
      	t.integer :created_by,null:false
      	t.integer :updated_by,null:false

      t.timestamps
    end
  end
end


