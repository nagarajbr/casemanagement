namespace :populate_codetable154 do
	desc "work task beneficiary Program wizard "
	task :work_task_beneficiary_program_wizard => :environment do

		CodetableItem.create(code_table_id:162,short_description:"Program Wizard",long_description:"Program Wizard",system_defined:"FALSE",active:"TRUE")

	end
end