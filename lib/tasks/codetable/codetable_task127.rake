namespace :populate_codetable127 do
	desc "Assigned To Types"
	task :assigned_to_types => :environment do
		code_table_object = CodeTable.create(name:"Assigned To Types",description:"Task can be assigned to User or Local Office.")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"User",long_description:"User",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Local Office",long_description:"Local Office",system_defined:"TRUE",active:"TRUE")
    end
end