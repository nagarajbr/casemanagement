namespace :populate_codetable291 do
	desc "Adding benficiary types  "
	task :add_beneficiary_type_for_action_plan_details  => :environment do
		CodetableItem.create(code_table_id:162,short_description:"Action plan detail",long_description:"Action plan detail",system_defined:"FALSE",active:"TRUE")

	end
end