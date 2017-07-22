namespace :populate_sys_param73 do
	desc "Child age "
	task :Child_age_18 => :environment do
		# age under 18 will be considered as child
		SystemParam.where("id = 149").update_all("value = '18'")


	end
end