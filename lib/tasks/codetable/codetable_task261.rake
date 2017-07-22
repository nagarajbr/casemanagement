namespace :populate_codetable261 do
	desc "add work order types"
	task :adding_work_order_type_related_to_provider => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Ready for FMS review",long_description:"Ready for FMS review",system_defined:"TRUE",active:"TRUE")
	end
end