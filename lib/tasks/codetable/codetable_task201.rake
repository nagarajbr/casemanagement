namespace :populate_codetable201 do
	desc "adding income related ed reasons"
	task :adding_income_related_ed_reasons => :environment do
		CodetableItem.create(code_table_id:194,short_description:"Income Information Changed",long_description:"Income Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Income Detail Information Changed",long_description:"Income Detail Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Income Adjustment Information Changed",long_description:"Income Adjustment Information Changed",system_defined:"TRUE",active:"TRUE")
	end
end