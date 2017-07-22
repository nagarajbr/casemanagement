namespace :populate_codetable146 do
	desc "ruby element type field "
	task :ruby_type_field => :environment do
		CodetableItem.create(code_table_id:188,short_description:"Field",long_description:"Field",system_defined:"FALSE",active:"TRUE")
    end
end