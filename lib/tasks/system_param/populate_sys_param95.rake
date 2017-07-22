namespace :populate_sys_param95 do
	desc "Mapping of Work Type to Number of days to complete the task - Program Unit identification"
	task :days_to_complete_task_program_unit_identification => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
		SystemParam.create(system_param_categories_id:18,key:"2155",value:"7",description:"Task to complete Program Unit identification- Days to complete = 7",created_by: 1,updated_by: 1)
	end
end