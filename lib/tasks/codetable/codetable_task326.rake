namespace :populate_codetable326 do
	desc "adding_absent_reason_deferral"
	task :adding_absent_reason_deferral  => :environment do
		CodetableItem.create(code_table_id:183,short_description:"Deferral/Exemption",long_description:"Deferral/Exemption",system_defined:"FALSE",active:"TRUE")
	end
end