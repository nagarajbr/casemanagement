namespace :notice_text_creation_for_sanction do
	desc "notice text creation for sanction recommendation "
	task :notice_text_creation_for_sanction => :environment do

		NoticeText.create(service_program_id:1, action_type: 6719, action_reason: 6720,flag1:"TRUE",flag2:"TRUE", notice_text:"Your are Potentially eligible for sanction",created_by:19,updated_by:19)
        NoticeText.create(service_program_id:4, action_type: 6719, action_reason: 6720,flag1:"TRUE",flag2:"TRUE", notice_text:"Your are Potentially eligible for sanction",created_by:19,updated_by:19)
	end
end