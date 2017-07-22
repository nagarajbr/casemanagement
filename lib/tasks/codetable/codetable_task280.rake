namespace :populate_codetable280 do
	desc "Domestic Violence characteristics "
	task :domestic_violence_characteristics  => :environment do
		code_table = CodeTable.create(name:"Domestic Violence Characteristics",description:"Domestic Violence Characteristics")

		CodetableItem.where("id = 5721").update_all(code_table_id:code_table.id,active: true, type: nil)	

		# domestic violence notes type
		CodetableItem.where("id = 5754").update_all(code_table_id:131,active: true, type: nil,short_description: 'Domestic Violence characteristic',long_description: 'characteristic')	
		
		
	end
end