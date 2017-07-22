namespace :notice_text_update_task do
	desc "notice text update action_type "
	task :notice_text_update_task => :environment do


		NoticeText.where("action_type = 6041").update_all(action_type: 6099)#deny
		NoticeText.where("action_type = 6044").update_all(action_type: 6100)#close


	end
end