namespace :populate_sys_param70 do
	desc "FMS review time limit"
	task :fms_review_time_limit => :environment do
		 SystemParam.create(system_param_categories_id:18,key:"6641",value:"7",description:"FMS AASIS verification",created_by: "1",updated_by: "1")
	end
end