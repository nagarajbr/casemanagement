namespace :populate_codetable243 do
	desc "adding task type to create a work task when assignment done from queue"
	task :adding_task_type_to_create_a_work_task_when_assignment_done_from_queue => :environment do
		CodetableItem.create(code_table_id:18,short_description:"create a work task when assignment done from queue",long_description:"adding task type to create a work task when assignment done from queue",system_defined:"TRUE",active:"TRUE")
	end
end