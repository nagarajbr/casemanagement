namespace :populate_codetable199 do
	desc "printed -added for the batch notes status "
	task :batch_notes_status_printed_added  => :environment do

		codetableitems = CodetableItem.create(code_table_id:157,short_description:"Printed",long_description:"Printed",system_defined:"FALSE",active:"TRUE")


	end
end