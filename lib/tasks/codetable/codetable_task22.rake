namespace :populate_codetable22 do
	desc "Application Status"
	task :application_form_status => :environment do
		code_tables = CodeTable.create(name:"Application Form Status",description:"TANF Application Form Status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Complete",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"InComplete",long_description:" ",system_defined:"FALSE",active:"TRUE")
	end
end