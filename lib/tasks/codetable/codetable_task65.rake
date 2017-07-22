namespace :populate_codetable65 do
	desc "sanction_indicator"
	task :creating_sanction_indicator_table => :environment do

		code_tables = CodeTable.create(name:"sanction indicator",description:"sanction indicator")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Suspend 1",long_description:"Suspend 1",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"25%",long_description:"25%",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Suspend 2",long_description:"Suspend 2",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"50%",long_description:"50%",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Close",long_description:"Close",system_defined:"FALSE",active:"TRUE")
	end
end