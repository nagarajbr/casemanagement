namespace :populate_codetable304 do
	desc "new notes type added"
	task :notes_type_employment_plan => :environment do

		CodetableItem.create(code_table_id: 131,short_description:"Employment plan",long_description:"Employment plan",system_defined:"FALSE",active:"TRUE")

	end
end