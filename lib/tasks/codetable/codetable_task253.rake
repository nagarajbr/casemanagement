namespace :populate_codetable253 do
	desc "adding_work_order_type_work_on_program_unit"
	task :adding_work_order_type_work_on_program_unit => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Work on Program Unit due to batch Eligibility Determination",long_description:"Work on Program Unit due to batch Eligibility Determination",system_defined:"TRUE",active:"TRUE")
	end
end