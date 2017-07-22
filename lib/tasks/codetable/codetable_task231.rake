namespace :populate_codetable231 do
	desc "adding alert task type for Employment detail"
	task :adding_sanction_detail_work_order_type => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Employment Detail",long_description:"Employment Detail",system_defined:"TRUE",active:"TRUE")
	end
end