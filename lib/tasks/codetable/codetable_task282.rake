namespace :populate_codetable282 do
desc "Other notice reasons"
task :other_notice_reasons => :environment do
code_table = CodeTable.create(name:"Other notice reasons",description:"Other notice reasons to generate notice")
codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Other",long_description:"Other reason for notice generation",system_defined:"FALSE",active:"TRUE")
codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Sanction Recommended",long_description:"Sanction Recommended",system_defined:"FALSE",active:"TRUE")
end
end
