namespace :populate_codetable286 do
desc "Drug Screening Questions"
task :drug_screening_questions => :environment do
	code_table = CodeTable.create(name:"Drug Screening Questions",description:"Drug Screening Questions")
	codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"In the past 30 days have you used any illegal drugs?",long_description:"In the past 30 days have you used any illegal drugs?",system_defined:"FALSE",active:"TRUE")
	codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"In the past 30 days have you lost or been denied a job due to current illegal drug use?",long_description:"In the past 30 days have you lost or been denied a job due to current illegal drug use?",system_defined:"FALSE",active:"TRUE")
	codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"In the past 30 days have you recently had legal trouble due to current illegal drug use?",long_description:"In the past 30 days have you recently had legal trouble due to current illegal drug use?",system_defined:"FALSE",active:"TRUE")
	end
end
