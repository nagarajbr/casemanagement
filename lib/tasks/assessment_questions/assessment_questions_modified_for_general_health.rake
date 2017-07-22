namespace :assessment_questions_modified_for_general_health do
	desc "Assessment questions modified for general health"
	task :assessment_questions_modified_for_general_health => :environment do


		 #deleting 1) Is there anything about your health that presents a challenge to you to work?  2)Do you have any serious medical conditions?  questions
		connection = ActiveRecord::Base.connection()
		connection.execute("DELETE from assessment_question_multi_responses where assessment_question_id in(67, 70) and id in (383,384,396,397)")
		connection.execute("DELETE from assessment_question_metadata where assessment_question_id  in(67, 70) and id in (204,210) ")
		connection.execute("DELETE from assessment_questions where  assessment_sub_section_id in (29,30) and id in( 67,70)")
         #updating title
         AssessmentQuestion.where("assessment_sub_section_id = 29 and id = 66").update_all(title: " Is there anything about your health that presents a challenge to you to work? or Do you have any serious medical conditions?")
         AssessmentQuestion.where("assessment_sub_section_id = 29 and id = 68").update_all(title: " Are you current with your vaccinations?")
         # updating sub_section_type
         AssessmentQuestion.where("assessment_sub_section_id = 30 and id = 71").update_all(assessment_sub_section_id: 29 , display_order: 3  )

  end
end
