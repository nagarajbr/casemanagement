namespace :populate_codetable214 do
	desc "Added new TEA Denial Reasons "
	task :added_new_denial_reasons  => :environment do

    CodetableItem.where("code_table_id = 72 and id = 4166 ").update_all(code_table_id: 66)
 end
end