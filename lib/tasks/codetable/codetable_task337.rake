namespace :populate_codetable337 do
	desc "adding_birth_certificate_identification_type"
	task :adding_birth_certificate_identification_type  => :environment do
		CodetableItem.create(code_table_id:92,short_description:"Birth Certificate",long_description:"Birth Certificate",system_defined:"TRUE",active:"TRUE")
		# adding_beneficiary_type_income_adjust_reason_and out_of_state_payments
		CodetableItem.create(code_table_id:162,short_description:"IncomeDetailAdjustReason",long_description:"IncomeDetailAdjustReason",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"OutOfStatePayments",long_description:"OutOfStatePayments",system_defined:"TRUE",active:"TRUE")
	end
end