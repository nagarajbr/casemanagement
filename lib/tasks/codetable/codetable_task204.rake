namespace :populate_codetable204 do
	desc "adding resource related ed reasons"
	task :adding_resource_related_ed_reasons => :environment do
		CodetableItem.create(code_table_id:194,short_description:"Resource Information Changed",long_description:"Resource Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Resource Detail Information Changed",long_description:"Resource Detail Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Resource Adjustment Information Changed",long_description:"Resource Adjustment Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Resource Use Information Changed",long_description:"Resource Use Information Changed",system_defined:"TRUE",active:"TRUE")
	end
end