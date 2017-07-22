namespace :assessment_questions_modified_for_pregnancy do
	desc "Assessment questions modified for pregnency"
	task :assessment_questions_modified_for_pregnancy => :environment do


		 #deleting 1) Is someone in your household pregnant? 2)Is someone currently pregnant with your child? questions
		connection = ActiveRecord::Base.connection()
		connection.execute("DELETE from assessment_question_multi_responses where assessment_question_id in(736,737) and id in(725,726,727,728)")
		connection.execute("DELETE from assessment_question_metadata where assessment_question_id in(736,737) and id in(429,430)")
		connection.execute("DELETE from assessment_questions where assessment_sub_section_id = 19 and id in(736,737)")
         #updating Are you pregnant? to Are you pregnant? or Is someone in your household pregnant? or Is someone currently pregnant with your child?
         AssessmentQuestion.where("assessment_sub_section_id = 19 and id = 735").update_all(title: "Are you pregnant? or Is someone in your household pregnant? or Is someone currently pregnant with your child?",question_text: "Are you pregnant? or Is someone in your household pregnant? or Is someone currently pregnant with your child?")
         #.add one more answer (May be) to this question - multiresponse
         AssessmentQuestionMultiResponse.create(assessment_question_id:741 ,txt:"Maybe",val:"Maybe",display_order: 3,created_by: 1,updated_by: 1)

  end
end
