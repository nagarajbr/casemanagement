namespace :populate_codetable189 do
	desc "Adding notes type for resource detail "
	task :adding_notes_type_to_resource_detail  => :environment do
		CodetableItem.create(code_table_id:131,short_description:"ResourceDetail",long_description:"ResourceDetail",system_defined:"FALSE",active:"TRUE")
	end
end

