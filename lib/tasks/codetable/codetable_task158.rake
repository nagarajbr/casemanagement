namespace :populate_codetable158 do
	desc "additional work task navigation to types "
	task :additional_work_task_nav_type => :environment do

		CodetableItem.create(code_table_id:162,short_description:"Service Authorization",long_description:"Service Authorization",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"Provider Invoice",long_description:"Provider Invoice",system_defined:"FALSE",active:"TRUE")


	end
end