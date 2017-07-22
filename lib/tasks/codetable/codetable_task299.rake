namespace :populate_codetable299 do
	desc "ruby element type codetable and work task type other is created - codetable added"
	task :ruby_type_codetable_added => :environment do
		CodetableItem.create(code_table_id:188,short_description:"CodeTable",long_description:"CodeTable",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:18,short_description:"Other",long_description:"Other",system_defined:"FALSE",active:"TRUE")
    end
end