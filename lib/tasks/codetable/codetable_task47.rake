namespace :populate_codetable47 do
	# Manoj 10/17/2014
	# Prescreen questions categorised by Employment,Housing_utilities,Disability,Veteran_status
	desc "DWS Service Program Categories"
	task :service_program_categories => :environment do
		code_tables = CodeTable.create(name:"DWS Service Program Categories",description:"DWS Service Program Categories")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"TANF",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"WIA",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"UI",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"CRC",long_description:"",system_defined:"FALSE",active:"TRUE")

	end

end