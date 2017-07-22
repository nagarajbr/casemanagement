namespace :populate_codetable213 do
	desc "adding program unit closure to work order types"
	task :adding_work_order_type => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Program Unit closure",long_description:"Closure with bonus if good cause",system_defined:"TRUE",active:"TRUE")
	end
end