namespace :populate_codetable332 do
	desc "work task category is split it two code_table values"
	task :work_task_category => :environment do
		CodeTable.where("id = 166").update_all("name ='Work Task Category for arwins application',description = 'Work Task Category for arwins application'")
		code_table = CodeTable.create(name:"Work Task Category for provider application",description:"Work Task Category for provider application")
		CodetableItem.where("id = 6352").update_all("code_table_id = #{code_table.id} ")
	end
end

