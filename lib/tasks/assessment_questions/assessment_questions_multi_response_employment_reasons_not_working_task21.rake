namespace :assessment_questions_multi_response_employment_reasons_not_working_task21 do

	desc "Assessment Employment reason not Interests Response"
	task :assessment_questions_multi_response_employment_reasons_not_working => :environment do

		AssessmentQuestionMultiResponse.create(assessment_question_id:6,txt:"Laid off due to company downsizing or poor company performance",val:"Laid off due to company downsizing or poor company performance",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:6,txt:"Did not pass drug test",val:"Did not pass drug test",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:6,txt:"Criminal record",val:"Criminal record",display_order: 3,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:7,txt:"Quit",val:"Quit",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:7,txt:"No jobs available",val:"No jobs available",display_order: 2,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:8,txt:"Did not like the work involved",val:"Did not like the work involved",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:8,txt:"Do not want to work",val:"Do not want to work",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:8,txt:"Schedule/shift issue",val:"Schedule/shift issue",display_order: 3,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:8,txt:"Too busy to work",val:"Too busy to work",display_order: 4,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:9,txt:"Low wages/hours",val:"Low wages/hours",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:9,txt:"No benefits",val:"No benefits",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:9,txt:"Poor benefits",val:"Poor benefits",display_order: 3,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:10,txt:"Insubordination",val:"Insubordination",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:10,txt:"Interpersonal conflicts",val:"Interpersonal conflicts",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:10,txt:"Tardiness/Absence",val:"Tardiness/Absence",display_order: 3,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:11,txt:"Inadequate education, experience, or skills",val:"Inadequate education, experience, or skills",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:11,txt:"Language barrier",val:"Language barrier",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:11,txt:"Returned to school",val:"Returned to school",display_order: 3,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:12,txt:"Physical health",val:"Physical health",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:12,txt:"Mental health/stress",val:"Mental health/stress",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:12,txt:"Pregnancy",val:"Pregnancy",display_order: 3,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:12,txt:"Alcohol/drugs",val:"Alcohol/drugs",display_order: 4,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:13,txt:"Issue with child",val:"Issue with child",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:13,txt:"Issue with household member",val:"Issue with household member",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:13,txt:"Need to work close to home",val:"Need to work close to home",display_order: 3,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:14,txt:"Can not find childcare",val:"Can not find childcare",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:14,txt:"Location of available child care",val:"Location of available child care",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:14,txt:"Can not afford",val:"Can not afford",display_order: 3,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:15,txt:"No transportation",val:"No transportation",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:15,txt:"Vehicle needs repair",val:"Vehicle needs repair",display_order: 2,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:15,txt:"No permanent housing",val:"No permanent housing",display_order: 3,created_by: 1,updated_by: 1)

		AssessmentQuestionMultiResponse.create(assessment_question_id:16,txt:"Wage garnishment",val:"Wage garnishment",display_order: 1,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:16,txt:"Lien",val:"Lien",display_order: 2,created_by: 1,updated_by: 1)



    end
end