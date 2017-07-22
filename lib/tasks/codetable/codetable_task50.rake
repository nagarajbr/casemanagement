namespace :populate_codetable50 do
	desc "cleanup task -program unit group"
	task :delete_update_program_group => :environment do
		# Manoj 10/21/2014


		CodetableItem.where("id = 6016 and code_table_id = 126").destroy_all
		CodetableItem.where("id = 6015 and code_table_id = 126").update_all(short_description:"TANF")
		ServiceProgram.where("id in (1,3,4)").update_all(svc_pgm_category: 6015)
		ServiceProgram.where("id = 2").destroy_all


	end
end