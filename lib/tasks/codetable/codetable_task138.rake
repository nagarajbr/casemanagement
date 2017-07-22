namespace :populate_codetable138 do
	desc "None Federal component"
	task :none_federal_component => :environment do
		CodetableItem.create(code_table_id:174,short_description:"None",long_description:"None",system_defined:"FALSE",active:"TRUE")
    end
end