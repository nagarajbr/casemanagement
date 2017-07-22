namespace :populate_codetable191 do
	desc "Adding action type nightly batch and task types"
	task :adding_action_and_task_type  => :environment do
		CodetableItem.create(code_table_id:192,short_description:"Create Nightly Batch Entry",long_description:"NightlyBatchProcessService.create_batch_process_entry",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:192,short_description:"SSN Enumeration",long_description:"Send for SSN Enumeration",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:192,short_description:"Citizenship Verification",long_description:"Send for Citizenship Verification",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:192,short_description:"OCSE Referral",long_description:"Send to OCSE for referral",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:192,short_description:"EBT",long_description:"Send to EBT vendor",system_defined:"TRUE",active:"TRUE")
	end
end

