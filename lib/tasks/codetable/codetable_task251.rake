namespace :populate_codetable251 do
	desc "adding_alert_type Request to Approve First Time Benefit amount"
	task :alert_type_request_to_approve_first_time_benefit_amount => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Request to Approve First Time benefit amount",long_description:"Request to Approve First Time benefit amount",system_defined:"TRUE",active:"TRUE")
		
	end
end