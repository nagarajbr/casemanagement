namespace :populate_codetable330 do
	desc "work task is split it two code_table values"
	task :update_code_table_description => :environment do
		CodeTable.where("id = 18").update_all("name ='Work Task Types for arwins',description = 'Work Order Types for arwins'")
		CodeTable.where("id = 212").update_all("name ='Work Task Types for providers',description = 'Work Order Types for providers'")

	end
end