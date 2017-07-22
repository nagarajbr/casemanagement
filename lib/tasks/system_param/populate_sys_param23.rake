namespace :populate_sys_param23 do
	desc "Transportation bonus amount"
	task :transportation_bonus_amount => :environment do

		SystemParam.create(system_param_categories_id: 9,key:"TRANSPORTATION_BONUS_AMOUNT",value:"200.00",description:"Transportation bonus of $200.00",created_by: 1,updated_by: 1)

	end
end