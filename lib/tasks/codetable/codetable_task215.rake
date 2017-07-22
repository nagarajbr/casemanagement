namespace :populate_codetable215 do
	desc "adding alien information reasons"
	task :adding_alien_information_reasons => :environment do
		CodetableItem.create(code_table_id:194,short_description:"Citizenship Information Changed",long_description:"Citizenship Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Non citizenship Information Changed",long_description:"Non citizenship Information Changed",system_defined:"TRUE",active:"TRUE")
	end
end