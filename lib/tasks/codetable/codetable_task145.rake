namespace :populate_codetable145 do
	desc "Work Task benefit category - Sanction"
	task :task_benefit_category_sanction => :environment do
		CodetableItem.create(code_table_id:162,short_description:"Sanction",long_description:"Sanction",system_defined:"FALSE",active:"TRUE")
    end
end