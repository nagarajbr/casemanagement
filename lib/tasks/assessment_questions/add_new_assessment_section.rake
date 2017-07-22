namespace :assessment_section_for_testing_service do
	desc "Assessment Sections for testing service"
	task :assessment_section_for_testing_service => :environment do

		AssessmentSection.create(title:"Testing Service",description:"TABE scores for the customer",display_order: 15,enabled:1,created_by: 1,updated_by: 1)

    end
end