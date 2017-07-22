namespace :populate_codetable236 do
	desc "populate_codetable236"
	task :populate_codetable236 => :environment do
		CodetableItem.where("id = 6387").update_all(short_description:'Complete Work Readiness Assessment',long_description:'Complete work readiness Assessment')
	end
end


