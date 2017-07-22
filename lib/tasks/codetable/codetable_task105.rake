namespace :populate_codetable105 do
	desc "Client Assessment Status"
	task :client_assessment_status  => :environment do
		code_table = CodeTable.create(name:"Client Assessment Status",description:"Client Assessment Status")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Complete",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Incomplete",long_description:"",system_defined:"FALSE",active:"TRUE")

	end
end