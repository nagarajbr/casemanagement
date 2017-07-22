namespace :populate_codetable300 do
	desc "Application types ARWINS and Providers"
	task :application_types  => :environment do
		code_table = CodeTable.create(name:"Application",description:"Application_types - ARWINS , Provider")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Arwins",long_description:"Arwins",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Provider",long_description:"Provider",system_defined:"FALSE",active:"TRUE")

	end
end