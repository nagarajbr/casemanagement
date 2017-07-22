namespace :populate_codetable290 do
	desc "updating service leading to core or non core federal component"
	task :updating_service_leading_to_core_or_non_core_federal_component => :environment do
		CodetableItem.where("id=6722").update_all(short_description:"Health Information Certificate",long_description:"Health Information Certificate")
	end
end