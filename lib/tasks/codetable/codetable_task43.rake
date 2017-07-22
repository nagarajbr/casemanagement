namespace :populate_codetable43 do
	desc "adding_payment_types"
	task :adding_payment_types => :environment do

		CodetableItem.create(code_table_id: 116,short_description:"Diversion",long_description:"Diversion",system_defined:"FALSE",active:"TRUE")
	end
end