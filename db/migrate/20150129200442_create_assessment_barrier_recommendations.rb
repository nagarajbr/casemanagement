class CreateAssessmentBarrierRecommendations < ActiveRecord::Migration
  def change
    create_table :assessment_barrier_recommendations do |t|
      t.integer :client_assessment_id, null:false
      t.integer :barrier_id, null:false
      t.integer :recommendation_id, null:false
      t.text :comments
      t.integer :created_by , null:false
	  t.integer :updated_by , null:false
      t.timestamps
    end
    add_index(:assessment_barrier_recommendations, :client_assessment_id, name: "index_assmnt_b_r_on_client_assessment_id")
  end
end
