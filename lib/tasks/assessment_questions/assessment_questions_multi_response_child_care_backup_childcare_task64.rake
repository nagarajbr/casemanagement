namespace :assessment_questions_multi_response_child_care_backup_childcare_task64 do

	desc "Assessment Child Care Backup Childcare"
	task :assessment_questions_multi_response_child_care_backup_childcare => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:526,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:526,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

    end
end