namespace :populate_codetable278 do
	desc "change health characteristics to substance abuse characteristics "
	task :update_substance_abuse_chars  => :environment do
		# All substance abuse chars like alcohol/codine etc are made inactive and added general characteristic -Substance abuse and made active
		CodetableItem.where("code_table_id = 115").update_all(active: false)
		CodetableItem.where("code_table_id = 115 and id = 5753").update_all(short_description: 'Substance Abuse',long_description: 'Substance Abuse',active: true)

		# mental health notes type
		CodetableItem.where("code_table_id = 115 and id = 5757").update_all(code_table_id: 131, short_description: 'Mental health characteristic notes type',long_description: 'Mental health characteristic notes type',active: true)
	end
end