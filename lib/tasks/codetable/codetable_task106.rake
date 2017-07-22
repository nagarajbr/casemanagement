namespace :populate_codetable106 do
	desc "Provider Agreement terminated status"
	task :agrmnt_terminated_status  => :environment do

		codetableitems = CodetableItem.create(code_table_id:160,short_description:"Terminated",long_description:"",system_defined:"FALSE",active:"TRUE")


	end
end