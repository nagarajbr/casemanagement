namespace :populate_codetable271 do
	desc "add FMS payment relese queue"
	task :add_fms_payment_release_queue => :environment do
		CodetableItem.create(code_table_id:200,short_description:"FMS payment release",long_description:"FMS payment release",system_defined:"FALSE",active:"TRUE")
	end
end