namespace :ongoing_control_data_creation do
	desc "Creating user roles for the application"
	task :ongoing_control_data => :environment do


		# 1.
		Rake::Task["db:seed"].invoke
		# 2.
		# assessment questions seed
		Rake::Task["assessment_questions_population_dbseed:seed"].invoke

		# 3.
		# notice_text_seed.rake
		Rake::Task["notice_text_seed:notice_text_seed"].invoke

		# 4.
		# ruby_elements_seed.rb
		Rake::Task["ruby_elements_seed:ruby_elements_seed"].invoke

		# 5.
		Rake::Task["expected_work_participation_hours_task:populate_expected_work_participation_hours"].invoke

		# 6.
		Rake::Task["cost_center_information:create_cost_center_information"].invoke

		# 0.1
		User.where("id = 1").update_all(uid: 555,organisation_slug: 'Little Rock Workforce Center')
	end
end