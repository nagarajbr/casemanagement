namespace :populate_codetable322 do
	desc "Data Validation Items"
	task :add_error_messages => :environment do
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Physical Address verification",long_description:"Physical Address verification",system_defined:"FALSE",active:"TRUE")
	end
end