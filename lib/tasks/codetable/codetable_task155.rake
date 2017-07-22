namespace :populate_codetable155 do
	desc "Requested Disposition status for PGU "
	task :requested_pgu_status => :environment do

		CodetableItem.create(code_table_id:132,short_description:"Requested",long_description:"Requested",system_defined:"FALSE",active:"TRUE")

	end
end