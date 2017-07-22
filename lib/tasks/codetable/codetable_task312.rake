namespace :populate_codetable312 do
	desc "Data Validation Items"
	task :add_error_messages => :environment do
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Household Registration",long_description:"Household Registration",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Date of Birth",long_description:"Date of Birth",system_defined:"FALSE",active:"TRUE")
		# codetableitems = CodetableItem.create(code_table_id:130,short_description:"Residence Address",long_description:"Residence Address",system_defined:"FALSE",active:"TRUE")
		# codetableitems = CodetableItem.create(code_table_id:130,short_description:"Earned Income step processed",long_description:"Earned Income step processed",system_defined:"FALSE",active:"TRUE")
		# codetableitems = CodetableItem.create(code_table_id:130,short_description:"Assessment step processed if adult",long_description:"Assessment step processed if adult",system_defined:"FALSE",active:"TRUE")
		# codetableitems = CodetableItem.create(code_table_id:130,short_description:"Unearned income step processed",long_description:"Unearned income step processed",system_defined:"FALSE",active:"TRUE")
		# codetableitems = CodetableItem.create(code_table_id:130,short_description:"Resource step processed",long_description:"Resource step processed",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Felon characteristic",long_description:"Felon characteristic if yes for felon",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Outs of state payments",long_description:"Outs of state payments if yes to out of state",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Race Information",long_description:"Race Information",system_defined:"FALSE",active:"TRUE")
		# codetableitems = CodetableItem.create(code_table_id:130,short_description:"All relationships exists",long_description:"All relationships exist within members",system_defined:"FALSE",active:"TRUE")
		# codetableitems = CodetableItem.create(code_table_id:130,short_description:"",long_description:"",system_defined:"FALSE",active:"TRUE")
	end
end