namespace :populate_sys_param31 do
	desc "added mapping of Benefit Reducing Sanction to % reduction "
	task :sanction_to_reduction_mapping3 => :environment do

		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:19,key:"3070",value:"6113",description:"EP Non-Compliance(3070) will show 50% benefit reduction(6113)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:19,key:"3073",value:"6113",description:"E&T Non-Compliance(3073) will show 50% benefit reduction(6113)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:19,key:"3068",value:"6113",description:"Quit Employment(3068) will show 50% benefit reduction(6113)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:19,key:"3067",value:"6113",description:"Refused Employment(3067) will show 50% benefit reduction(6113)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:19,key:"3085",value:"6113",description:"Workfare Non-compliance(3085) will show 50% benefit reduction(6113)",created_by: 1,updated_by: 1)
	end
end