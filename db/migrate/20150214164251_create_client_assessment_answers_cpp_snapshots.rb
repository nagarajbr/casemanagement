class CreateClientAssessmentAnswersCppSnapshots < ActiveRecord::Migration
  def change
    create_table :client_assessment_answers_cpp_snapshots do |t|
    	 t.integer :career_pathway_plan_id, null:false
    	 t.integer :client_assessment_id, null:false
    	 t.integer :assessment_question_id
    	 t.string :answer_value
    	 t.integer :client_assessment_answer_created_by
    	 t.integer :client_assessment_answer_updated_by
  		 t.timestamp :client_assessment_answer_created_at
  		 t.timestamp :client_assessment_answer_updated_at
      	 t.timestamps
    end
  end
end
