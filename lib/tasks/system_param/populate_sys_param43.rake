namespace :populate_sys_param43 do
	desc "Mapping of Work Type to Number of days to complete the task - Approve Program Unit"
	task :work_type_task_days_to_complete_approve_pgu_task => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"2172",value:"7",description:"Task -Approve Program Unit- Days to complete = 7",created_by: 1,updated_by: 1)
	end
end