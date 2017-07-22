namespace :populate_codetable18 do
	desc "add_missing_payment_types"
	task :add_missing_payment_types => :environment do
		# update
		CodetableItem.where(code_table_id: 116, id: 5760).update_all(short_description:"Regular TEA",long_description: " ")
		CodetableItem.where(code_table_id: 116, id: 5761).update_all(short_description:"Supplement TEA New",long_description: " ")
		CodetableItem.where(code_table_id: 116, id: 5762).update_all(short_description:"TEA Extra",long_description: " ")
		#  Accessing connection object of Model all SQL queries can be run.
		# CodetableItem.connection.execute("update codetable_items set short_description = 'Regular TEA',long_description = ' ' where code_table_id = 116 and id = 5760")
		# CodetableItem.connection.execute("update codetable_items set short_description = 'Supplement TEA New',long_description = ' ' where code_table_id = 116 and id = 5761")
		# CodetableItem.connection.execute("update codetable_items set short_description = 'TEA Extra',long_description = ' ' where code_table_id = 116 and id = 5762")

		#  Add
		 CodetableItem.create(code_table_id: 116,short_description:"Supplement TEA Retro",long_description:" ",system_defined:"FALSE",active:"TRUE")
		 CodetableItem.create(code_table_id: 116,short_description:"Supplement TEA Correction",long_description:" ",system_defined:"FALSE",active:"TRUE")
		 CodetableItem.create(code_table_id: 116,short_description:"Regular Work pays",long_description:" ",system_defined:"FALSE",active:"TRUE")
		 CodetableItem.create(code_table_id: 116,short_description:"Supplement Work Pays Retro",long_description:" ",system_defined:"FALSE",active:"TRUE")
end
end