namespace :populate_address_for_master_education do
	desc "Populate Address and Schools Entity Address"
	task :populate_address_for_master_education => :environment do
		connection = ActiveRecord::Base.connection()

		Rake::Task["populate_school_address:populate_schools_address"].invoke
		Rake::Task["populate_school_entity_address:populate_schools_entity_address"].invoke

		connection.execute("update addresses
			                set in_care_of = null,
			                    address_notes = null
			                where address_line1 in (select school_name from schools)
			               ")

	end
end