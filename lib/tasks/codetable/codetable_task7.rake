namespace :codetable_task7 do
	desc "Setting up Race Single table inheritance"
	task :field_update => :environment do
		CodetableItem.where(code_table_id: 9).update_all(type:"Race")
	end
end