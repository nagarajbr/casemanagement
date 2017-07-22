namespace :populate_sys_param68 do
    desc "notice generation reasons to policy numbers for turned 18"
    task :notice_generation_reasons_to_policy_numbers_for_turned_18 => :environment do

    SystemParam.create(system_param_categories_id: 27,key:"6638",value:"TEA-2201",description:"Child Turned 18",created_by: 1,updated_by: 1)

    end
end
