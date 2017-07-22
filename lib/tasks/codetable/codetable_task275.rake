namespace :populate_codetable275 do
	desc "adding task type for sanction Recommendation"
	task :adding_task_type_for_sanction_recommendation => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Potentially eligible for sanction",long_description:"Potentially eligible for sanction",system_defined:"TRUE",active:"TRUE")
	end
end