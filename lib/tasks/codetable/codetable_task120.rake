namespace :populate_codetable120 do
	desc "Data Validation Items - caretaker"
	task :add_error_message_care_taker => :environment do
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"This Client is active in another Open Program Unit,So you cannot become Caretaker.",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"This Client is caretaker in another Open Program Unit,So you cannot become active member.",long_description:"",system_defined:"FALSE",active:"TRUE")
	end
end