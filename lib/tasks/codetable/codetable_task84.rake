namespace :populate_codetable84 do
	desc "Provider_status_AASIS_Errored"
	task :provider_status_2 => :environment do
		codetableitems = CodetableItem.create(code_table_id:157,short_description:"AASIS-Unverified",long_description:"Error message returned from AASIS",system_defined:"FALSE",active:"TRUE")
	end
end
