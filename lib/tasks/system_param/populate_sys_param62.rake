namespace :populate_sys_param62 do
	desc "Mapping of Work Type to Number of days to complete the task - complete application screening"
	task :populate_sys_param62 => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6593",value:"2",description:"Task -complete application screening- Days to complete = 2",created_by: 1,updated_by: 1)
	end
end