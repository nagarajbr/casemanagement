namespace :update_assessment_questions_for_transportation do
	desc "updating Assessment Questions for transportation "
	task :update_assessment_questions_for_transportation => :environment do

       AssessmentQuestion.where("assessment_sub_section_id = 43").update_all(assessment_sub_section_id: 41, display_order: 11)
        AssessmentQuestion.where("id = 63").update_all(display_order: 12)


   end
end