namespace :populate_sys_param80 do
	desc "Delete Barrier Mapped to Activity Type"
	task :delete_barrier_mapped_to_activity_type_for_transportation => :environment do
		SystemParam.where("system_param_categories_id = 23 and key = '27' and value in ('6361','6362','6359')").destroy_all
	end
end