namespace :assessment_questions_multi_response_child_care_childcare_task62 do

	desc "Assessment Child Care Child Care"
	task :assessment_questions_multi_response_child_care_childcare => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:82,txt:"Yes",val:"Y",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:82,txt:"No",val:"N",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Costs too much here",val:"Costs too much here",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Child sick or disabled",val:"Child sick or disabled",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Too far from work or home",val:"Too far from work or home",display_order: 3,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Worry about child abuse / unsafe environment",val:"Worry about child abuse / unsafe environment",display_order: 4,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"My child has medical conditions",val:"My child has medical conditions",display_order: 5,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Prefer home-based childcare over center-based childcare",val:"Prefer home-based childcare over center-based childcare",display_order: 6,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Subsidy late, so lost provider",val:"Subsidy late, so lost provider",display_order: 7,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Couldn't find care for times needed",val:"Couldn't find care for times needed",display_order: 8,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Caregiver unavailable / unreliable",val:"Caregiver unavailable / unreliable",display_order: 9,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Afraid to leave child in care of someone else",val:"Afraid to leave child in care of someone else",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Do not feel comfortable with others taking care of my child",val:"Do not feel comfortable with others taking care of my child",display_order: 11,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Cannot get to childcare provider (no transportation access)",val:"Cannot get to childcare provider (no transportation access)",display_order: 12,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:83,txt:"Other",val:"Other",display_order: 13,created_by: 1,updated_by: 1)
    end
end