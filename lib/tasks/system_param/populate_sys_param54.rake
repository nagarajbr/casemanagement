namespace :populate_sys_param54 do
	desc "Mapping of Work Type to Number of days to complete the task - To work on Rejected Provider Agreement"
	task :work_type_task_days_to_work_on_rejected_provider_agreement => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6459",value:"7",description:"Task - To work on Rejected Provider Agreement - Days to complete = 7",created_by: 1,updated_by: 1)
	end
end
