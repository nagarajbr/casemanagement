namespace :populate_sys_param37 do
	desc "Gain Work Experience through Vocational Education Mapped to Federal Component"
	task :action_service_mapping_to_federal_component3 => :environment do

	SystemParam.where("system_param_categories_id = 16 and key = '6286'").destroy_all
	SystemParam.create(system_param_categories_id:16,key:"6286",value:"6268",description:"Gain Work Experience through Vocational Education  Mapped To Education Directly Related to Employment (Non-core)",created_by: 1,updated_by: 1)
 end
 end