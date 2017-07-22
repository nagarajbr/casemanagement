namespace :delete_re_eval_queue_in_sit do
	desc "delete_re_eval_queue_in_sit"
	task :delete_re_eval_queue_in_sit => :environment do


		CodetableItem.where("code_table_id = 196 and id in (6567,6615)").destroy_all

	end
end