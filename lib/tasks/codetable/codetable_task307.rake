namespace :populate_codetable307 do
	desc "new notes type added"
	task :notes_type_career_pathway_plan => :environment do

		CodetableItem.create(code_table_id: 131,short_description:"Career Plan",long_description:"Career Plan",system_defined:"FALSE",active:"TRUE")

	end
end