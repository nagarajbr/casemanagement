namespace :populate_codetable269 do
	desc "add night batch reasons"
	task :add_night_batch_reasons => :environment do
		CodetableItem.create(code_table_id:194,short_description:"AASIS verification new",long_description:"AASIS verification new",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"AASIS verification changed",long_description:"AASIS verification changed",system_defined:"FALSE",active:"TRUE")
    end
end