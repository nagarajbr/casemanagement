namespace :populate_codetable177 do
	desc "Add notes type1"
	task :add_notes_type_1 => :environment do
		CodetableItem.create(code_table_id:131,short_description:"Client",long_description:"Client",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"ClientRace",long_description:"ClientRace",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"Alien",long_description:"Alien",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"Address",long_description:"Address",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"ClientRelationship",long_description:"ClientRelationship",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"ClientCharacteristicDisability",long_description:"ClientCharacteristicDisability",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"ClientCharacteristicHealth",long_description:"ClientCharacteristicHealth",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"ClientCharacteristicWorkParticipation",long_description:"ClientCharacteristicWorkParticipation",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"ClientCharacteristicLegal",long_description:"ClientCharacteristicLegal",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"ClientCharacteristicOther",long_description:"ClientCharacteristicOther",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"Pregnancy",long_description:"Pregnancy",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"Disability",long_description:"Disability",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"Immunization",long_description:"Immunization",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"Income",long_description:"Income",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"Expense",long_description:"Expense",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"Resource",long_description:"Resource",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"Education",long_description:"Education",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"Employment",long_description:"Employment",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"Sanction",long_description:"Sanction",system_defined:"TRUE",active:"TRUE")

		CodetableItem.create(code_table_id:131,short_description:"ClientParentalRspability",long_description:"ClientParentalRspability",system_defined:"TRUE",active:"TRUE")

	end
end