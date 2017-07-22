namespace :populate_codetable206 do
	desc "adding QUEUES"
	task :adding_queues => :environment do
		code_table_object = CodeTable.create(name:"QUEUE",description:"Name of queues")
		# 1.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Application Queue",long_description:"Application Queue",system_defined:"TRUE",active:"TRUE")
		# 2.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Determine Eligibility Queue",long_description:"Determine Eligibility Queue",system_defined:"TRUE",active:"TRUE")
# 3.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Assessment Queue",long_description:"Assessment Queue",system_defined:"TRUE",active:"TRUE")
# 4.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Employment Planning Queue",long_description:"Employment Planning Queue",system_defined:"TRUE",active:"TRUE")
# 5.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"career plan Approval Queue",long_description:"career plan Approval Queue",system_defined:"TRUE",active:"TRUE")
# 6.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"First Time Benefit Amount Approval Queue",long_description:"First Time Benefit Amount Approval Queue",system_defined:"TRUE",active:"TRUE")
# 7.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Provider Agreements Approval Queue",long_description:"Provider Agreements Approval Queue",system_defined:"TRUE",active:"TRUE")
# 8.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Provider service Payment Approval Queue",long_description:"Provider service Payment Approval Queue",system_defined:"TRUE",active:"TRUE")
# 9.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Provider Invoice Approval Queue",long_description:"Provider Invoice Approval Queue",system_defined:"TRUE",active:"TRUE")
# 10.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Supplement/Retro payment override Queue",long_description:"Supplement/Retro payment override Queue",system_defined:"TRUE",active:"TRUE")
# 11.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Transfer Program Unit Queue",long_description:"Transfer Program Unit Queue",system_defined:"TRUE",active:"TRUE")
# 12.
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Reassign Program Unit Queue",long_description:"Reassign Program Unit Queue",system_defined:"TRUE",active:"TRUE")
	end
end