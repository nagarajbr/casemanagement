namespace :populate_codetable48 do
	# Manoj 10/17/2014
	# Prescreen questions categorised by Employment,Housing_utilities,Disability,Veteran_status
	desc "Additional prescreen_questions"
	task :prescreen_questions2 => :environment do


		CodetableItem.create(code_table_id: 137,short_description:"Anybody in the house is currently working and wanting to upgrade?",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id: 137,short_description:"Anybody in the house want to explore Career Readiness Certification program and Microsoft IT Academy program?",long_description:"",system_defined:"FALSE",active:"TRUE")


	end

end