namespace :populate_codetable202 do
	desc "adding additional eligibility rules messages"
	task :adding_additional_ed_messages => :environment do
		CodetableItem.create(code_table_id:130,short_description:"Client did not meet work participation rate for 3 months in prior 6 months",long_description:"Participant has not complied for 3 months sanction in prior 6 month period ,so not eligible for WORKPAYS",system_defined:"TRUE",active:"TRUE")
	end
end