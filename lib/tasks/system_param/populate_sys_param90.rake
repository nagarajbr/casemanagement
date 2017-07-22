namespace :populate_sys_param90 do
	desc "notes types"
	task :notes_type => :environment do

		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)

		SystemParam.create(system_param_categories_id:26,key:"6745",value:"31",description:"Barrier Reduction Plan")

	end
end