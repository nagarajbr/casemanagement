namespace :populate_sys_param71 do
	desc "sanction task time limit"
	task :sanction_task_time_limit => :environment do
		 SystemParam.create(system_param_categories_id:18,key:"2168",value:"7",description:"Task - To work on sanction task - Days to complete = 7",created_by: 1,updated_by: 1)
	end
end