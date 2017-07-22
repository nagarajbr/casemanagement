namespace :populate_codetable323 do
	desc "adding new work task type"
	task :adding_program_unit_transfer => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Program unit transfer",long_description:"Program unit transfer",system_defined:"TRUE",active:"TRUE")
	end
end