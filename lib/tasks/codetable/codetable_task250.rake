namespace :populate_codetable250 do
	desc "program unit benefit amount approval related queues"
	task :adding_program_unit_benefit_amount_approval_related_queues => :environment do
		CodetableItem.create(code_table_id:196,short_description:"Assessment Completed Queue",long_description:"Assessment Completed Queue",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:196,short_description:"Eligibility Determination Completed Queue",long_description:"Eligibility Determination Completed Queue",system_defined:"TRUE",active:"TRUE")
	end
end