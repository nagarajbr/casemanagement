namespace :populate_codetable107 do
	desc "Duplicate Member status deleted"
	task :duplicate_member_status_delete  => :environment do
		CodetableItem.where("id = 5870 and code_table_id = 84").destroy_all
		CodetableItem.where("id = 5869 and code_table_id = 84").destroy_all
		# duplicate component deleted.-AJS - "AJS-Assisted Job Search "
		CodetableItem.where("id = 6236 and code_table_id = 173").destroy_all
		# ESL -"ESL-English As 2nd Lang"
		CodetableItem.where("id = 6237 and code_table_id = 173").destroy_all

		# Micro-Enterprise
		CodetableItem.where("id = 6248 and code_table_id = 174").destroy_all
		# "WtW/JTPA Referral"
		CodetableItem.where("id = 6249 and code_table_id = 174").destroy_all
		# "EDS-Post Sec 2/4 yr college"
		CodetableItem.where("id = 6246 and code_table_id = 174").destroy_all




	end
end