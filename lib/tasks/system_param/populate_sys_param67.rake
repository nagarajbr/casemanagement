namespace :populate_sys_param67 do
	desc "Mapping of Work Type to Number of days to complete the task - Work on Program Unit due to batch ED"
	task :work_type_task_days_to_work_on_program_unit_due_to_ed_batch => :environment do
		SystemParam.create(system_param_categories_id:18,key:"6635",value:"3",description:"Task - Work on Program Unit due to batch ED - Days to complete = 3",created_by: 1,updated_by: 1)
	end
end
