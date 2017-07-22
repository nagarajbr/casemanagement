namespace :populate_sys_param68 do
	desc "more notice generation reasons to policy numbers"
	task :more_notice_generation_reasons_to_policy_numbers => :environment do

	SystemParam.create(system_param_categories_id: 27,key:"6636",value:"TEA-2201",description:"Ineligible due to SSI",created_by: 1,updated_by: 1)

	end
end
