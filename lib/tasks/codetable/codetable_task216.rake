namespace :populate_codetable216 do
	desc "adding program unit closure reasons to ocse reasons"
	task :adding_ocse_refferal_reason => :environment do
		CodetableItem.create(code_table_id:195,short_description:"Program Unit closure",long_description:"Program Unit Closure",system_defined:"TRUE",active:"TRUE")
	end
end