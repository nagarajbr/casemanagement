namespace :populate_codetable54 do
	desc "Work Participation reason"
	task :add_work_participation_reason_items => :environment do
		codetableitems = CodetableItem.create(code_table_id:113,short_description:"Deferred/Exempt Conversion",long_description:"Deferred/Exempt Conversion",system_defined:"FALSE",active:"TRUE")
	end
end