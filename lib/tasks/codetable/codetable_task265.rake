namespace :populate_codetable265 do
	desc "household member registration questions"
	task :household_member_registration_questions => :environment do
		code_table_object = CodeTable.create(name:"Household Member Registration Questions",description:"Household Member Registration Questions")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Have you received TANF assistance in another state? ",long_description:"Have you received TANF assistance in another state? ",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Have you been found guilty of or pled guilty or nolo contendere (no contest) to a felony conviction involving the manufacture or distribution of a controlled substance?",long_description:"Have you been found guilty of or pled guilty or nolo contendere (no contest) to a felony conviction involving the manufacture or distribution of a controlled substance?",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Would you like to register to vote?",long_description:"Would you like to register to vote?",system_defined:"FALSE",active:"TRUE")
	end
end