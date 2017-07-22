namespace :assessment_questions_modified_for_mental_health do
	desc "Assessment questions modified for mental health"
	task :assessment_questions_modified_for_mental_health => :environment do


		 #deleting "2. Have you ever been diagnosed or treated for a mental health condition, such as depression or ADD?" questions
		connection = ActiveRecord::Base.connection()
		connection.execute("DELETE from assessment_question_multi_responses where assessment_question_id =704 and id in(400,401)")
		connection.execute("DELETE from assessment_question_metadata where assessment_question_id =704 and id = 214 ")
		connection.execute("DELETE from assessment_questions where  assessment_sub_section_id = 35 and id = 704 ")
         #Combine questions 1 and 2
         AssessmentQuestion.where("assessment_sub_section_id = 35 and id = 173").update_all(title: "1. Have you ever felt like you have had or diagnosed or treated for a mental health condition, such as depression or ADD?")


  end
end
