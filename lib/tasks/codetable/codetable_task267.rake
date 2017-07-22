namespace :populate_codetable267 do
	desc "add new cental office"
	task :add_central_office => :environment do
		CodetableItem.create(code_table_id:2,short_description:"Central Office",long_description:"Central Office",system_defined:"FALSE",active:"TRUE")
    end
end