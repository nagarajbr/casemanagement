namespace :populate_codetable57 do
	desc "Client Application Questions"
	task :client_application_questions => :environment do
		code_tables = CodeTable.create(name:"Client Application Questions",description:"Client Application Questions")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Have you or anyone in your household received TANF assistance in another state? ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Do you have or have you ever had an electronic benefits transfer (EBT) card in
Arkansas? ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		 CodetableItem.create(code_table_id:code_tables.id,short_description:"Have you or any household member been found guilty of or pled guilty or nolo
contendere (no contest) to a felony conviction involving the manufacture or distribution
of a controlled substance? ",long_description:" ",system_defined:"FALSE",active:"TRUE")
		 CodetableItem.create(code_table_id:code_tables.id,short_description:"Would you like to register to vote? ",long_description:" ",system_defined:"FALSE",active:"TRUE")
	end
end