namespace :populate_codetable161 do
	desc "additional work task types "
	task :additional_work_task_type_assign_ed_worker => :environment do

		CodetableItem.create(code_table_id:18,short_description:"Assign Eligibility Worker to Program Unit",long_description:"Assign Eligibility Worker to Program Unit",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:18,short_description:"Complete Work Readiness Assessment and CPP",long_description:"Complete Work Readiness Assessment and CPP",system_defined:"FALSE",active:"TRUE")
		CodetableItem.where("id = 6346 and code_table_id = 18").update_all("short_description = 'Complete program unit and determine eligibility',long_description = 'Complete program unit and determine eligibility'")

	end
end