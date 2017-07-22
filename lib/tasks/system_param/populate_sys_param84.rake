namespace :populate_sys_param84 do
	desc "delete assessment sections"
	task :delete_short_assessments_sections => :environment do

		 user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)

    	SystemParam.where("system_param_categories_id = 9 and key = 'SHORT_ASSESSMENT_SECTIONS' and value='132'").destroy_all

	end
end
