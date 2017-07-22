namespace :populate_codetable229 do
	desc "adding legal characterics and sanction related ed reasons"
	task :adding_provider_payment_line_item_reject_work_order_type => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Reject Provider Payment",long_description:"Reject Provider Payment",system_defined:"TRUE",active:"TRUE")
	end
end