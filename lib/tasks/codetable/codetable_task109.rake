namespace :populate_codetable109 do
	desc "Action Types"
	task :action_types => :environment do
		code_table = CodeTable.create(name:"Action Types",description:"Action Types leading to Core or Non core federal components")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Become Self-Employed",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Increase Hours",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Increase Wages",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Obtain Benefits",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Obtain Full-time Employment",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Obtain Part-time Employment",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Obtain Temporary/Seasonal Employment",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Retain Employment",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Submit Job Search Daily Logs to Case Manager",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in community service",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in providing childcare for another participant who is participating in a community service program",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in Advanced Degree Program",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in Bachelor's Degree Program",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in Two-year Degree Program",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Submit Attendance record",long_description:"",system_defined:"FALSE",active:"TRUE")





	end
end