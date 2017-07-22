namespace :populate_codetable310 do
	desc "activity hours absent reason"
	task :add_activity_hours_absent_reason  => :environment do
		codetableitems = CodetableItem.create(code_table_id:183,short_description:"Compensation time off",long_description:"Compensation time off",system_defined:"FALSE",active:"TRUE")
	end
end
