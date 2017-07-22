namespace :populate_codetable131 do
	desc "Alert Categories"
	task :alert_category => :environment do
		code_table = CodeTable.create(name:"Alert Categories",description:"Alert categories - General information to all users or business alert targetted to specific user")
		CodetableItem.create(code_table_id:code_table.id,short_description:"General Information Alert",long_description:"General information alert targetted to all users",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table.id,short_description:"Business Alert",long_description:"Business Alert targetted to specific user",system_defined:"FALSE",active:"TRUE")
	end
end
