namespace :populate_codetable110 do
	desc "Services Types"
	task :service_types => :environment do
		code_table = CodeTable.create(name:"Services Types",description:"Services leading to Core or Non core federal components")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Attend Job Readiness Workshop",long_description:"Provide Job Readiness Workshop Service",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Attend Life Skills Training",long_description:"Provide Life Skills Training Service",system_defined:"FALSE",active:"TRUE")

		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Gain Work Experience through Vocational Education",long_description:"Provide Work Experience through Vocational Education Service",system_defined:"FALSE",active:"TRUE")

		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in ESL Program",long_description:"Provide ESL Program Service",system_defined:"FALSE",active:"TRUE")

		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in High School/GED Certificate Program",long_description:"Provide High School/GED Certificate Program Service",system_defined:"FALSE",active:"TRUE")

		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in Job Search",long_description:"Provide Job Search placement Service",system_defined:"FALSE",active:"TRUE")

		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in Literacy Program",long_description:"Provide Literacy Program Service",system_defined:"FALSE",active:"TRUE")

		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in on-the-Job Training Placement",long_description:"Provide on-the-Job Training Placement Service",system_defined:"FALSE",active:"TRUE")

		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in Vocational Certification/Licensure Program",long_description:"Provide Vocational Certification/Licensure Program Service",system_defined:"FALSE",active:"TRUE")

		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Participate in Work Experience Placement",long_description:"Provide Work Experience Placement Service",system_defined:"FALSE",active:"TRUE")



	end
end











