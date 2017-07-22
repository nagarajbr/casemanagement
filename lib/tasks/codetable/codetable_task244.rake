namespace :populate_codetable244 do
	desc "Approve service payment amount above threshold task type"
	task :approve_cpp_task_type => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Approve service payment amount above threshold",long_description:"Approve service payment amount above threshold",system_defined:"TRUE",active:"TRUE")
	end
end