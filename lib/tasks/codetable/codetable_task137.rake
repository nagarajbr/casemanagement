namespace :populate_codetable137 do
	desc "legal client characteristics"
	task :update_to_legalCharacteristic => :environment do
		CodetableItem.where("id in (5614,6331,6332,5612,5611,5616)").update_all(type:"LegalCharacteristic")

    end
end