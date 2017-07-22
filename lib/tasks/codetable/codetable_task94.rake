namespace :populate_codetable94 do
	desc "additional sanction value"
	task :additional_sanction_value => :environment do
		codetableitems = CodetableItem.create(code_table_id:56,short_description:"Living Arrangement - Minor Parent",long_description:"Living Arrangement - Minor Parent",system_defined:"FALSE",active:"TRUE")
    end
end