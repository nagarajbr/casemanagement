namespace :populate_codetable210 do
	desc "adding program unit disposition status"
	task :adding_program_unit_disposition_status => :environment do
		CodetableItem.create(code_table_id:132,short_description:"Closed",long_description:"Closed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:132,short_description:"Changed",long_description:"Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:132,short_description:"Other",long_description:"Other",system_defined:"TRUE",active:"TRUE")
	end
end