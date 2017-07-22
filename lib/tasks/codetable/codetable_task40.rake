namespace :populate_codetable40 do
	desc "Add notes types"
	task :client_notes_types => :environment do
		codetableitems = CodetableItem.create(code_table_id: 131,short_description:"Immunization notes",long_description:"Immunization notes",system_defined:"FALSE",active:"TRUE")
	end
end