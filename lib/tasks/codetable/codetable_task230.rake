namespace :populate_codetable230 do
	desc "adding legal characterics and sanction related ed reasons"
	task :adding_work_on_employment_planning_and_cpp_work_task_type => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Work on Employment Planning and career plan",long_description:"Work on Employment Planning and career plan",system_defined:"TRUE",active:"TRUE")
	end
end