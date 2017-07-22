namespace :populate_codetable124 do
	desc "error messages - mandatory work participation for workpays"
	task :add_error_message_wp => :environment do
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Mandatory Work Participation requirement",long_description:"",system_defined:"FALSE",active:"TRUE")
	end
end