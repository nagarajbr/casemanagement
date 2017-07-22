namespace :additional_prescreen_assessment_questions do
	desc "Assessment Employment Job Opportunity"
	task :additional_prescreen_assessment_questions => :environment do

		# Q3
		# 3.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:47,title:"Housing / Transportation",question_text:"Housing / Transportation",display_order:120,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"CHECKBOXGROUP",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"No transportation",val:"No transportation",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Vehicle needs repair",val:"Vehicle needs repair",display_order: 20,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"No permanent housing",val:"No permanent housing",display_order: 30,created_by: 1,updated_by: 1)


	end
end