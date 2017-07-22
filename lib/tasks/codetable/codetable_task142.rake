namespace :populate_codetable142 do
	desc "Assessment Withdraw reasons"
	task :assessment_withdraw_reasons => :environment do
		code_table = CodeTable.create(name:"Assessment Withdraw reasons",description:"Assessment Withdraw reasons")
		CodetableItem.create(code_table_id:code_table.id,short_description:"Client Initiated",long_description:"Client Initiated",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table.id,short_description:"No Cooperation from Client",long_description:"No Cooperation from Client",system_defined:"FALSE",active:"TRUE")
	end
end