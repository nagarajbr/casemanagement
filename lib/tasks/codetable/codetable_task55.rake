namespace :populate_codetable55 do
	desc "Data Validation Items"
	task :add_application_eligibilty_items => :environment do
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Living Arrangement requirement",long_description:"Living Arrangement requirement",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"State Residence  requirement",long_description:"State Residence requirement",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Citizenship or Eligible Alien  requirement",long_description:"Citizenship or Eligible Alien requirement",system_defined:"FALSE",active:"TRUE")
	end
end