namespace :populate_codetable247 do
	desc "Adding CPP queues"
	task :adding_cpp_queues => :environment do
		CodetableItem.where("id=6561").update_all(short_description:"Request for approval of career plan queue for client",long_description:"Request for approval of career plan queue for client")
		CodetableItem.create(code_table_id:196,short_description:"Approved career plan for client",long_description:"Approved career plan for client",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:196,short_description:"Approved career plan for Program Unit",long_description:"Approved career plan for Program Unit",system_defined:"TRUE",active:"TRUE")
	end
end