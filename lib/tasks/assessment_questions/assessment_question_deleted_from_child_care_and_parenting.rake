namespace :assessment_question_deleted do
	desc "Assessment questions ,multi response,and related metadata is deleted from child care and parenting "
	task :assessment_question_deleted_from_child_care_and_parenting => :environment do
		#766;23;"Is it a written or verbal agreement?"
		 AssessmentQuestion.where("assessment_sub_section_id = 23 and id = 766").destroy_all
		 AssessmentQuestionMetadatum.where("assessment_question_id = 766").destroy_all
		 AssessmentQuestionMultiResponse.where("assessment_question_id = 766").destroy_all

	end
end