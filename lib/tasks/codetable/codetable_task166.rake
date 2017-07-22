namespace :populate_codetable166 do
	desc "Add Event List "
	task :add_event => :environment do
		code_table_object = CodeTable.create(name:"Events",description:"Events List .")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Tranafer of Case to new local office",long_description:" Tranafer of Case to new local office",system_defined:"TRUE",active:"TRUE")
	end
end