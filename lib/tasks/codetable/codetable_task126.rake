namespace :populate_codetable126 do
	desc "Work task status"
	task :work_task_status => :environment do
		code_table_object = CodeTable.create(name:"Work Task Status",description:"Work Task Statuses")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Pending",long_description:"Pending",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Work In Progress",long_description:"Work In Progress",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Complete",long_description:"Complete",system_defined:"TRUE",active:"TRUE")
    end
end