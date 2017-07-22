namespace :populate_codetable58 do
	desc "Guardian_relationship"
	task :guardian_relationship => :environment do
		CodetableItem.create(code_table_id:125, short_description:"Rep/Guardian/Payee", long_description:" ",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:125, short_description:"Dependent/Ward", long_description:" ",system_defined:"FALSE",active:"TRUE")

	end
end