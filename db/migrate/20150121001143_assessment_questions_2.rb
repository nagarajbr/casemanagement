class AssessmentQuestions2 < ActiveRecord::Migration
  def change
  	change_column :assessment_questions, :input_type_id, :integer,:null => true
  end
end
