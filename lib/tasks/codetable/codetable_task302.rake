namespace :populate_codetable302 do
	desc "barrier mapping to activity type"
	task :barrier_mapping_to_activity_type_for_child_care  => :environment do
		codetableitems = CodetableItem.create(code_table_id:181,short_description:"Take care of children",long_description:"Take care of children",system_defined:"FALSE",active:"TRUE")


	end
end