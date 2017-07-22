namespace :assessment_questions_employment_job_opportunity5 do
	desc "Assessment Employment Job Opportunity"
	task :assessment_questions_employment_job_opportunity5 => :environment do


		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:2,title:"Other",question_text:"Other",display_order:18,enabled:1,required:1,created_by: 1,updated_by: 1)
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"LABEL",created_by: 1,updated_by: 1)


		AssessmentQuestion.where("id = 89").update_all(title:'Notes',question_text:'Notes')


	end
end