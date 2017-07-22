namespace :populate_codetable227 do
	desc "adding legal characterics and sanction related ed reasons"
	task :adding_legal_characterics_and_sanction_related_ed_reasons => :environment do
		CodetableItem.create(code_table_id:194,short_description:"IPV Information Changed",long_description:"IPV Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Fleeing Felon Information Changed",long_description:"Fleeing Felon Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Drug conviction Information Changed",long_description:"Drug conviction Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Gang activity Information Changed",long_description:"Gang activity Information Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Immunizations Sanction",long_description:"Immunizations Sanction",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"OCSE Sanction",long_description:"OCSE Sanction",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Progressive Sanction",long_description:"Progressive Sanction",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Refusal to sign PRA by minor parent",long_description:"Refusal to sign PRA by minor parent",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Class attendance-minor parent",long_description:"Class attendance-minor parent",system_defined:"TRUE",active:"TRUE")
	end
end