# Author : Vishal Deep
#  Date 06/18/2015
namespace :populate_codetable165 do
	desc "Added new Denial Reason - ACES - Non Rule Related "
	task :added_denia_reasons_aces_1 => :environment do
		# Add data
		CodetableItem.create(code_table_id:66,short_description:"Apply/Accept Income",long_description:"",system_defined:"TRUE",active:"TRUE")

	end
end