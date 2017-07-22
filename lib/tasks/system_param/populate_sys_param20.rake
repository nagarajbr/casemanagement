namespace :populate_sys_param20 do
	desc "WORK PAYS Bonus Amount"
	task :workpays_bonus_amount => :environment do
		systemParamCategories = SystemParamCategory.create(description:"WORK PAYS Bonus Amount",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"WORK PAYS First Bonus Amount",value:"400.00",description:"WORK PAYS First Bonus Amount",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"WORK PAYS Second Bonus Amount",value:"600.00",description:"WORK PAYS Second Bonus Amount",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"WORK PAYS Third Bonus Amount",value:"800.00",description:"WORK PAYS Third Bonus Amount",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"WORK PAYS EXIT Bonus Amount",value:"1200.00",description:"WORK PAYS EXIT Bonus Amount",created_by: 1,updated_by: 1)

	end
end