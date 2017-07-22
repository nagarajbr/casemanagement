namespace :populate_codetable308 do
	desc "updating task type to identify program units"
	task :updating_task_type_to_identify_program_units => :environment do
		CodetableItem.where("code_table_id = 18 and id = 2155").update_all(short_description:"Identify Program Units", long_description: "Identify Program Units")
	end
end