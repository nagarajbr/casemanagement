class AlterAssessmentQuestionMultiResponses1 < ActiveRecord::Migration
  def change
  	add_column :assessment_question_multi_responses, :display_order, :integer
  end
end
