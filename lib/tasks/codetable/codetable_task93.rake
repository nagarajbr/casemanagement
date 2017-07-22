
namespace :populate_codetable93 do
	desc "Program Unit Representative Status"
	task :program_unit_rep_status => :environment do
		code_tables = CodeTable.create(name:"Program Unit Representative Status",description:"Program Unit Representative Status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Active",long_description:"Active",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Inactive",long_description:"Inactive",system_defined:"FALSE",active:"TRUE")
    end
end