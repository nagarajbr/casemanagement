namespace :populate_codetable128 do
	desc "addition task types"
	task :additional_task_type => :environment do

		CodetableItem.create(code_table_id:18,short_description:"Assign Case Manager to Program Unit",long_description:"Assign Case Manager to Program Unit",system_defined:"TRUE",active:"TRUE")

    end
end