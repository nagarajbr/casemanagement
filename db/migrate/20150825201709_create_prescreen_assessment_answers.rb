class CreatePrescreenAssessmentAnswers < ActiveRecord::Migration
  def change
    create_table :prescreen_assessment_answers do |t|
    	t.integer :prescreen_household_id, null:false
    	t.integer :assessment_question_id
    	t.string :answer_value
    	t.integer :created_by , null:false
    	t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
