namespace :populate_codetable234 do
	desc "adding work pays payment action type"
	task :adding_work_pays_payment_action_type => :environment do
		CodetableItem.create(code_table_id:192,short_description:"Work Pays Payment",long_description:"Work Pays Payment",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:193,short_description:"Work Pays Payment",long_description:"Work Pays Payment",system_defined:"TRUE",active:"TRUE")
	end
end