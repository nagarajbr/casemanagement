namespace :populate_codetable122 do
	desc "error messages - resources"
	task :add_error_messageresource_rule => :environment do
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Resource rule failed",long_description:"",system_defined:"FALSE",active:"TRUE")
	end
end