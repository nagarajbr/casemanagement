namespace :populate_sys_param26 do
	desc "TEA Bonus Closure Reasons"
	task :tea_bonus_closure_reasons => :environment do

		SystemParam.create(system_param_categories_id: 9,key:"TEA_BONUS_CLOSE_REASONS",value:"4235",description:"Extended Employment Not extended",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_BONUS_CLOSE_REASONS",value:"4229",description:"Extension Employed Ineligible",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_BONUS_CLOSE_REASONS",value:"4236",description:"Req Close Extended Employ",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_BONUS_CLOSE_REASONS",value:"4237",description:"TEA 60 mo no ext employed",created_by: 1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"TEA_BONUS_CLOSE_REASONS",value:"4300",description:"TEA Close Employed at End Extension",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_BONUS_CLOSE_REASONS",value:"4297",description:"TEA Close Employed 24 Mo",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_BONUS_CLOSE_REASONS",value:"4298",description:"TEA Close Extend Found Employment",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_BONUS_CLOSE_REASONS",value:"4299",description:"TEA Close Ineligible During Ext",created_by: 1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"TEA_BONUS_CLOSE_REASONS",value:"4301",description:"TEA Close Not Employed or Extension",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_BONUS_CLOSE_REASONS",value:"4296",description:"TEA Extra Payment-Earning",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"TEA_BONUS_CLOSE_REASONS",value:"4303",description:"TEA Extra Payments-Request",created_by: 1,updated_by: 1)



	end
end