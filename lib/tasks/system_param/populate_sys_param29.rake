namespace :populate_sys_param29 do
	desc "Mapping of Benefit Reducing Sanction to % reduction "
	task :sanction_to_reduction_mapping => :environment do
		systemParamCategories = SystemParamCategory.create(description:"Mapping of Sanction Type to Sanction Implication",created_by: 1,updated_by: 1)
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"3062",value:"6111",description:"OCSE Non-Compliance(3062) will show 25% benefit reduction(6111)",created_by: 1,updated_by: 1)

		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"3064",value:"6113",description:"Work Activity Non-compliance(3064) will show 50% benefit reduction(6113)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"3081",value:"6111",description:"Immunizations(3081) will show 25% benefit reduction(6111)",created_by: 1,updated_by: 1)

		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"6225",value:"6111",description:"Class Attendance-Minor Parent(6225) will show 25% benefit reduction(6111)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"6225",value:"6113",description:"Class Attendance-Minor Parent(6225) will show 50% benefit reduction(6113)",created_by: 1,updated_by: 1)
	end
end