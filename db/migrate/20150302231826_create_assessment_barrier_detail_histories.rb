class CreateAssessmentBarrierDetailHistories < ActiveRecord::Migration
  def change
    create_table :assessment_barrier_detail_histories do |t|
    	t.integer :client_assessment_history_id,null:false
    	t.integer :parent_primary_key_id,null:false
    	t.integer :assessment_barrier_id
    	t.integer :assessment_sub_section_id
    	t.text :comments
    	t.integer :display_order,null:false
    	t.integer :client_assessment_barrier_detail_created_by,null:false
    	t.integer :client_assessment_barrier_detail_updated_by,null:false
    	t.timestamp :client_assessment_barrier_detail_created_at,null:false
      	t.timestamp :client_assessment_barrier_detail_updated_at,null:false
    	t.integer :created_by,null:false
      	t.integer :updated_by,null:false
      t.timestamps
    end
  end
end

