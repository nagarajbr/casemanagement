namespace :populate_sys_param15 do
	desc "out_of_state_limits_count"
	task :out_of_state_limits_count => :environment do
		SystemParam.create(system_param_categories_id:10,key:"OUT_OF_STATE_COUNT",value:"36",description:"Tea/wp state count should be less than (24 - (out_of_state_payment - 36 ))",created_by: 1,updated_by: 1)

	end
end