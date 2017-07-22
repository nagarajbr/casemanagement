class CreateClientAssessmentAnswerHistories < ActiveRecord::Migration
  def change
    create_table :client_assessment_answer_histories do |t|
    	t.integer :client_assessment_history_id,null:false
    	t.integer :parent_primary_key_id,null:false
    	t.integer :client_assessment_id,null:false
    	t.integer :assessment_question_id,null:false
    	t.string :answer_value
    	t.integer :client_assessment_answer_created_by,null:false
    	t.integer :client_assessment_answer_updated_by,null:false
    	t.timestamp :client_assessment_answer_created_at,null:false
      	t.timestamp :client_assessment_answer_updated_at,null:false
      	t.integer :created_by,null:false
      	t.integer :updated_by,null:false
      t.timestamps
    end
  end
end

