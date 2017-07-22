namespace :populate_codetable186 do
	desc "notes types"
	task :add_notes_type => :environment do
		CodetableItem.create(code_table_id:131,short_description:"IncomeDetail",long_description:"IncomeDetail",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:131,short_description:"ExpenseDetail",long_description:"ExpenseDetail",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:131,short_description:"Provider",long_description:"Provider",system_defined:"TRUE",active:"TRUE")
	end
end