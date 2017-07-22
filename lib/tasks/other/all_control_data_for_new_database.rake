namespace :all_control_data_creation do
	desc "Creating user roles for the application"
	task :all_control_data_creation => :environment do
		Rake::Task["create_batch_user:create_batch_user"].invoke

		Rake::Task["create_provider_batch_user:create_provider_batch_user"].invoke

		Rake::Task["one_time_data_creation:data_create"].invoke
		# ongoing_control_data_seed.rb
		Rake::Task["ongoing_control_data_creation:ongoing_control_data"].invoke
	end
end