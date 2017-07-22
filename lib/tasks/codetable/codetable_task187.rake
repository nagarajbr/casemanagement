namespace :populate_codetable187 do
	desc "notes types"
	task :add_notes_type => :environment do
		CodetableItem.create(code_table_id:131,short_description:"ActionPlan",long_description:"ActionPlan",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:131,short_description:"ActionPlanDetail",long_description:"ActionPlanDetail",system_defined:"TRUE",active:"TRUE")
	end
end