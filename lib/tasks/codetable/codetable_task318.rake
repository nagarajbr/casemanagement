namespace :populate_codetable318 do
	desc "adding new program unit disposition status"
	task :adding_new_program_unit_disposition_status => :environment do
		CodetableItem.create(code_table_id:132,short_description:"Processed",long_description:"Processed",system_defined:"TRUE",active:"TRUE")
	end
end