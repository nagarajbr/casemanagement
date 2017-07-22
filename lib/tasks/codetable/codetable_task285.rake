namespace :populate_codetable285 do
	desc "update school type"
	task :update_school_type => :environment do
		CodetableItem.where("id = 6655").update_all(type: "SchoolName" , parent_id: 2199 , parent_type: "CodetableItem")
		CodetableItem.where("id in (2219,2218,2217,2216,2215)").update_all(type: "SchoolName" , parent_id: 2192 , parent_type: "CodetableItem")
		CodetableItem.where("id in (2222,2221,2220)").update_all(type: "SchoolName" , parent_id: 2193 , parent_type: "CodetableItem")
		CodetableItem.where("id in(2223,2224)").update_all(type: "SchoolName" , parent_id: 2200 , parent_type: "CodetableItem")
		CodetableItem.where("id in (2226,2225)").update_all(type: "SchoolName" , parent_id: 2194 , parent_type: "CodetableItem")
	end
end