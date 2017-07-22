namespace :populate_codetable262 do
	desc "adding sanction QUEUES"
	task :adding_sanction_queues => :environment do

		CodetableItem.create(code_table_id:196,short_description:"Ready for Sanctions Queue",long_description:"Ready for Sanctions Queue",system_defined:"TRUE",active:"TRUE", sort_order: 80)

	end
end