namespace :populate_codetable306 do
	desc "new notes type added"
	task :notes_type_barrier_reduction_plan => :environment do

		CodetableItem.create(code_table_id: 131,short_description:"Barrier Reduction Plan",long_description:"Barrier Reduction Plan",system_defined:"FALSE",active:"TRUE")

	end
end