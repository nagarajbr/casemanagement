namespace :populate_codetable175 do
	desc "Add Service Payments Events"
	task :add_event5 => :environment do
		CodetableItem.create(code_table_id:191,short_description:"Request for Approval of Service Payment",long_description:"Request for Approval of Service Payment",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:191,short_description:"Request to Approve Service Payment is Approved",long_description:"Request to Approve Service Payment is Approved",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:191,short_description:"Request to Approve Service Payment is Rejected",long_description:"Request to Approve Service Payment is Rejected",system_defined:"TRUE",active:"TRUE")

	end
end