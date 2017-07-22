namespace :populate_sys_param57 do
	desc "added mapping of Benefit Reducing Sanction "
	task :sanction_to_reduction => :environment do

		# Worktype to days key value pairs
		# 3064-"Work Activity Non-compliance",
		# 3070-"EP Non-Compliance",
		# 3073-"E&T Non-Compliance",
		# 3068-"Quit Employment",
		# 3067-"Refused Employment",
		# 3085-"Workfare Non-compliance", #6114 -close
		SystemParam.create(system_param_categories_id:19,key:"3070",value:"6114",description:"EP Non-Compliance(3070) will be closed(6114)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:19,key:"3073",value:"6114",description:"E&T Non-Compliance(3073) will be closed(6114)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:19,key:"3068",value:"6114",description:"Quit Employment(3068) will be closed(6114)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:19,key:"3067",value:"6114",description:"Refused Employment(3067) will be closed(6114)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:19,key:"3085",value:"6114",description:"Workfare Non-compliance(3085) will be closed(6114)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:19,key:"3064",value:"6114",description:"Work Activity Non-compliance(3064) will be closed(6114)",created_by: 1,updated_by: 1)
	end
end