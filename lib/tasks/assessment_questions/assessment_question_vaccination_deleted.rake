namespace :assessment_question_vaccination_deleted do
	desc "Assessment questions ,multi response,and related metadata is deleted from assessment_question_vaccination_deleted "
	task :assessment_question_vaccination_deleted => :environment do
		# 68;29;" Are you current with your vaccinations?"
		 AssessmentQuestionMultiResponse.where("assessment_question_id = 68").destroy_all
		 AssessmentQuestionMetadatum.where("assessment_question_id = 68").destroy_all
		 AssessmentQuestion.where("assessment_sub_section_id = 29 and id = 68").destroy_all

		 # update barrier to recommendation mapping
		 #BARRIER -  18;8;"	Health challenge to work	"
		 # RECOMMENDATION - 14;"Offer a referral to local Health Department (DHEC) or Free Clinic.</br></br>If participant does not have Medicaid or health insurance, make a referral to local Medicaid office.	 "
		 # BARRIER TO RECOMMENDATION MAPPING  18 TO 14.
		 StandardRecommendation.where("barrier_id = 18").update_all("recommendation_id = 14")
		 #
		 Barrier.where("id = 22").update_all("description = 'Mental health challenge'")
		 #

		 AssessmentQuestionMultiResponse.where("assessment_question_id = 776").destroy_all
		 AssessmentQuestionMetadatum.where("assessment_question_id = 776").destroy_all
		 AssessmentQuestion.where("id = 776").destroy_all

		 AssessmentQuestion.where("id = 735").update_all("title = 'Is someone in your household pregnant? or Is someone currently pregnant with your child?',question_text = 'Is someone in your household pregnant? or Is someone currently pregnant with your child?'")


	end
end

