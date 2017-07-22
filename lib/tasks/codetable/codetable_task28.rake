namespace :populate_codetable28 do
	desc "Document Verfication List"
	task :document_verfication_list => :environment do
		code_tables = CodeTable.create(name:"Client Document Verfication List",description:"Client Document Verfication List")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Good Cause",long_description:"Good Cause",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Immunization",long_description:"Immunization",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Education",long_description:"Education",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Child Support",long_description:"Child Support",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Personal Responsibility Agreement",long_description:"Personal Responsibility Agreement",system_defined:"FALSE",active:"TRUE")
	end
end