namespace :populate_codetable208 do
	desc "adding additional eligibility rules messages1"
	task :adding_additional_ed_messages1 => :environment do
		CodetableItem.create(code_table_id:130,short_description:"No current or future employment",long_description:"No current or future employment - TEA Diversion",system_defined:"TRUE",active:"TRUE")
	end
end