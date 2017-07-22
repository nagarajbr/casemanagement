namespace :populate_codetable116 do
	desc "Actions,Services and Supportive Service update"
	task :action_s_ss_cleanup => :environment do

		# Action
		CodetableItem.where("code_table_id = 181 and id = 6280").destroy_all
		CodetableItem.where("code_table_id = 181 and id = 6281").destroy_all
		CodetableItem.where("code_table_id = 181 and id = 6282").destroy_all
		# Delete these as action as these are paid services by provider
		#6280	Participate in Advanced Degree Program
		# 6281	Participate in Bachelor's Degree Program
		# 6282	Participate in Two-year Degree Program

		# System Param
		SystemParam.where("system_param_categories_id = 16 and key = '6288'").destroy_all

		# Service
		CodetableItem.where("code_table_id = 182 and id = 6288").destroy_all
		# Removing Participate in High School/GED Certificate Program - since it is action with no payment for provider.

		# Supportive Service
		CodetableItem.where("code_table_id = 168 and id = 6214").destroy_all
		# Deleting Transportation paid to client - since transportation service is paid service - paid only to registered provider.
		CodetableItem.where("code_table_id = 168 and id = 6215").update_all(short_description:'Transportation',long_description:'Transportation')

	end
end





