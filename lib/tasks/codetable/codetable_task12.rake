namespace :populate_codetable12 do
	desc "rule_type"
	task :rule_type => :environment do
		code_tables = CodeTable.create(name:"Rules Engine Categories",description:"Rules Engine Categories")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Application Screening",long_description:"Application Screening",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Case Eligibility",long_description:"Case Eligibility",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Budget Calculation",long_description:"Budget Calculation",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Data Verification",long_description:"Data Verification",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Resource Calculation",long_description:"Resource Calculation",system_defined:"FALSE",active:"TRUE")
		code_tables = CodeTable.create(name:"Rule Types",description:"Rule Type")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Person",long_description:"Person ",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Budget unit",long_description:"Budget unit",system_defined:"TRUE",active:"TRUE")

		code_tables = CodeTable.create(name:"Rule Criteria",description:"Rule Criteria")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Age Rule",long_description:"Age Rule",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Barrier Rule",long_description:"Barrier Rule",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Characteristic Rule",long_description:"Characteristic Rule",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Date vs. Date Rule",long_description:"Date vs. Date Rule",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Sum vs. Amount Rule",long_description:"Sum vs. Amount Rule",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Sum vs. Standard Rule",long_description:"Sum vs. Standard Rule",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Sum vs. Sum Rule",long_description:"Sum vs. Sum Rule",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Utility Template",long_description:"Utility Template",system_defined:"TRUE",active:"TRUE")

		code_tables = CodeTable.create(name:"Comparsion Operators",description:"Comparsion Operators")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Greater Than",long_description:"Greater Than",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Less Than",long_description:"Less Than",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Equal To",long_description:"Equal To",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Greater Than or Equal to",long_description:"Greater Than or Equal to",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Less Than or Equal to",long_description:"Less Than or Equal to",system_defined:"TRUE",active:"TRUE")
end
end