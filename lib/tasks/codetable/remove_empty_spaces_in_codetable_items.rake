namespace :remove_empty_spaces_in_codetable_items do
	desc "Remove blank spaces from codetable_items table"
	task :remove_empty_spaces_in_codetable_items => :environment do
		CodetableItem.where("LTRIM(RTRIM(short_description)) = '' ").destroy_all
	end
end