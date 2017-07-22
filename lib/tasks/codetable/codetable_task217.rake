namespace :populate_codetable217 do
	desc "provider intake queue"
	task :additional_queue_type => :environment do
		CodetableItem.create(code_table_id:196,short_description:"Provider Registration Queue",long_description:"Provider Registration Queue",system_defined:"TRUE",active:"TRUE")
	end
end