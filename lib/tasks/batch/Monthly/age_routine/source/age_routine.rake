
# /****                  PROGRAM DESCRIPTION                                  *
# * For all open TANF program units, if any eligible children turn 18 in the  *
# * month of age routine execution, should be made ineligible.                *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *                                                                           *
# *  DATE OF WRITTEN     : 10-21-2015.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:              Select all active members who turn 18 in given month*
# *                            and make them inactive in that program unit and*
# *                            Write a night batch record for ed              *
# *                                                                           *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:             NONE                                      *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  NONE                                      *
# *                                                                           *
# *  ERROR FILES,LOG FILES         age_routine_, log_age_routine_             *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *****************************************************************************
task :age_routine => :environment do
batch_user = User.where("uid = '555'").first
AuditModule.set_current_user=(batch_user)
filename = "batch_results/monthly/age_routine/results/age_routine_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
log_filename = "batch_results/monthly/age_routine/results/log_age_routine_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
path = File.join(Rails.root, filename)
log_path = File.join(Rails.root, log_filename)
# Create new file called 'filename.txt' at a specified path.
my_file = File.new(path,"w+")
log_file = File.new(log_path,"w+")

total_clients_extracted_count = 0
program_unit_processed_count = 0
program_unit_process_fail_count = 0
member_status_processed_count = 0

age_routine_collection = Client.get_clients_age_routine
total_clients_extracted_count = age_routine_collection.length
#total_clients_extracted_count = program_unit_processed_count + program_unit_process_fail_count
age_routine_collection.each do |age|
child_name = Client.get_client_full_name_from_client_id(age.id)
begin
  ActiveRecord::Base.transaction do
    program_unit_member_object = ProgramUnitMember.where("client_id = ?",age.id).first
    program_unit_member_object.member_status = 4471
    program_unit_member_object.save!
    member_status_processed_count = member_status_processed_count + 1
    # program_unit_member_object = program_unit_member_object.update_attribute!(:member_status, 4470)
    next_month = (Date.today + 1.month).beginning_of_month #1st day of month

    if program_unit_member_object.present?
        night_batch = NightlyBatchProcess.new
        night_batch.entity_type = 6524
        night_batch.entity_id = age.program_unit_id
        night_batch.process_type = 6526
        night_batch.reason = 6638
        night_batch.client_id = age.id
        night_batch.submit_flag = "Y"
        night_batch.run_month = next_month
        night_batch_record = NightlyBatchProcess.where("entity_type = 6524 and
                                                    entity_id = ? and
                                                    process_type = 6526 and
                                                    reason = 6638 and
                                                    client_id = ? and
                                                    processed = 'N' and
                                                    run_month = ?",
                                                    age.program_unit_id,age.id, next_month)
        if night_batch_record.blank?
            night_batch.save!
            program_unit_processed_count = program_unit_processed_count + 1
            name = "( client id -#{age.id},#{child_name}),Date of birth -#{age.dob}, program unit - #{age.program_unit_id}\n"
            my_file.write(name)
        else

        end


    else
        program_unit_process_fail_count = program_unit_process_fail_count + 1
        error = "This client details failed while updating: #{age.id} for client #{child_name} "
        log_file.write(error)
    end


  end
end
    # program_unit_member_object = ProgramUnitMember.where("client_id = ?",age.id).update_all("member_status = 4470")





end
my_file.write("Total clients processed = " + total_clients_extracted_count.to_s + "\n")
my_file.write("Total record inserted into nightly batch = " + program_unit_processed_count.to_s + "\n")
my_file.write("Total record updated member status to inactive = " + member_status_processed_count.to_s + "\n")
my_file.write("Total failed program units = " + program_unit_process_fail_count.to_s + "\n")

# Close the file.
my_file.close
log_file.close
end
