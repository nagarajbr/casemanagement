namespace :populate_codetable86 do
	desc "sanction_indicator"
	task :update_sanction_indicator_table => :environment do

		codetableitems = CodetableItem.create(code_table_id:149,short_description:"No Sanction",long_description:"No sanction",system_defined:"FALSE",active:"TRUE")

	end
end