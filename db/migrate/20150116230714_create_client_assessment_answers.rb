class CreateClientAssessmentAnswers < ActiveRecord::Migration
  def change
    create_table :client_assessment_answers do |t|
      t.references :client_assessment, index: true, null: false
      t.integer :assessment_question_id, null: false
      t.string :answer_value
      t.integer :created_by , null:false
   		 t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
