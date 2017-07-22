namespace :populate_codetable252 do
	desc "adding_alert_type_case_manager_change"
	task :adding_alert_type_case_manager_change => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Change in Case Manager of Program Unit",long_description:"Change in Case Manager of Program Unit",system_defined:"TRUE",active:"TRUE")

	end
end

