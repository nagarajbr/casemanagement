namespace :populate_codetable144 do
	desc "Work Task Category - Client"
	task :task_category_client => :environment do
		CodetableItem.create(code_table_id:166,short_description:"Client",long_description:"Client",system_defined:"FALSE",active:"TRUE")
    end
end