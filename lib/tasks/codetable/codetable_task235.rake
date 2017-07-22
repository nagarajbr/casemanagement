namespace :populate_codetable235 do
	desc "adding task type for First Time Program Unit Reject"
	task :adding_task_type_for_program_unit_reject => :environment do
		CodetableItem.create(code_table_id:18,short_description:"First Time Program Unit Reject",long_description:"First Time Program Unit Reject",system_defined:"TRUE",active:"TRUE")
	end
end