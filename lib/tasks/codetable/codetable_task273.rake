namespace :populate_codetable273 do
	desc "add educational grade"
	task :add_educational_grade => :environment do

		codetableitems = CodetableItem.create(code_table_id:24,short_description:"Pre-school",long_description:"Pre-school",system_defined:"FALSE",active:"TRUE")

	end
end