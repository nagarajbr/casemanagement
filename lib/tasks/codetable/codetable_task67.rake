namespace :populate_codetable67 do
	desc "Payment types"
	task :add_payment_type_items => :environment do
		codetableitems = CodetableItem.create(code_table_id:116,short_description:"Relocation payment",long_description:"Relocation payment",system_defined:"FALSE",active:"TRUE")
	end
end