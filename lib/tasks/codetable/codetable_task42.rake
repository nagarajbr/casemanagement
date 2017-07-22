namespace :populate_codetable42 do
	desc "add_local_office_codetable_items"
	task :add_local_office_codetable_items => :environment do
		codetableitems = CodetableItem.create(code_table_id:"2",short_description:"Malvern",long_description:"Malvern",system_defined:"FALSE",active:"TRUE")
	end
end