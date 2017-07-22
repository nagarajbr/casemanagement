class AssessmentQuestionMultiResponse < ActiveRecord::Base
	def self.get_responses_for_question_id(arg_question_id)
		where("assessment_question_id = ?",arg_question_id).order("display_order ASC")
	end
end
