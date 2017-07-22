namespace :populate_codetable238 do
	desc "notice generation status "
	task :notice_generation_status => :environment do
		code_table = CodeTable.create(name:"Notice Generation Status",description:"Notice Generation Status")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Printed",long_description:"Printed",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Pending",long_description:"Pending",system_defined:"FALSE",active:"TRUE")
		CodetableItem.where("id = 6540").update_all("short_description = 'Ready for AASIS',long_description = 'Ready for AASIS'") # printed to ready for AASIS

	end
end