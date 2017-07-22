namespace :populate_codetable169 do
	desc "Add Event List3 "
	task :add_event3 => :environment do
		CodetableItem.create(code_table_id:191,short_description:"Request for Approval of Provider Agreement",long_description:"Request for Approval of Provider Agreement",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:191,short_description:"Request to Approve Provider Agreement is Approved",long_description:"Request to Approve Provider Agreement is Approved",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:191,short_description:"Request to Approve Provider Agreement is Rejected",long_description:"Request to Approve Provider Agreement is Rejected",system_defined:"TRUE",active:"TRUE")

	end
end