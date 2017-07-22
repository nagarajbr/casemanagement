namespace :populate_codetable133 do
	desc "Ruby Element Types"
	task :add_ruby_element_types => :environment do
		code_table = CodeTable.create(name:"Ruby Element Types",description:"Ruby Elements table is used to create table driven menus and buttons - Element Types van be Menu/Button")
		CodetableItem.create(code_table_id:code_table.id,short_description:"Menu",long_description:"Menu",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table.id,short_description:"Button",long_description:"Button",system_defined:"FALSE",active:"TRUE")
	end
end