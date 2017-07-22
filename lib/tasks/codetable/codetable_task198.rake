namespace :populate_codetable198 do
	desc "adding client characteristic information changed entry to work order types"
	task :adding_client_characteristic_changed_entry_to_work_order_types_and_ed_reasons => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Client Characteristics Information Changed",long_description:"Client Characteristics Information Changed",system_defined:"TRUE",active:"TRUE")
		code_table_object = CodeTable.create(name:"Eligibility Determination Reasons",description:"Eligibility Determination Reasons")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Living Arrangement",long_description:"Living Arrangement Check",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Work Participation Characteristic Changed",long_description:"Work Participation Characteristic Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Legal Characteristic Changed",long_description:"Legal Characteristic Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Other Characteristic Family Cap Information Changed",long_description:"Other Characteristic Family Cap Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Immunization Information Changed",long_description:"Immunization Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Education Information Changed",long_description:"Education Information Changed for an active child",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Employment Information Changed",long_description:"Client is active adult in Work Pays Program Unit",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Out of State Payment Information Changed",long_description:"Added/Deleted Out of State Payments",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Sanction Detail Information Changed",long_description:"Added Santion Detail or sanction release indicator is set",system_defined:"TRUE",active:"TRUE")
	end
end