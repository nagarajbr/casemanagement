namespace :assessment_questions_sort_order_fix1 do

	desc "Assessment question sort order fix 1"
	task :assessment_questions_sort_order_fix1 => :environment do
		AssessmentQuestion.where("id = 830 and assessment_sub_section_id = 32").update_all("display_order = 68")
	end
end