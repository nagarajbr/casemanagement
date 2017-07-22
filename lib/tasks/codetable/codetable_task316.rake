namespace :populate_codetable316 do
	desc "tea_diversion_validation_codes"
	task :tea_diversion_validation_codes => :environment do
		CodetableItem.create(code_table_id:130,short_description:"TEA Diversion Assessment Requirement Failed",long_description:"TEA Diversion Assessment Requirement Failed",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:130,short_description:"TEA Diversion Payment Requirement Failed",long_description:"TEA Diversion Payment Requirement Failed",system_defined:"FALSE",active:"TRUE")
	end
end