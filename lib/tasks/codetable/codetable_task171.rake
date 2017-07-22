namespace :populate_codetable171 do
	desc "Add work task "
	task :add_work_task5 => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Work on Rejected Provider Agreement",long_description:"Work on Rejected Provider Agreement",system_defined:"TRUE",active:"TRUE")
	end
end