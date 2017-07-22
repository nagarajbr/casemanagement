namespace :populate_codetable98 do
	desc "core_activity_types"
	task :core_activity_types => :environment do
		code_table = CodeTable.create(name:"Core Activity Types",description:"Core Activity Types")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"AJS-Assisted Job Search ",long_description:"AJS-Assisted Job Search ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"ESL-English As 2nd Lang",long_description:"ESL-English As 2nd Language",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Job Search and Job Readiness (Core)",long_description:"ob Search and Job Readiness (Core) -AJ,JC ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"On the Job Training(Core)",long_description:"On the Job Training-OJ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Career and Technical Education (Core) ",long_description:"Vocation Ed Training-VO ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Work Experience (Core)",long_description:"Work Experience -WE",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Subsidized Private Employment(Core)",long_description:"Subsidized Private Employment-SP",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Subsidized Public Employment(Core)",long_description:"Subsidized Public Employment-SU",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Unsubsidized Employment(Core)",long_description:"Unsubsidized Employment-UN,ME ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Community Service(Core)",long_description:"Community Service-CO",system_defined:"FALSE",active:"TRUE")
	end
end

