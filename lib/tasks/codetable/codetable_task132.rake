namespace :populate_codetable132 do
	desc "additional sanction types"
	task :add_update_sanction_types => :environment do
		CodetableItem.create(code_table_id:56,short_description:"Refusal to sign PRA by minor parent",long_description:"Refusal to sign PRA by minor parent",type:"OtherCharacteristic",system_defined:"FALSE",active:"TRUE")


    end
end