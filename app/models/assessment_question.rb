class AssessmentQuestion < ActiveRecord::Base

	def self.get_questions_collection(arg_sub_section_id)
		where("assessment_sub_section_id = ? and enabled = 1",arg_sub_section_id).order("display_order ASC")
	end

	def self.get_title_of_question(arg_id)
		where("id = ?",arg_id).first.title
	end
end
