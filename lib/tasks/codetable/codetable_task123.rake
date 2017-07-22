namespace :populate_codetable123 do
	desc "work characteristics changes"
	task :work_characteristics_changes => :environment do
			# -cancel payment - 5930
			CodetableItem.where("id = 5930").destroy_all
			 # Duplicate payment - 5932
			CodetableItem.where("id = 5932").destroy_all
			# Return Payment - 5931
			CodetableItem.where("id = 5931").destroy_all
			# Tea second parent mandatory - 5672
			CodetableItem.where("id = 5672").destroy_all
			# D- Tea work activity sanction - 5718
			CodetableItem.where("id = 5718").destroy_all
			# changed - Manadatory - TEA  = Mandatory
			CodetableItem.where("id = 5667").update_all(short_description:"Mandatory", long_description:"Mandatory")

    end
end