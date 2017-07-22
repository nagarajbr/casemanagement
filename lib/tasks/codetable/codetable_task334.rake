namespace :populate_codetable334 do
	desc "Provider classifications"
	task :provider_classifications  => :environment do
		code_table = CodeTable.create(name:"Provider classifications",description:"Provider classifications")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Regular Provider",long_description:"Regular Provider",system_defined:"FALSE",active:"TRUE", sort_order: 10)
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"E&T Provider",long_description:"E&T Provider",system_defined:"FALSE",active:"TRUE", sort_order: 20)
	end
end
