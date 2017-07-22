class CreateAssessmentBarrierHistories < ActiveRecord::Migration
  def change
    create_table :assessment_barrier_histories do |t|
    	t.integer :client_assessment_history_id,null:false
    	t.integer :parent_primary_key_id,null:false
    	t.integer :client_assessment_id,null:false
    	t.integer :barrier_id,null:false
    	t.string :assessment_sub_section_refers
    	t.integer :assessment_section_id
    	t.integer :client_assessment_barrier_created_by,null:false
    	t.integer :client_assessment_barrier_updated_by,null:false
    	t.timestamp :client_assessment_barrier_created_at,null:false
      	t.timestamp :client_assessment_barrier_updated_at,null:false
      	t.integer :created_by,null:false
      	t.integer :updated_by,null:false
      t.timestamps
    end
  end
end


