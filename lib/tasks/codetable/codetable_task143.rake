namespace :populate_codetable143 do
	desc "withdraw status type added"
	task :withdraw_status_type => :environment do
		CodetableItem.create(code_table_id:180,short_description:"Withdraw",long_description:"Withdraw",system_defined:"FALSE",active:"TRUE")
    end
end