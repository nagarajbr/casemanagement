namespace :populate_codetable180 do
	desc "Add Event List6 "
	task :add_event6 => :environment do
		CodetableItem.create(code_table_id:191,short_description:"Request for Approval of Provider Invoice",long_description:"Request for Approval of Provider Invoice",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:191,short_description:"Request to Approve Provider Invoice is Approved",long_description:"Request to Approve Provider Invoice is Approved",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:191,short_description:"Request to Approve Provider Invoice is Rejected",long_description:"Request to Approve Provider Invoice is Rejected",system_defined:"TRUE",active:"TRUE")

	end
end