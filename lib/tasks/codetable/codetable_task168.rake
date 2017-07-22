namespace :populate_codetable168 do
	desc "Add Event List2 "
	task :add_event2 => :environment do
		CodetableItem.create(code_table_id:191,short_description:"Program Unit Creation",long_description:"Program Unit Creation",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:191,short_description:"Eligible for Planning",long_description:"Program unit is eligible so assign case manager to do assessment and planning",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:191,short_description:"Request to Approve Program Unit",long_description:"Request to Approve Program Unit",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:191,short_description:"Reject Request for Approval of Program Unit",long_description:"Reject Request for Approval of Program Unit",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:191,short_description:"Activating Program Units",long_description:"Activating Program Units",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:191,short_description:"Deny Program Unit",long_description:"Deny Program Unit",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:191,short_description:"Assigning ED worker to Program Unit",long_description:"Assigning ED worker to Program Unit",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:191,short_description:"Assigning Case Manager to Program Unit",long_description:"Assigning Case Manager to Program Unit",system_defined:"TRUE",active:"TRUE")








	end
end

