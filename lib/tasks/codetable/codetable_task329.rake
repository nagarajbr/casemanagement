namespace :populate_codetable329 do
	desc "work task is split it two code_table values"
	task :work_task_update => :environment do
		CodeTable.where("id = 18").update_all("name ='Work Order Types for arwins',description = 'Work Order Types for arwins'")
		code_table = CodeTable.create(name:"Work Order Types for provider ",description:"Work Order Types for provider ")
		CodetableItem.where("id in(6353,6459,6641)").update_all("code_table_id = #{code_table.id} ")
	end
end