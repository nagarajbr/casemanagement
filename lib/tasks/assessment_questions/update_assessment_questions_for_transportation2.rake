namespace :update_assessment_questions_for_transportation2 do
	desc "update assessment questions for transportation2"
	task :update_assessment_questions_for_transportation2 => :environment do

         # updating sub_section_type from Child issues to childcare status
		AssessmentQuestion.find(805).update(title: "Is there anything about your transportation method that presents a challenge for you to work?")
    end
   end