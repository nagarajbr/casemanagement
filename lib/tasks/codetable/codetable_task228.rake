namespace :populate_codetable228 do
	desc "adding legal characterics and sanction related ed reasons"
	task :adding_provider_agreement_reject_work_order_type => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Reject Provider Agreement",long_description:"Reject Provider Agreement",system_defined:"TRUE",active:"TRUE")
	end
end