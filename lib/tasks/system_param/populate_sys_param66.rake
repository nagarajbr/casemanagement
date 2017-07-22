namespace :populate_sys_param66 do
	desc "notice generation reasons to policy numbers"
	task :notice_generation_reasons_to_policy_numbers => :environment do

    systemParamCategories = SystemParamCategory.create(description:"Mapping of reason to policy",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6544",value:"TEA-4120",description:"Income Adjustment Information Changed	",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6543",value:"TEA-4120",description:"Income Detail Information Changed	",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6542",value:"TEA-4120",description:"Income Information Changed",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6608",value:"TEA-4113",description:"Member dropped - death",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6584",value:"TEA-2210",description:"Living arrangement",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6546",value:"TEA-2210",description:"Turned 18",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6594",value:"TEA-8100",description:"Fraud - IPV",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6596",value:"TEA-2230",description:"Felony drug conviction",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6595",value:"TEA-2240",description:"Parole violator/Fleeing felon	",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6583",value:"TEA-2261",description:"No school attendance",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6534",value:"TEA-2510.1",description:"Family cap",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6577",value:"TEA-2220",description:"Non-citizenship",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6584",value:"TEA-2250",description:"Moved out of state",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6600",value:"TEA-3800, 3805",description:"Progressive Sanction",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6599",value:"TEA-2145",description:"OCSE",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6598",value:"TEA-2262",description:"Immunization",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6602",value:"TEA-3520",description:"Class attendance-minor parent",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: systemParamCategories.id,key:"6601",value:"TEA-2121",description:"Refusal to sign PRA by minor parent",created_by: 1,updated_by: 1)
	end
end
