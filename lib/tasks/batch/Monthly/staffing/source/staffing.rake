
# /****                  PROGRAM DESCRIPTION                                  *
# * For all open TANF program units,due for 6, 12, 18, 22 and 24 month        *
# *  staffing or 42, 48, 54, 58 or 60 review should be determined             *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : FNU keerthana sheri                                    *
# *                                                                           *
# *  DATE OF WRITTEN     : 05-31-2016.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:  TEA count 5, 11, 17, 21 or 23 OR Federal count 41, 47, 53, *
# *                57 or 59 (Applicable only for single and two parent cases )*
# *                * create a work task for case manager,  eligibility worker *
# *                *  create a work task for compliance_office_id             *
# *                                          if sanction present              *
# *                                                                           *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:             NONE                                      *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  NONE                                      *
# *                                                                           *
# *  ERROR FILES,LOG FILES         staffing, log_staffing             *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *****************************************************************************
task :tea_staffing => :environment do
  batch_user = User.where("uid = '555'").first
  AuditModule.set_current_user=(batch_user)
  filename = "batch_results/monthly/tea_staffing/results/staffing" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
  log_filename = "batch_results/monthly/tea_staffing/results/log_staffing" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
  path = File.join(Rails.root, filename)
  log_path = File.join(Rails.root, log_filename)
  # Create new file called 'filename.txt' at a specified path.
  my_file = File.new(path,"w+")
  log_file = File.new(log_path,"w+")
  total_number_of_records  = 0
  task_should_be_created = 0
  task_should_not_be_created = 0
  total_work_task_created_count_planning = 0
  already_work_task_exist_planning = 0
  total_work_task_created_count_assessment = 0
  already_work_task_exist_assessment = 0
  total_fail_in_work_task_creation_count_assessmemt = 0
  total_fail_in_work_task_creation_count_planning = 0
  total_work_task_created_count_sanction = 0
  already_work_task_exist_sanction = 0
  total_fail_in_work_task_creation_count_sanction = 0
  total_work_task_created_count_eligibility = 0
  already_work_task_exist_eligibility = 0
  no_time_limits_present = 0
  total_fail_in_work_task_creation_count_eligibility = 0
  no_primary_contact = 0
  no_adults_present = 0
  sp = 0
  tp = 0
  client_fedreal_count_array = []
  client_tea_state_count_array = []
  client_fedreal_count = nil
  client_tea_count = nil
  final_client_state_count = nil
  final_client_fedral_count = nil
  create_work_task = false

  step1 = ProgramUnit.joins("INNER JOIN PROGRAM_UNIT_PARTICIPATIONS ON (PROGRAM_UNITS.ID=PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID
  AND PROGRAM_UNIT_PARTICIPATIONS.ID = ( SELECT MAX(ID)
                                        FROM PROGRAM_UNIT_PARTICIPATIONS A
                                        WHERE A.PROGRAM_UNIT_ID = PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID)
  AND PROGRAM_UNIT_PARTICIPATIONS.PARTICIPATION_STATUS = 6043
  AND PROGRAM_UNITS.SERVICE_PROGRAM_ID = 1
  AND (PROGRAM_UNITS.CASE_TYPE in (6047,6046))) ")
  step2 = step1.select("PROGRAM_UNITS.*")
  open_program_unit_list = step2
  begin
  if open_program_unit_list.present?
    total_number_of_records  = open_program_unit_list.count
    open_program_unit_list.each do |program_unit|
      # Active adults in a program unit
      adult_age = SystemParam.get_key_value(6,"child_age","18 is the age to determine adult").to_i
      step1 = ProgramUnitMember.joins("INNER JOIN clients
                   ON program_unit_members.client_id = clients.id")
      step2 = step1.where("program_unit_members.program_unit_id = ? and
                           program_unit_members.member_status = 4468 and
                           (clients.dob is null or EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) >= ?)",program_unit.id, adult_age)
      step3 = step2.select("program_unit_members.*")
      pgu_adults_collection = step3
      if program_unit.case_type == 6046 #"Single Parent"
        sp = sp+1
        Rails.logger.debug("pgu_adults_collection = #{pgu_adults_collection.inspect}")
        if (pgu_adults_collection.present? && pgu_adults_collection.class.name != "String")
            time_limit_object =  TimeLimit.get_details_by_client_id(pgu_adults_collection.first.client_id).first
            Rails.logger.debug("time_limit_object = #{time_limit_object.inspect}")
            if (time_limit_object.present? and ([1,12,3,6, 12, 18, 22, 24].include?(time_limit_object.tea_state_count.to_i) or  [1,12,3,42, 48, 54, 58, 60].include?(time_limit_object.federal_count.to_i)))
              create_work_task = true
              task_should_be_created = task_should_be_created + 1
            else
              create_work_task = false
              task_should_not_be_created = task_should_not_be_created + 1
            end
        else
          name = "No adults present to process for program unit = #{program_unit.id}"
          no_adults_present = no_adults_present + 1
          log_file.write(name + "\n")
        end
      elsif program_unit.case_type == 6047 #"Two Parent"
        tp = tp + 1
        Rails.logger.debug("pgu_adults_collection = #{pgu_adults_collection.inspect}")
        if (pgu_adults_collection.present? && pgu_adults_collection.class.name != "String")
            pgu_adults_collection.each do |each_member|
            time_limit_object =  TimeLimit.get_details_by_client_id(each_member.client_id).first
            Rails.logger.debug("time_limit_object = #{time_limit_object.inspect}")
              if time_limit_object.present?
                client_fedreal_count = time_limit_object.federal_count
                client_tea_count = time_limit_object.tea_state_count
              end
              client_fedreal_count_array << client_fedreal_count
              client_tea_state_count_array << client_tea_count
              final_client_state_count = client_tea_state_count_array.max{ |a,b| a.to_i <=> b.to_i }
              final_client_fedral_count = client_fedreal_count_array.max{ |a,b| a.to_i <=> b.to_i }
            end#pgu_adults_collection.each do |each_member|
            if (time_limit_object.present? and ([1,3,12,6, 12, 18, 22, 24].include?(final_client_state_count.to_i) or  [1,3,12,42, 48, 54, 58, 60].include?(final_client_fedral_count.to_i)))
              create_work_task = true
              task_should_be_created = task_should_be_created + 1
            else
              create_work_task = false
              task_should_not_be_created = task_should_not_be_created + 1
            end
        else
          name = "No adults present to process for program unit = #{program_unit.id}"
          no_adults_present = no_adults_present + 1
          log_file.write(name + "\n")
        end#pgu_adults_collection.present?
      end #if program_unit.case_type
      name = "create task #{create_work_task} = #{program_unit.id} "
      my_file.write(name + "\n")
      if create_work_task == true
        begin
          ActiveRecord::Base.transaction do
            if program_unit.present?
              #Eligibility
                primary_contact = PrimaryContact.get_primary_contact(program_unit.id, 6345)
                if primary_contact.present?
                    ls_client_name = Client.get_client_full_name_from_client_id(primary_contact.client_id)
                    action_text = "Determine eligibility for the TEA program unit for: #{ls_client_name}."
                    instructions =  "This is a system created task- TEA program unit is assigned to you. Complete and determine eligibility of the program unit for: #{ls_client_name}"
                    # primary_contact = PrimaryContact.get_primary_contact(program_unit.id, 6345)
                    due_date = Date.today + 7.days
                    work_task_for_case_manager = WorkTask.save_work_task(6785, #arg_task_type = "Case review/staffing - Eligibility determination"
                                                                          6345, #arg_beneficiary_type = program unit
                                                                          program_unit.id, #arg_reference_id = program unit id
                                                                          action_text, #arg_action_text,
                                                                          6342, #arg_assigned_to_type = user
                                                                          program_unit.eligibility_worker_id, #arg_assigned_to_id,
                                                                          batch_user.uid, #arg_assigned_by_user_id = assigned by batch
                                                                          6366, #arg_task_category = client
                                                                          primary_contact.client_id, #arg_client_id,
                                                                          due_date, #arg_due_date = seven days from the day it is run
                                                                          instructions, #arg_instructions,
                                                                          2188, #arg_urgency = High
                                                                          '', #arg_notes,
                                                                          6339, #arg_status = pending
                                                                          program_unit.id)
                    if work_task_for_case_manager == "NEWRECORD"
                      total_work_task_created_count_eligibility = total_work_task_created_count_eligibility + 1
                      name = " client name -  #{ls_client_name}"
                      log_file.write(name + "\n")
                    elsif  work_task_for_case_manager == "SUCCESS"
                      already_work_task_exist_eligibility = already_work_task_exist_eligibility + 1
                      # pending work task already exists - no need to create one more
                    else
                      total_fail_in_work_task_creation_count_eligibility = total_fail_in_work_task_creation_count_eligibility + 1
                      error = "unable to create task to eligibility worker to complete and determine eligibility for Client:#{ls_client_name}"
                      log_file.write(error + "\n")
                    end
                else
                      no_primary_contact= no_primary_contact + 1
                      error = "primary contact is not avaliable for program unit - #{ program_unit.id}"
                      log_file.write(error + "\n")
                end#if primary_contact.present?
              #Assessment
                pgu_adults_collection.each do |each_client_record|
                  ls_client_name = Client.get_client_full_name_from_client_id(each_client_record.client_id)
                  due_date = Date.today + 7.days
                  ls_action_text = "Work on the assessment for client:#{ls_client_name}"
                  ls_instructions = "This is a system created task- program unit:#{program_unit.id} of client:#{ls_client_name} is assigned to you. Complete assessment for the client."
                  work_task_object = WorkTask.save_work_task(6786,#"Case review/staffing - Assessment "
                                                            6510,#arg_beneficiary_type, - client
                                                            each_client_record.client_id,#arg_reference_id,
                                                            ls_action_text,#arg_action_text,
                                                            6342,#arg_assigned_to_type,# user
                                                            program_unit.case_manager_id,#arg_assigned_to_id,
                                                            batch_user.uid,#arg_assigned_by_user_id,
                                                            6366,#arg_task_category, - client
                                                            each_client_record.client_id,#arg_client_id,
                                                            due_date,#arg_due_date,
                                                            ls_instructions,#arg_instructions,
                                                            2188,#arg_urgency,
                                                            '',#arg_notes,
                                                            6339, #arg_status
                                                            program_unit.id)
                  if work_task_object == "NEWRECORD"

                    total_work_task_created_count_assessment = total_work_task_created_count_assessment + 1
                    name = " client name -  #{ls_client_name}"
                    log_file.write(name + "\n")
                  elsif  work_task_object == "SUCCESS"
                    already_work_task_exist_assessment = already_work_task_exist_assessment + 1
                    # pending work task already exists - no need to create one more
                  else
                    total_fail_in_work_task_creation_count_assessmemt = total_fail_in_work_task_creation_count_assessmemt + 1
                    error = "unable to create task to case manager to manage assessment for Client:#{ls_client_name}"
                    log_file.write(error + "\n")
                  end
              # Employment planning
                  ls_client_name = Client.get_client_full_name_from_client_id(each_client_record.client_id)
                  due_date = Date.today + 7.days
                  ls_action_text = "Work on employment planning and CPP for client:#{ls_client_name}."
                  ls_instructions = "This is a system created task- Program unit:#{program_unit.id} of client:#{ls_client_name} is assigned to you. Work on employment planning and CPP for the client."
                  work_task_object = WorkTask.save_work_task(6787,#arg_task_type,
                                                            6510,#arg_beneficiary_type, - client
                                                            each_client_record.client_id,#arg_reference_id,
                                                            ls_action_text,#arg_action_text,
                                                            6342,#arg_assigned_to_type,# user
                                                            program_unit.case_manager_id,#arg_assigned_to_id,
                                                            batch_user.uid,#arg_assigned_by_user_id,
                                                            6366,#arg_task_category, - client
                                                            each_client_record.client_id,#arg_client_id,
                                                            due_date,#arg_due_date,
                                                            ls_instructions,#arg_instructions,
                                                            2188,#arg_urgency,
                                                            '',#arg_notes,
                                                            6339, #arg_status
                                                            program_unit.id)
                  if work_task_object == "NEWRECORD"
                    total_work_task_created_count_planning = total_work_task_created_count_planning + 1
                    name = " client name -  #{ls_client_name}"
                    log_file.write(name + "\n")
                  elsif  work_task_object == "SUCCESS"
                    already_work_task_exist_planning = already_work_task_exist_planning + 1
                    # pending work task already exists - no need to create one more
                  else
                    total_fail_in_work_task_creation_count_planning = total_fail_in_work_task_creation_count_planning + 1
                    error = "unable to create task to case manager to manage employment planning Client:#{ls_client_name}"
                    log_file.write(error + "\n")
                  end
              #sanction
                compliance_office_for_sanction = Sanction.where("client_id = ? and compliance_office_id is not null ", each_client_record.client_id )
                  if compliance_office_for_sanction.present?
                    compliance_office_for_sanction.each do |sanction|
                      sanction_queue_for_client = WorkQueue.where("state = 6642 and reference_type = 6367 and reference_id = ? ", sanction.id )
                      if sanction_queue_for_client.present?
                      due_date = Date.today + 7.days
                      ls_client_name = Client.get_client_full_name_from_client_id(each_client_record.client_id)
                      ls_action_text = "Work on sanctions for client:#{ls_client_name}"
                      ls_instructions = "This is a system generated task to work on sanction for client: #{ls_client_name}. Review the client details and check if sanctions is needed for the client"
                      work_task_object = WorkTask.save_work_task(6788,#arg_task_type - "Case review/staffing - Sanction",
                                                                  6367,#arg_beneficiary_type, - Sanction
                                                                  sanction.id,#arg_reference_id,
                                                                  ls_action_text,#arg_action_text,
                                                                  6342,#arg_assigned_to_type,# User
                                                                  sanction.compliance_office_id,#arg_assigned_to_id,
                                                                  batch_user.uid,#arg_assigned_by_user_id,
                                                                  6366,#arg_task_category, - client
                                                                  sanction.client_id,#arg_client_id,
                                                                  due_date,#arg_due_date,
                                                                  ls_instructions,#arg_instructions,
                                                                  2188,#arg_urgency,
                                                                  '',#arg_notes,
                                                                  6339, #arg_status
                                                                  program_unit.id)
                      if work_task_object == "NEWRECORD"
                        total_work_task_created_count_sanction = total_work_task_created_count_sanction + 1
                        name = " client name -  #{ls_client_name}"
                        my_file.write(name + "\n")
                      elsif  work_task_object == "SUCCESS"
                        already_work_task_exist_sanction = already_work_task_exist_sanction + 1
                        # pending work task already exists - no need to create one more
                      else
                        total_fail_in_work_task_creation_count_sanction = total_fail_in_work_task_creation_count_sanction + 1
                        error = "unable to create task to case manager to manage sanctions for Client:#{ls_client_name}"
                        log_file.write(error + "\n")
                      end
                    end#if sanction_queue_for_client.present?
                  end#compliance_office_for_sanction.each do |sanction|
                end#if compliance_office_for_sanction.present?
                end#pgu_adults_collection.each do |each_client_record|
              # end#if active_adult_members.class.name != "String"
            end#program_unit
          end#ActiveRecord::Base.transaction do
            rescue => err
              error_object = CommonUtil.write_to_attop_error_log_table("Staffing batch program","Batch",err,AuditModule.get_current_user.uid)
        end #begin
      end#create_work_task == true
    end #open_program_unit_list.each do |program_unit|
  else
    name = "No open tea cases to process "
    log_file.write(name + "\n")
  end #open_program_unit_list.present?
    rescue => err
      error_object = CommonUtil.write_to_attop_error_log_table("Staffing batch program","Batch",err,AuditModule.get_current_user.uid)
  end


  log_file.puts("================================================")
  log_file.write("Total record present = " + total_number_of_records.to_s + "\n")
  log_file.write("Total single parent case = " + sp.to_s + "\n")
  log_file.write("Total two parent case = " + tp.to_s + "\n")
  log_file.puts("================================================")
  log_file.write("Total count of tea case task is required = " + task_should_be_created.to_s + "\n")
  log_file.write("Total count of tea cases task is not required  = " + task_should_not_be_created.to_s + "\n")
  log_file.puts("================================================")
  log_file.write("Time limits not present = " + no_time_limits_present.to_s + "\n")
  log_file.write("Total tea case no adult present = " + no_adults_present.to_s + "\n")
  log_file.write("No primary contact present  = " +no_primary_contact.to_s + "\n")
  log_file.puts("================================================")
  log_file.write("Total work task created for planning = " + total_work_task_created_count_planning.to_s + "\n")
  log_file.write("Total records planning work tasks exists = " + already_work_task_exist_planning.to_s + "\n")
  log_file.write("Total work task failed count for planning = " + total_fail_in_work_task_creation_count_planning.to_s + "\n")
  log_file.puts("================================================")
  log_file.write("Total work task created for assessment = " + total_work_task_created_count_assessment.to_s + "\n")
  log_file.write("Total records assessment work tasks exists = " + already_work_task_exist_assessment.to_s + "\n")
  log_file.write("Total work task failed count for assessment = " + total_fail_in_work_task_creation_count_assessmemt.to_s + "\n")
  log_file.puts("================================================")
  log_file.write("Total work task created for sanction = " + total_work_task_created_count_sanction.to_s + "\n")
  log_file.write("Total records sanction work tasks exists = " + already_work_task_exist_sanction.to_s + "\n")
  log_file.write("Total work task failed count for sanction = " + total_fail_in_work_task_creation_count_sanction.to_s + "\n")
  log_file.puts("================================================")
  log_file.write("Total work task created for eligibility = " + total_work_task_created_count_eligibility.to_s + "\n")
  log_file.write("Total records eligibility work tasks exists = " + already_work_task_exist_eligibility.to_s + "\n")
  log_file.write("Total work task failed count for eligibility = " +total_fail_in_work_task_creation_count_eligibility.to_s + "\n")
  log_file.puts("====================END============================")

  my_file.close
  log_file.close
end
