namespace :populate_sys_param24 do
	desc "TEA extension beyond 24 months deferrals reasons"
	task :tea_extension_deferral_reasons => :environment do

		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5686",description:"TEA Extnd 60 yrs or older",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5695",description:"TEA Extnd No Transportati",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5690",description:"TEA Extnd Child Care Unav",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5663",description:"Disabled Long-Term TL EXT",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5693",description:"TEA Extnd Extraord Circum",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5687",description:"TEA Extnd Cares for Ill",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5685",description:"TEA Extnd 3rd Trimstr Prg",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5697",description:"TEA Extnd Rehab Svcs",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5694",description:"TEA Extnd No Support Svcs",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5684",description:"TEA Extnd 2 Par no Fed CC",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5691",description:"TEA Extnd Domestic Violen",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5696",description:"TEA Extnd Par 2 reqd home",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5661",description:"Disabled 2nd Prnt TL Ext",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_EXTN_DEFERRALS",value:"5689",description:"TEA Extnd Ch<3mo or no CC",created_by: 1,updated_by: 1)

	end
end