namespace :populate_codetable255 do
	desc "CPP Approval Queue "
	task :cpp_approval_queue  => :environment do
		#196-"QUEUES"
		codetableitems = CodetableItem.create(code_table_id:196,short_description:"career plan Approval for Program Unit",long_description:"career plan Approval for Program Unit",system_defined:"FALSE",active:"TRUE")


	end
end