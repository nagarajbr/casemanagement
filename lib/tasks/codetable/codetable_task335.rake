namespace :populate_codetable335 do
	desc "adding_beneficiary_type_resource_adjustment_and_use"
	task :adding_beneficiary_type_resource_adjustment_and_use => :environment do
		CodetableItem.create(code_table_id:162,short_description:"Resource Adjustment",long_description:"Resource Adjustment",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"Resource Use",long_description:"Resource Use",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"ClientCharacteristic",long_description:"ClientCharacteristic",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"SanctionDetail",long_description:"SanctionDetail",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"Employment",long_description:"Employment",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"EmploymentDetail",long_description:"EmploymentDetail",system_defined:"TRUE",active:"TRUE")
	end
end