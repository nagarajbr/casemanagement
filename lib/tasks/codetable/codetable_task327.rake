namespace :populate_codetable327 do
	desc "adding_activity_type"
	task :adding_activity_type  => :environment do
		CodetableItem.create(code_table_id:181,short_description:"Job Readiness",long_description:"Job Readiness",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:173,short_description:"Job Readiness(Core)",long_description:"Job Readiness(Core)",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:182,short_description:"Participate in GED certification",long_description:"Participate in GED certification",system_defined:"FALSE",active:"TRUE")
	end
end