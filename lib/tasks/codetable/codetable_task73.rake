namespace :populate_codetable73 do
	desc "To populate days of the week"
	task :days_of_week => :environment do
		code_tables = CodeTable.create(name:"days of week",description:"days of week")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Sunday",long_description:"Sunday",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Monday",long_description:"Monday",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Tuesday",long_description:"Tuesday",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Wednesday",long_description:"Wednesday",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Thursday",long_description:"Thursday",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Friday",long_description:"Friday",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Saturday",long_description:"Saturday",system_defined:"FALSE",active:"TRUE")
end
end