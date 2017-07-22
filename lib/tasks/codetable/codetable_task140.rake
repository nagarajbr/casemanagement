namespace :populate_codetable140 do
	desc "delete Supportive Service -since moved to Service"
	task :delete_ss => :environment do
		# These are added as Services , so deleted from supportive services
		#  6218;168;"Vehicle Insurance "
# 6219;168;"Vehicle Repairs "
# 6220;168;"Vehicle Down Payment "
# 6221;168;"Vehicle Tax/License "

		CodetableItem.where("code_table_id = 168 and id in (6218,6219,6220,6221)").destroy_all



    end
end