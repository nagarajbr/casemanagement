namespace :populate_codetable270 do
	desc "Delete duplicate income type "
	task :delete_duplicate_income_type  => :environment do
		# Income type id 5902 is duplicate - there is one exists 2790 - "Salary/Wages OJT/WIA"
		CodetableItem.where("code_table_id = 36 and id = 5902").destroy_all

	end
end