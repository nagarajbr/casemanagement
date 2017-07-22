namespace :populate_sys_param41 do
	desc "Mapping of Work Type to Number of days to complete the task - client information change"
	task :work_type_task_days_to_complete_information_change_task => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"2142",value:"7",description:"Task -ED Data Changed- Days to complete = 7",created_by: 1,updated_by: 1)
	end
end