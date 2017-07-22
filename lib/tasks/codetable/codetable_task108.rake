namespace :populate_codetable108 do
	desc "Missing Core & Non_core_activity_types"
	task :core_non_core_activity_types => :environment do
		codetableitems = CodetableItem.create(code_table_id:173,short_description:"Providing child care services to a Community Service participant (Core)",long_description:"Providing child care services to a Community Service participant (Core) ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:174,short_description:"Education Directly Related to Employment (Non-core)",long_description:"Education Directly Related to Employment (Non-core)",system_defined:"FALSE",active:"TRUE")

	end
end
