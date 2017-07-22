namespace :populate_sys_param1 do
	desc "Vaccinations"
	task :Vaccinations => :environment do
		systemParamCategories = SystemParamCategory.create(description:"Vaccinations",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"P1",value:"2",description:"Polio - 1st",created_by:1,updated_by:1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"D1",value:"2",description:"DTP - 1st",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"I1",value:"2",description:"Hemophilus Influenza Type B - 1st",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"H1",value:"3",description:"Hepatitis B - 1st",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"P2",value:"4",description:"Polio - 2nd",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"D2",value:"4",description:"DTP - 2nd",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"I2",value:"4",description:"Hemophilus Influenza Type B - 2nd",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"H2",value:"5",description:"Hepatitis B - 2nd",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"D3",value:"6",description:"DTP - 3rd",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"I3",value:"6",description:"Hemophilus Influenza Type B - 3rd",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"M1",value:"15",description:"MMR - 1st",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"P3",value:"18",description:"Polio - 3rd",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"D4",value:"18",description:"DTP - 4th",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"V1",value:"18",description:"Varicella Virus Vaccine",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"H3",value:"18",description:"Hepatitis B - 3rd",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"I4",value:"18",description:"Hemophilus Influenza Type B - 4th",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"P4",value:"72",description:"Polio - 4th",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"D5",value:"72",description:"DTP - 5th",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"M2",value:"72",description:"MMR - 2nd",created_by: 1,updated_by: 1)
	end
end