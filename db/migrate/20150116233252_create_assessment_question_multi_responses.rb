class CreateAssessmentQuestionMultiResponses < ActiveRecord::Migration
  def change
    create_table :assessment_question_multi_responses do |t|
    	t.integer :assessment_question_id
    	t.string :txt
    	t.string :val
       t.integer :created_by , null:false
   		 t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
