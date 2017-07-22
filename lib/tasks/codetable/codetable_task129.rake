namespace :populate_codetable129 do
	desc "addition beneficiary type in work task"
	task :additional_beneficiary_type => :environment do

		CodetableItem.create(code_table_id:162,short_description:"Program Unit",long_description:"Program Unit",system_defined:"TRUE",active:"TRUE")

    end
end