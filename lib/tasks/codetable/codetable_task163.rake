namespace :populate_codetable163 do
	desc "additional work task types "
	task :additional_work_task_type_work_on_supervisor_rejected_pgu => :environment do

		CodetableItem.create(code_table_id:18,short_description:"Work on First Time benefit Rejected program unit",long_description:"Work on First Time benefit Rejected program unit",system_defined:"FALSE",active:"TRUE")


	end
end