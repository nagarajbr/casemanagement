namespace :populate_codetable195 do
	desc "notes types"
	task :add_notes_type => :environment do
		CodetableItem.create(code_table_id:131,short_description:"CaseAssessment",long_description:"Other",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:131,short_description:"Interview",long_description:"Other",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:131,short_description:"Other",long_description:"Other",system_defined:"TRUE",active:"TRUE")
	end
end