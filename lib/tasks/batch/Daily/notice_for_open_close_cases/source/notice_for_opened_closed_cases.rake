require "#{Rails.root}/app/pdfs/core/fillable_pdf_form.rb"
require "#{Rails.root}/lib/tasks/notices/daily/daily_action/source/tea1.rb"

task :notice_for_opened_or_closed_cases => :environment do


 filename = "lib/tasks/batch/Daily/notice_for_open_close_cases/notice" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
 error_filename = "lib/tasks/batch/Daily/notice_for_open_close_cases/notice_error_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
 path = File.join(Rails.root, filename)
 error_path = File.join(Rails.root, error_filename )

puts path
# Create new file called 'filename.txt' at a specified path.
my_file = File.new(path,"w+")
error_file = File.new(error_path,"w+")

	application_opened_or_closed = ProgramUnitParticipation.get_application_opened_or_closed
	#ProgramBenefitMember.update_member_status
	 if application_opened_or_closed.present?
       application_opened_or_closed.each do |application|
         record = NoticeText.where("action_type = ? and action_reason = ? ",application.status,application.reason)
         if record.present?
         	# client_name  = ProgramUnit.get_clients_name_from_program_unit_id(application.id)
         	# client_name.each do |client|
	           	name = "#{application.first_name}, #{application.last_name}, #{application.id } \n"
		        my_file.write(name)
		        output_path = "#{Rails.root}/lib/tasks/notices/daily/daily_action/generated_queue/#{application.first_name} #{ CodetableItem.get_short_description(application.status) }  #{application.reason} #{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" +".pdf"
	            # Rails.logger.debug("application_denied")
	            Tea1.new(application).export(output_path)
	        # end
        else
	         error_name = "#{application.first_name},#{application.last_name},#{application.id } \n"
	         error_file.write(error_name)
        end
       end
     end
    clients_denied = ProgramUnit.get_clients_denied
	#ProgramBenefitMember.update_member_status
	 if clients_denied.present?
       clients_denied.each do |application|
         record = NoticeText.where("action_type = ? and action_reason = ? ",application.status,application.reason)
         if record.present?
   	           	name = "#{application.first_name}, #{application.last_name}, #{application.id } \n"
		        my_file.write(name)
		        output_path = "#{Rails.root}/lib/tasks/notices/daily/daily_action/generated_queue/#{application.first_name}#{ CodetableItem.get_short_description(application.status) } #{application.reason} #{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" +".pdf"
	            # Rails.logger.debug("application_denied")
	            Tea1.new(application).export(output_path)
	        # end
        else
	         error_name = "#{application.first_name},#{application.last_name},#{application.id } \n"
	         error_file.write(error_name)
        end
       end
     end







# Close the file.
my_file.close
end

