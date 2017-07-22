namespace :system_param_age_18 do
	desc "system_param_age_18"
	task :system_param_age_18 => :environment do
		SystemParam.where("system_param_categories_id = 6").update_all(value:'18')
	end
end