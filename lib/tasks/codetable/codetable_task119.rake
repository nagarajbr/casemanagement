namespace :populate_codetable119 do
	desc "additional sanction value"
	task :add_ipv_characteristics => :environment do
		CodetableItem.create(code_table_id:112,short_description:"Fraud - IPV Conviction2",long_description:" ",type:"OtherCharacteristic",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:112,short_description:"Fraud - IPV Conviction3",long_description:" ",type:"OtherCharacteristic",system_defined:"FALSE",active:"TRUE")
    end
end