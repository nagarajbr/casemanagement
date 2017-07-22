namespace :populate_codetable114 do
	desc "Other status for Notice"
	task :other_notice_status => :environment do

		CodetableItem.create(code_table_id:65,short_description:"Other",long_description:"",system_defined:"FALSE",active:"TRUE")

	end
end
