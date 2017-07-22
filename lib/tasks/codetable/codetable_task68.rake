namespace :populate_codetable68 do
	desc "Data Validation Items"
	task :add_application_eligibilty_items => :environment do
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Client is already open in a TEA program",long_description:"Client is open in a TEA program",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Client has received TEA Diversion payment within 100 days",long_description:"Client is receiving TEA Diversion payments",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Client is already open in a Work Pays program",long_description:"Client is already open in a Work Pays program",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Client does not have a closed TEA case within last six months",long_description:"Client does not have a closed tea case within last six months",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"No client within the program has received a minimum of three life time TEA payments",long_description:"Client has not received a minimum of three TEA payments",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Work Pays State Time Limits have been met",long_description:"Client has reached maximum Work Pays state time limits",system_defined:"FALSE",active:"TRUE")
		#codetableitems = CodetableItem.create(code_table_id:130,short_description:"Client is already open in another TANF program",long_description:"Client is already open in another TANF program",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Client was eligible in another TANF program",long_description:"Client was eleigible in another TANF program",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Client has already received a one life time TEA Diversion payment",long_description:"Client has already received a one life time TEA Diversion payment",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Child not included in eligibility determination",long_description:"Child not included in eligibility determination",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Income rule failed",long_description:"Income rule failed",system_defined:"FALSE",active:"TRUE")
	end
end