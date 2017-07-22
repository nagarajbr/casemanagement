namespace :populate_codetable279 do
	desc "Mental health characteristics "
	task :mental_health_characteristics  => :environment do
		code_table = CodeTable.create(name:"Mental Health Characteristics",description:"Mental Health Characteristics")

		CodetableItem.where("id = 5755").update_all(code_table_id:code_table.id,short_description: 'Unstable mental health',long_description: 'Unstable mental health',active: true, type: nil)	
		CodetableItem.where("id = 5756").update_all(code_table_id:code_table.id,short_description: 'ADD(Attention deficit disorder)',long_description: 'ADD(Attention deficit disorder)',active: true, type: nil)	
		
	end
end