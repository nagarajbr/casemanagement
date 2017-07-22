namespace :populate_codetable112 do
	desc "Absent Reasons"
	task :absent_reasons => :environment do
		code_table = CodeTable.create(name:"Absent Reasons",description:"Absent Reasons")
		CodetableItem.create(code_table_id:code_table.id,short_description:"Authorized Holiday",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table.id,short_description:"Did not attend",long_description:"",system_defined:"FALSE",active:"TRUE")

		CodetableItem.create(code_table_id:code_table.id,short_description:"Did not attend - Not Excused",long_description:"",system_defined:"FALSE",active:"TRUE")

		CodetableItem.create(code_table_id:code_table.id,short_description:"Discharged",long_description:"",system_defined:"FALSE",active:"TRUE")

		CodetableItem.create(code_table_id:code_table.id,short_description:"Emergency Closing of facility",long_description:"",system_defined:"FALSE",active:"TRUE")

		 CodetableItem.create(code_table_id:code_table.id,short_description:"Family Bereavement",long_description:"",system_defined:"FALSE",active:"TRUE")

		CodetableItem.create(code_table_id:code_table.id,short_description:"Hospitalization",long_description:"",system_defined:"FALSE",active:"TRUE")

		 CodetableItem.create(code_table_id:code_table.id,short_description:"In Custody",long_description:"",system_defined:"FALSE",active:"TRUE")

		 CodetableItem.create(code_table_id:code_table.id,short_description:"Medical",long_description:"",system_defined:"FALSE",active:"TRUE")

		 CodetableItem.create(code_table_id:code_table.id,short_description:"Sickness",long_description:"",system_defined:"FALSE",active:"TRUE")

		 CodetableItem.create(code_table_id:code_table.id,short_description:"Unauthorized Holiday",long_description:"",system_defined:"FALSE",active:"TRUE")



	end
end
