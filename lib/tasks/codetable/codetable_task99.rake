namespace :populate_codetable99 do
	desc "non_core_activity_types"
	task :non_core_activity_types => :environment do
		code_table = CodeTable.create(name:"Non Core Activity Types",description:"Non Core Activity Types")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"EDS-Post Sec 2/4 yr college",long_description:"EDS-Post Secondary 2/4 year college ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Attendance at Secondary School (Non-core)",long_description:"GED-High School/GED -(ES)(GE)",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Micro-Enterprise",long_description:"Micro-Enterprise",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"WtW/JTPA Referral",long_description:"WtW/JTPA Referral",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Job Skills Training(Non Core)",long_description:"Job Skills Training - JS",system_defined:"FALSE",active:"TRUE")


	end
end

