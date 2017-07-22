namespace :populate_codetable172 do
	desc "Add Event List4 "
	task :add_event4 => :environment do
		CodetableItem.create(code_table_id:191,short_description:"Request for Approval of career plan",long_description:"Request for Approval of career plan",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:191,short_description:"Request to Approve career plan is Approved",long_description:"Request to Approve career plan is Approved",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:191,short_description:"Request to Approve career plan is Rejected",long_description:"Request to Approve career plan is Rejected",system_defined:"TRUE",active:"TRUE")

	end
end