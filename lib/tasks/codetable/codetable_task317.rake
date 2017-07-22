namespace :populate_codetable317 do
	desc "adding new ebt reason"
	task :adding_new_ebt_reason => :environment do
		CodetableItem.create(code_table_id:197,short_description:"EBT First Time Activation",long_description:"EBT First Time Activation",system_defined:"TRUE",active:"TRUE")
	end
end