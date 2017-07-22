namespace :populate_codetable87 do
	desc "service_authorization_status_2"
	task :service_authorization_status_2 => :environment do
		codetableitems = CodetableItem.create(code_table_id:159,short_description:"Cancelled",long_description:"Supervisor can cancel the Service Authorization - Opposite of Authorized.",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:159,short_description:"Rejected",long_description:"Service Authorization can be rejected by Particpant or provider if they are not available or units are not available",system_defined:"FALSE",active:"TRUE")
	end
end