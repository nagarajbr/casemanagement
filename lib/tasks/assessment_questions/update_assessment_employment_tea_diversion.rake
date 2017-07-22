namespace :update_assessment_employment_tea_diversion do
	desc "update_assessment_employment_tea_diversion "
	task :update_assessment_employment_tea_diversion => :environment do
		AssessmentQuestion.find(3).update(title: "(If not currently working) <br> Do you have a future job offer?")
		AssessmentQuestion.find(88).update(title: "Do you have any challenges in retaining your income or why do you think you are not currently working?")


		AssessmentQuestion.find(2).update(display_order: 10)

		AssessmentQuestion.find(4).update(display_order: 20)

		AssessmentQuestion.find(3).update(display_order: 30)

		AssessmentQuestion.find(88).update(display_order: 40)


		# Change the sort order of display
		# 1.Health
		AssessmentQuestion.find(12).update(display_order: 50)
		# 2.Household
		AssessmentQuestion.find(13).update(display_order: 60)
		# 3.Childcare
		AssessmentQuestion.find(14).update(display_order: 70)
		# 4.Housing / Transportation

		AssessmentQuestion.find(15).update(display_order: 80)

		# 5.Employer Initiated
		AssessmentQuestion.find(6).update(display_order: 90)
		# 6.Job Opportunity
		AssessmentQuestion.find(7).update(display_order: 100)
		# 7. Satisfaction / Motivation
		AssessmentQuestion.find(8).update(display_order: 110)
		# 8. "Compensation"
		AssessmentQuestion.find(9).update(display_order: 120)
		# "Work Site Behavior"
		AssessmentQuestion.find(10).update(display_order: 130)
		# "Experience / Skills"
		AssessmentQuestion.find(11).update(display_order: 140)

		# "If other, please explain"
		AssessmentQuestion.find(89).update(display_order: 150)

		# "Did not provide specific reason"
		AssessmentQuestion.find(495).update(display_order: 160)



		# since wage & Taxes is not used (Question ID = 16)  reuse the question id for label : Additional Reasons for not working
		AssessmentQuestion.find(16).update(title: "Additional reasons for not working",display_order: 85)
		AssessmentQuestionMetadatum.where("assessment_question_id = 16").update_all(response_data_type: 'LABEL')
		# delete Multiple responses for old question 16
		AssessmentQuestionMultiResponse.where("assessment_question_id = 16").destroy_all

		# create new question.
		assessment_question_object = AssessmentQuestion.create(assessment_sub_section_id:2,title:"Could a one-time benefit payment get you through so that you are able to take care of yourself and your family?",question_text:"Could a one-time benefit payment get you through so that you are able to take care of yourself and your family?",display_order:45,enabled:1,required:1,created_by: 1,updated_by: 1)
		# 4.
		AssessmentQuestionMetadatum.create(assessment_question_id:assessment_question_object.id,response_data_type:"DROPDOWN",created_by: 1,updated_by: 1)
		# 5.
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"Select a Value",val:"0",display_order: 10,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"$1-$150",val:"150",display_order: 20,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"$151-$300",val:"300",display_order: 30,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"$301-$450",val:"450",display_order: 40,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"$451-$600",val:"600",display_order: 50,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"$601-$750",val:"750",display_order: 60,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:"$751-$900",val:"900",display_order: 70,created_by: 1,updated_by: 1)
		AssessmentQuestionMultiResponse.create(assessment_question_id:assessment_question_object.id,txt:" More than $900",val:"1000",display_order: 80,created_by: 1,updated_by: 1)



	end
end

