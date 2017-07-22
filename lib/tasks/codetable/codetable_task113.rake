namespace :populate_codetable113 do
	desc "Duration of action or service"
	task :duration => :environment do
		code_table = CodeTable.create(name:"Duration",description:"Duration of action or service")
		CodetableItem.create(code_table_id:code_table.id,short_description:"24 hours(1 Day)",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table.id,short_description:"72 hours(3 Day)",long_description:"",system_defined:"FALSE",active:"TRUE")

		CodetableItem.create(code_table_id:code_table.id,short_description:"1 Week",long_description:"",system_defined:"FALSE",active:"TRUE")

		CodetableItem.create(code_table_id:code_table.id,short_description:"1 Month",long_description:"",system_defined:"FALSE",active:"TRUE")

		CodetableItem.create(code_table_id:code_table.id,short_description:"3 Months",long_description:"",system_defined:"FALSE",active:"TRUE")

		 CodetableItem.create(code_table_id:code_table.id,short_description:"6 Months",long_description:"",system_defined:"FALSE",active:"TRUE")

		CodetableItem.create(code_table_id:code_table.id,short_description:"12 Months",long_description:"",system_defined:"FALSE",active:"TRUE")

		 CodetableItem.create(code_table_id:code_table.id,short_description:"18 Months",long_description:"",system_defined:"FALSE",active:"TRUE")

	end
end
