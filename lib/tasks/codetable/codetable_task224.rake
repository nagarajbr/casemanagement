namespace :populate_codetable224 do
	desc "adding ebt reasons"
	task :adding_ebt_reasons => :environment do
		code_table_object = CodeTable.create(name:"EBT Reasons",description:"EBT Reasons")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Adding Program Unit representative",long_description:"Adding Program Unit representative",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Deactivating Program Unit Representative",long_description:"Deactivating Program Unit Representative",system_defined:"TRUE",active:"TRUE")
	end
end