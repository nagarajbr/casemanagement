namespace :populate_codetable281 do
	desc "Legal characteristics "
	task :update_legal_characteristics  => :environment do
		code_table = CodeTable.create(name:"Legal Characteristics",description:"Legal Characteristics")
		CodetableItem.where("id in(5616,
									6332,
									5614,
									6331,
									5612,
									5611) ").update_all(code_table_id:code_table.id,active: true, type: nil)	



		
	end
end