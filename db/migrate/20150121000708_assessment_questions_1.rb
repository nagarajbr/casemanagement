class AssessmentQuestions1 < ActiveRecord::Migration
  def change
  	rename_column :assessment_questions, :enbled, :enabled
  end
end
