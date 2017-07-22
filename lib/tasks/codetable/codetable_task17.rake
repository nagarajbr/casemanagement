namespace :populate_codetable17 do
	desc "add_missing_work_participation_characteristics"
	task :add_missing_work_participation_characteristics => :environment do

		#  delete 5704.
		# "TEA SSA Denial Appeal Pen" (1) - since we did not find this work participation charactersitivs in Mainframe for Time limits.
		CodetableItem.where("code_table_id = 113 and id = 5704 ").destroy_all

		#  Add
		# Cancel Payment
		# Return Payment
		# Duplicate Payment
		 CodetableItem.create(code_table_id: 113,short_description:"Cancel Payment",long_description:" ",system_defined:"FALSE",active:"TRUE")
		 CodetableItem.create(code_table_id: 113,short_description:"Return Payment",long_description:" ",system_defined:"FALSE",active:"TRUE")
		 CodetableItem.create(code_table_id: 113,short_description:"Duplicate Payment",long_description:" ",system_defined:"FALSE",active:"TRUE")

end

end