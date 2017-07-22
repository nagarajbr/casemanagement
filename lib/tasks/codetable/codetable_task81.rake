namespace :populate_codetable81 do
	desc "update_Address_Type"
	task :update_address_type => :environment do
		CodetableItem.where(id: 4664).update_all(short_description:"Physical", long_description:"Physical")
		CodetableItem.where(id: 5769).update_all(short_description:"Prior Physical", long_description:"Prior Physical")
	end
end

