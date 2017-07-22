namespace :populate_codetable284 do
	desc "adding service leading to core or non core federal component"
	task :adding_service_leading_to_core_or_non_core_federal_component => :environment do
		CodetableItem.create(code_table_id:182,short_description:"Career and Technical Education",long_description:"Career and Technical Education",system_defined:"FALSE",active:"TRUE")
	end
end