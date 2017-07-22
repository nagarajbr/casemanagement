namespace :populate_codetable232 do
	desc "adding task type for CPP Final Approve"
	task :adding_approve_cpp_work_order_type => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Approve career plan",long_description:"Approve career plan",system_defined:"TRUE",active:"TRUE")
	end
end