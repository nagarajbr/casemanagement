namespace :populate_codetable336 do
	desc "Work Task Types for arwins"
	task :additional_work_task_types => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Case review/staffing - Eligibility determination",long_description:"Case review/staffing- Eligibility determination",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:18,short_description:"Case review/staffing - Assessment ",long_description:"Case review/staffing - Assessment ",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:18,short_description:"Case review/staffing - Planning",long_description:"Case review/staffing - Planning",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:18,short_description:"Case review/staffing - Sanction",long_description:"Case review/staffing - Sanction",system_defined:"FALSE",active:"TRUE")
    end
end