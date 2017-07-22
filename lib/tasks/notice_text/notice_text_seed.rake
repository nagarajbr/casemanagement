namespace :notice_text_seed do
	desc "Notice text creation for generating notice"
	task :notice_text_seed => :environment do
	  Rake::Task["notice_text_creation_task:notice_text_insert_task"].invoke
      Rake::Task["notice_text_update_task:notice_text_update_task"].invoke
      Rake::Task["notice_text_creation_for_sanction:notice_text_creation_for_sanction"].invoke

	end
end