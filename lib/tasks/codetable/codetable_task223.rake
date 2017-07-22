namespace :populate_codetable223 do
	desc "adding adding payment cancelled reason to ocse referral reasons"
	task :adding_payment_cancelled_reason_to_ocse_referral_reasons => :environment do
		CodetableItem.create(code_table_id:195,short_description:"Payment Cancelled",long_description:"Payment Cancelled",system_defined:"FALSE",active:"TRUE")
	end
end