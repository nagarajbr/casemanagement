
namespace :populate_codetable90 do
	desc "Work Task Category "
	task :work_task_category => :environment do
		code_tables = CodeTable.create(name:"Work Task Category",description:"Work Task Category")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA",long_description:"TEA",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Work pays",long_description:"Work pays",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Diversion",long_description:"TEA Diversion",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Supportive Services",long_description:"Supportive Services",system_defined:"FALSE",active:"TRUE")
	end
end