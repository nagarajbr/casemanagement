namespace :populate_codetable205 do
	desc "adding ocse referral reasons"
	task :adding_ocse_referral_reasons => :environment do
		code_table_object = CodeTable.create(name:"OCSE Referral Reasons",description:"OCSE Referral Reasons")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Absent Parent New",long_description:"Absent Parent",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Good Cause Informtion Changed",long_description:"Good Cause Informtion Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Deprivation Reason Changed",long_description:"Deprivation Reason Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Absent Parent Information Changed",long_description:"Court Order Amount Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Program Unit OCSE Referral",long_description:"Court Order Amount Changed",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Program Unit Payment",long_description:"Court Order Amount Changed",system_defined:"TRUE",active:"TRUE")
	end
end