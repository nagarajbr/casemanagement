
namespace :populate_codetable91 do
	desc "Work Flow Status "
	task :work_flow_status => :environment do
		code_tables = CodeTable.create(name:"Work Flow Status",description:"Work Flow Status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Authorized",long_description:"Authorized",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Denied",long_description:"Denied",system_defined:"FALSE",active:"TRUE")
    end
end