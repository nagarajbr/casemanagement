
namespace :populate_codetable83 do
	desc "Beneficiary type "
	task :beneficiary_type => :environment do
		code_tables = CodeTable.create(name:"Beneficiary",description:"Beneficiary Type")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Participant",long_description:"Participant",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Provider",long_description:"Provider",system_defined:"FALSE",active:"TRUE")
	end
end
