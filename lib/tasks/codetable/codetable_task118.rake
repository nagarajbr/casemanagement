namespace :populate_codetable118 do
	desc "Transportation Bonus Pay Type"
	task :add_transportation_bonus_pay_type => :environment do
		codetableitems = CodetableItem.create(code_table_id:171,short_description:"Transportation Bonus",long_description:"Transportation Bonus",system_defined:"FALSE",active:"TRUE")
	end
end