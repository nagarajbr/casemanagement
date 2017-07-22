namespace :populate_codetable207 do
	desc "adding ocse referral reason"
	task :adding_ocse_referral_reason => :environment do
		CodetableItem.create(code_table_id:195,short_description:"Client Information Changed",long_description:"Client Information Changed",system_defined:"TRUE",active:"TRUE")
	end
end