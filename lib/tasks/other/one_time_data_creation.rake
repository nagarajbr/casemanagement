namespace :one_time_data_creation do
	desc "Creating user roles for the application"
	task :data_create => :environment do

		# *************************TABLES START*******************************
		# 1. service_programs
		# 2. local_office_informations

		# ED control tables -start
		# 3. program_standards
	    # 4. program_standard_details
	    # 5. program_unit_size_standards
	    # 6. program_unit_size_standard_details
	    # 7. rules
	    # 8. rule_details
	    # 9. screening_engines
	    # ED control tables -end

	    # 10.expected_work_participation_hours
	    # 11. schools
	    # 12. addresses
	    # 13. entity_addresses
	    # 14. cost_centers

		# *************************TABLES END*******************************
		# service programs tea/work pays etc
		Rake::Task["populate_service_programs:TANF_service_programs"].invoke
		# static data - office location information & their address etc
		Rake::Task["dws_local_office_address_creation_task:local_office_address_insert_task"].invoke
		# ed control data -start
		Rake::Task["populate_control_data:system_control_data"].invoke
		# ed control data -end
		# static data
		# Rake::Task["expected_work_participation_hours_task:populate_expected_work_participation_hours"].invoke
		# school start
		Rake::Task["populate_school_names_task:populate_schools"].invoke
		Rake::Task["populate_address_for_master_education:populate_address_for_master_education"].invoke
		# school end
		# Rake::Task["cost_center_information:create_cost_center_information"].invoke
	end
end