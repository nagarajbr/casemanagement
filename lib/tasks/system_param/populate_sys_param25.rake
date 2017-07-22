namespace :populate_sys_param25 do
	desc "Sanctions List that Reduce Benefit"
	task :benefit_reducing_sanctions => :environment do



		SystemParam.create(system_param_categories_id: 9,key:"BENEFIT_REDUCING_SANCTIONS",value:"3070",description:"Sanction-EP non-compliance will reduce benefits",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"BENEFIT_REDUCING_SANCTIONS",value:"3073",description:"Sanction-E&T non-compliance will reduce benefits",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"BENEFIT_REDUCING_SANCTIONS",value:"3081",description:"Sanction-Immunization will reduce benefits",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"BENEFIT_REDUCING_SANCTIONS",value:"6225",description:"Class Attendance-Minor Parent sanction",created_by: 1,updated_by: 1)



		SystemParam.create(system_param_categories_id: 9,key:"BENEFIT_REDUCING_SANCTIONS",value:"3062",description:"Sanction-OCSE Non-compliance will reduce benefits",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"BENEFIT_REDUCING_SANCTIONS",value:"3068",description:"Sanction-Quit employment will reduce benefits",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"BENEFIT_REDUCING_SANCTIONS",value:"3067",description:"Sanction-Refused employment will reduce benefits",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"BENEFIT_REDUCING_SANCTIONS",value:"3064",description:"Sanction-Work activity non-compliance will reduce benefits",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"BENEFIT_REDUCING_SANCTIONS",value:"3085",description:"Sanction-Workfare non-compliance will reduce benefits",created_by: 1,updated_by: 1)


	end
end