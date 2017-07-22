namespace :populate_codetable181 do
	desc "Add Event List7 "
	task :add_event7 => :environment do
		CodetableItem.create(code_table_id:191,short_description:"Request for Approval of Program Unit",long_description:"Request for Approval of Program Unit",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:191,short_description:"Request to Approve Program Unit is Approved",long_description:"Request to Approve Program Unit is Approved",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:191,short_description:"Request to Approve Program Unit is Rejected",long_description:"Request to Approve Program Unit is Rejected",system_defined:"TRUE",active:"TRUE")

	end
end