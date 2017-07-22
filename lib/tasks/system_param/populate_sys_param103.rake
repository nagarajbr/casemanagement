namespace :populate_sys_param103 do
	desc "Sanctions List for progressive and non progressive "
	task :populate_progressive_non_prog_sanctions => :environment do
	user_object = User.find(1)
	AuditModule.set_current_user=(user_object)

	#PROGRESSIVE_SANCTIONS
	SystemParam.create(system_param_categories_id: 9,key:"PROGRESSIVE_SANCTIONS",value:"3064",description:"Sanction-Work Activity Non-compliance",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROGRESSIVE_SANCTIONS",value:"3067",description:"Sanction-Refused Employment",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROGRESSIVE_SANCTIONS",value:"3068",description:"Sanction-Quit Employment",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROGRESSIVE_SANCTIONS",value:"3070",description:"Sanction-EP Non-Compliance",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROGRESSIVE_SANCTIONS",value:"3073",description:"Sanction-E&T Non-Compliance",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROGRESSIVE_SANCTIONS",value:"3085",description:"Sanction-Workfare Non-compliance",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROGRESSIVE_SANCTIONS",value:"6225",description:"Sanction-Class Attendance-Minor Parent",created_by: 1,updated_by: 1)
	#NON_PROGRESSIVE_SANCTION
	SystemParam.create(system_param_categories_id: 9,key:"NON_PROGRESSIVE_SANCTION",value:"3081",description:"Sanction-Immunizations",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"NON_PROGRESSIVE_SANCTION",value:"3062",description:"Sanction-OCSE Non-Compliance",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"NON_PROGRESSIVE_SANCTION",value:"6349",description:"Sanction-Refusal to sign PRA by minor parent",created_by: 1,updated_by: 1)

	end
end