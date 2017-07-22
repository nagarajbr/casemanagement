namespace :populate_codetable167 do
	desc "Add Actions List "
	task :add_action => :environment do
		code_table_object = CodeTable.create(name:"Actions",description:"Actions List .")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Create Tasks",long_description:"create_task",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Create Alert",long_description:"create_alert",system_defined:"TRUE",active:"TRUE")

	end
end