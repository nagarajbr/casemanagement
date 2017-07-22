namespace :populate_codetable152 do
	desc "additional beneficiary types "
	task :work_task_beneficiary_type_added => :environment do

		CodetableItem.create(code_table_id:162,short_description:"Income",long_description:"Income",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"Resource",long_description:"Resource",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"Alien",long_description:"Alien",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"Address",long_description:"Address",system_defined:"FALSE",active:"TRUE")

	end
end