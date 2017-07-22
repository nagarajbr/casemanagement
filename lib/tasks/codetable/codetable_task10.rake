namespace :codetable_task10 do
	desc "prior_address_type"
	task :prior_address_type => :environment do
		CodetableItem.where(id: 4666).update_all(short_description:"Prior Mailing", long_description:"Prior Mailing")
		CodetableItem.create(code_table_id: 103,short_description:"Prior Residence",long_description:"Prior Residence",system_defined:"TRUE",active:"TRUE")
	end
end