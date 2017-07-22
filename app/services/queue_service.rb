class QueueService

	def self.create_queue(arg_object,arg_event_to_action_mapping_object)
	    QueueService.process_request_to_save_record_into_queue(arg_object,arg_event_to_action_mapping_object)
	end

  def self.delete_queue(arg_object,arg_event_to_action_mapping_object)
    QueueService.process_request_to_delete_record_from_queue(arg_object,arg_event_to_action_mapping_object)
  end

  def self.process_request_to_delete_record_from_queue(arg_object,arg_event_to_action_mapping_object)

      li_queue_type = arg_event_to_action_mapping_object.queue_type
      li_reference_type =  arg_object.queue_reference_type
      li_reference_id = arg_object.queue_reference_id
      # case li_queue_type
      #   when 6642 # "sanction queue"
      #     work_queues = WorkQueue.where("state = ? and reference_type = ? and reference_id = ?",li_queue_type,li_reference_type,li_reference_id)
      #     if work_queues.present?
      #       work_queue = work_queues.first
      #       work_queue.destroy!
      #     end
      #   when 6653  #"FMS payment release queue"
      #     work_queues = WorkQueue.where("state = ? and reference_type = ? and reference_id = ?",li_queue_type,li_reference_type,li_reference_id)
      #     if work_queues.present?
      #       work_queue = work_queues.first
      #       work_queue.destroy!
      #     end
      #   when 6616  #"Active Program Units queue"
      #     work_queues = WorkQueue.where("state = ? and reference_type = ? and reference_id = ?",li_queue_type,li_reference_type,li_reference_id)
      #     if work_queues.present?
      #       work_queue = work_queues.first
      #       work_queue.destroy!
      #     end
      # end
      # if li_queue_type == 6735
      #   if arg_object.selected_app_action.present? && arg_object.selected_app_action == 6018 # "Rejected"
      #     work_queues = WorkQueue.where("state in (6735,6557) and reference_type = ? and reference_id = ?",li_reference_type,li_reference_id)
      #   end
      # else
      #   work_queues = WorkQueue.where("state = ? and reference_type = ? and reference_id = ?",li_queue_type,li_reference_type,li_reference_id)
      # end

      # MANOJ 04/25/2016
      # if reference_type and reference_ID found remove from the queue.
       work_queues = WorkQueue.where("reference_type = ? and reference_id = ?",li_reference_type,li_reference_id)
      if work_queues.present?
        work_queue = work_queues.first
        work_queue.destroy!
      end
  end

	def self.process_request_to_save_record_into_queue(arg_object,arg_event_to_action_mapping_object)
#     6557;196;"Application Screening"
# 6558;196;"Ready for Eligibility Determination"
# 6559;196;"Ready for Work Readiness Assessment"
# 6560;196;"Ready for Employment Readiness planning"
# 6637;196;"Ready for Career Pathway Planning Approval"
# 6562;196;"Ready for Program Unit Activation"
# 6616;196;"Active Program Units"


    	li_queue_type = arg_event_to_action_mapping_object.queue_type
    	li_reference_type =  arg_object.queue_reference_type
    	li_reference_id = arg_object.queue_reference_id
      case li_queue_type
        when 6735 # "Applications Queue"
           if WorkQueue.is_queue_record_needed?(li_queue_type,li_reference_type,li_reference_id) == true
            li_worker_id = arg_object.queue_worker_id
            queue_object = WorkQueue.new
            queue_object.reference_type = li_reference_type
            queue_object.reference_id = li_reference_id
            queue_object.state = li_queue_type
            QueueService.process_application_queue(queue_object,li_reference_id,li_worker_id)
          end
        when 6557
          #1."Ready for Application Processing"
          # if WorkQueue.is_queue_record_needed?(li_queue_type,li_reference_type,li_reference_id) == true
          #   li_worker_id = arg_object.queue_worker_id
          #   queue_object = WorkQueue.new
          #   queue_object.reference_type = li_reference_type
          #   queue_object.reference_id = li_reference_id
          #   queue_object.state = 6557
          #   QueueService.process_application_queue(queue_object,li_reference_id,li_worker_id)
          # end

          # if arg_object.selected_app_action.present? && arg_object.selected_app_action == 6017
            queue_collection = WorkQueue.where("state = 6735 and reference_type = 6587 and reference_id = ?",li_reference_id)
            # Rails.logger.debug("queue_collection ED queue = #{queue_collection.inspect}")
            if queue_collection.present?
                # queue_object = WorkQueue.set_queue_object(li_queue_type,li_reference_type,li_reference_id)
                queue_object = queue_collection.first
                queue_object.reference_type = li_reference_type
                queue_object.reference_id = li_reference_id
                # Rails.logger.debug("queue_object ED queue = #{queue_object.inspect}")
                # Call the STATE MACHINE method
                begin
                  lb_saved = queue_object.move_from_application_queue_to_ready_for_application_processing_queue
                  if lb_saved == false
                      raise "error"
                  end
                rescue => err
                  error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
                end
            # else
            #   begin
            #     raise "error"
            #   rescue => err
            #     error_object = CommonUtil.write_to_attop_error_log_table("QueueService","Missing initial queue for the application-#{li_reference_id}",err,AuditModule.get_current_user.uid)
            #   end
            end
          # end

        when 6558
          # manage code to push to queue - "Ready for Eligibility Determination" QUEUE
          # handle TEA diversion rejection first
          # when TEA DIVERSION IS REJECTED - PGU should move from "Ready for Program Unit Activation" to "Ready for Eligibility Determination"

          if arg_object.event_id == 737 #&& arg_object.reason.present?
                if li_reference_type == 6345
                  # reference type - 6345 (program unit) then reference id = program unit
                  program_unit = ProgramUnit.find(li_reference_id)
                  if program_unit.service_program_id == 3
                    # TEA DIVERSION
                    queue_collection = WorkQueue.where("state = 6562 and reference_type = 6345 and reference_id = ?",li_reference_id)
                    if queue_collection.present?
                      queue_object = queue_collection.first
                       begin

                          lb_saved = queue_object.move_from_ready_for_program_unit_activation_to_ready_for_eligibility_determination_queue
                           # Change the program unit status to request
                          if lb_saved == false
                              raise "error"
                          end
                      rescue => err
                              error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
                      end
                    end # end of queue_collection.present?
                  end # end of program_unit.service_program_id == 3
                end # end of li_reference_type == 6345
                # No need to proceed any further - hence return
                # return
          else
              # Application screening last step - button event - pushes PGU into Ready for ED queue -6558

              #2. "Determine Eligibility Queue"
              # Description: Update work_queues table - with reference_type = 'program_unit' and reference_id = <> where previous state should be Application queue.
                # Rails.logger.debug("arg_object ED queue = #{arg_object.inspect}")
                # Rails.logger.debug("arg_event_to_action_mapping_object ED queue = #{arg_event_to_action_mapping_object.inspect}")
                li_application_id = arg_object.client_application_id
                queue_collection = WorkQueue.where("reference_id = ? and reference_type = 6345",li_reference_id)
                # Rails.logger.debug("queue_collection ED queue = #{queue_collection.inspect}")
                if queue_collection.present? && li_reference_type == 6345
                  queue_object = queue_collection.first
                    # if queue_object.state != 6558
                      begin
                        task_type = SystemParam.get_key_value(28,queue_object.state.to_s,"Get task type").to_i
                        # if we are reusing an existing pgu, then move the pgu from any queue state to ed queue and delete the pending tasks associated with current queue
                        # lb_saved = queue_object.move_program_unit_to_ready_for_ed_queue
                        WorkTask.delete_any_pending_work_tasks(li_reference_id, task_type)# if lb_saved
                        # if we are reusing an existing pgu delete the newly created applications from the application queues
                        queue_collection = WorkQueue.where("reference_type = 6587 and reference_id = ?",li_application_id)
                        if queue_collection.present?
                          queue_collection.destroy_all
                        end
                        # if lb_saved == false
                        #     raise "error"
                        # end
                      rescue => err
                        error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
                      end
                    # end

                else
                  # if reference type is application look for application in aplication processing queue and  move it to ED queue
                  # if reference_id is program unit look for application in ED queue
                  state = li_reference_type == 6345 ? 6558 : 6557
                  queue_collection = WorkQueue.where("state = ? and reference_type = 6587 and reference_id = ?",state, li_application_id)
                  if queue_collection.present?
                    queue_object = queue_collection.first
                    queue_object.reference_type = li_reference_type
                    queue_object.reference_id = li_reference_id
                    # Rails.logger.debug("queue_object ED queue = #{queue_object.inspect}")
                    # Call the STATE MACHINE method
                    if state == 6557
                      begin
                        lb_saved = queue_object.move_from_application_processing_queue_to_ready_for_eligibility_determination
                        # Rails.logger.debug("lb_saved ED queue = #{lb_saved}")
                        if lb_saved == false
                            raise "error"
                        end
                      rescue => err
                        error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
                      end
                    else
                      queue_object.save!
                    end
                  elsif li_reference_type == 6345
                    queue_object = WorkQueue.new
                    queue_object.reference_type = li_reference_type # 6345
                    queue_object.reference_id = li_reference_id # pgu_id
                    queue_object.state = 6558
                    queue_object.save!
                  end
                end

          end # end of arg_object.event_id == 737
        when 6559
          # Complete ED button pushes the PGU into REady for Assessment
          # "Assessment Queue"
          # PGU is moved from ED Queue to Assessment Queue
          program_unit = ProgramUnit.find(li_reference_id)
          queue_collection = WorkQueue.where("state = 6558 and reference_type = 6345 and reference_id = ?",li_reference_id)
          if queue_collection.present?
            queue_object = queue_collection.first
            if program_unit.case_type == 6048 || program_unit.service_program_id == 3
              # CHILD ONLY CASE & TEA DIVERSION
              begin
                    lb_program_unit_open_status = ProgramUnitParticipation.is_program_unit_participation_status_open(arg_object.program_unit_id)
                      if lb_program_unit_open_status == true
                        #when ed complete for child only  
                        lb_saved = queue_object.move_from_ready_for_eligibility_determination_queue_to_open_program_unit_queue
                      else
                        lb_saved = queue_object.move_from_ready_for_eligibility_determination_queue_to_ready_for_Program_unit_activation
                        # Change the program unit status to request
                        if lb_saved == false
                            raise "error"
                        end
                        # update the PGU state to requested
                        program_unit.state = 6165
                        lb_saved = program_unit.request
                        if lb_saved == false
                            raise "error"
                        end
                      end
              rescue => err
                      error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
              end
            else
              # NON CHILD ONLY CASE TYPE AND TEA DIVERSION
              begin
                    lb_saved = queue_object.move_from_ready_for_eligibility_determination_queue_to_ready_for_work_readiness_assessment
                    Rails.logger.debug("lb_saved assessment queue = #{lb_saved}")
                    if lb_saved == false
                        raise "error"
                    end
              rescue => err
                    error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
              end
            end
          end



        when 6560

          # scenario 1: REject CPP button  pushes PGU to Ready for Planning Queue

          #3. "Employment Planning Queue"
           # PGU is moved from Assessment Queue to Employmant Planning Queue
          program_unit = ProgramUnit.find(li_reference_id)

          # handling CPP rejection first.
          if arg_object.event_id == 741 && arg_object.reason.present?
             # "Request to Approve CPP is Rejected"
            queue_collection = WorkQueue.where("state = 6637 and reference_type = 6345 and reference_id = ?",li_reference_id)
            if queue_collection.present?
                queue_object = queue_collection.first
                begin
                    lb_saved = queue_object.move_ready_for_career_pathway_planning_approval_queue_to_ready_for_employment_readiness_planning_queue_on_reject
                    Rails.logger.debug("ready_for_career_pathway_planning_approval_queue_to_ready_for_employment_readiness_planning_queue_on_reject = #{lb_saved}")
                    if lb_saved == false
                        raise "error"
                    end
                  rescue => err
                    error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
                end
            end
            return
            # No need to process further
          end

           # scenario 2: Complete Assessment Button pushes PGU to Ready for Planning Queue
           # All adults of PGU assessment complete then only.

          move_to_assessment_completed_queue = false
          # Non child only case type only.
          if  program_unit.case_type != 6048 # "Not Child Only"
            if program_unit.service_program_id == 3 # "TEA Diversion"
                  move_to_assessment_completed_queue = true
            end
              queue_collection = WorkQueue.where("state = 6559 and reference_type = 6345 and reference_id = ?",li_reference_id)
              result = true
              active_adult_members = ProgramUnit.get_non_children_program_unit_members(li_reference_id)
              # assessment for all the program unit members should be complete then only move the program unit from assessment queue to
              # employment planning queue
              # Only after completing assessment for all adults result will be set to true, else it will be result = false
              if active_adult_members.present?
                active_adult_members.each do |each_client_id|
                  # Is assessment completed for each client?
                  result = result && ClientAssessment.where("client_id = ? and assessment_status = 6264",each_client_id).count > 0
                  if ClientAssessment.where("client_id = ? and assessment_status = 6264",each_client_id).count > 0
                    # Is assessment completed for each client?
                    result = true
                  else
                    # if any client's assessment is not complete then break
                    result = false
                    break
                  end
                end # end of active_adult_members.each
              end

              # If all adults have deferral - from Ready for assessment to Ready for PGU activation.
              # deferral check
              lb_cpp_needed = nil
              Rails.logger.debug("active_adult_members in queue service 6560 = #{active_adult_members.inspect}")
              if active_adult_members.present?
                active_adult_members.each do |each_required_member|
                  if ClientCharacteristic.is_open_client_mandatory_work_caharacteric_present?(each_required_member)
                    lb_cpp_needed = true
                    break
                  else
                    lb_cpp_needed = false
                  end
                end # end of adult_members.each
              end

               Rails.logger.debug("lb_cpp_needed = #{lb_cpp_needed}")

               # If Assessment is Completed - then only proceed
              if queue_collection.present? && result == true
                queue_object = queue_collection.first
                begin
                    lb_saved = nil
                    if move_to_assessment_completed_queue || lb_cpp_needed == false
                      # TEA DIVERSION & ALL ADULTS DEFERRAL SCENARIO
                      # Rails.logger.debug("MNP - Deferral case")
                      lb_saved = queue_object.move_from_ready_for_work_readiness_assessment_queue_to_ready_for_Program_unit_activation
                      if lb_saved == false
                        raise "error"
                      end
                      # program unit state should be changed to requested.
                      if program_unit.state == 6165 # complete
                        lb_saved = program_unit.request
                        if lb_saved == false
                          raise "error"
                        end
                      end

                    else
                      # Normal TEA & Workpays Case with Non DIfferal Clients
                      # Rails.logger.debug("MNP - NON Deferral case")
                      lb_saved = queue_object.move_from_ready_for_work_readiness_assessment_queue_to_ready_for_employment_readiness_planning
                      if lb_saved == false
                        raise "error"
                      end
                    end

                  rescue => err
                    error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
                end
              end
          end # end of  program_unit.case_type != 6048

        when 6637
          # "Ready for Career Pathway Planning Approval"
          # move_ready_for_employment_readiness_planning_queue_to_ready_for_career_pathway_planning_approval_queue
          Rails.logger.debug("ABC-queue type - 6637")
          if ProgramUnit.check_is_cpp_completed_by_program_unit_members(arg_object.program_unit_id)
            queue_collection = WorkQueue.where("state = 6560 and reference_type = 6345 and reference_id = ?",arg_object.program_unit_id)
            if queue_collection.present?
              queue_object = queue_collection.first
              begin
                lb_saved =  queue_object.move_ready_for_employment_readiness_planning_queue_to_ready_for_career_pathway_planning_approval_queue
                 Rails.logger.debug("ABC-lb_saved - queue transition successful - 6637")
                if lb_saved == false
                  raise "error"
                end
              rescue => err
                error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
              end
            end
          end

        when 6562
          lb_program_unit_open_status = false
          # CPP Approval BUtton will push PGU to Ready for PGU activation
           Rails.logger.debug("QUEUE TYPE - 6562")
          #5. "First Time Benefit Amount Approval Queue"
          program_unit = ProgramUnit.find(arg_object.program_unit_id)
          if program_unit.case_type != 6048 # "Child Only"
            lb_all_cpp_signed = false
            # make sure all clients who needs CPP are signed
            active_adult_members = ProgramUnit.get_non_children_program_unit_members(program_unit.id)
            active_adult_members.each do |each_required_member|
              if ClientCharacteristic.is_open_client_mandatory_work_caharacteric_present?(each_required_member)
                # is his CPP signed / unsigned ?
                  signed_cpp_plan_collection = CareerPathwayPlan.where("id = (select max(id) from career_pathway_plans cpps
                                                                            where cpps.client_signature = ?
                                                                            and program_unit_id = ?
                                                                            and supervisor_signed_date is null
                                                                            )",each_required_member,program_unit.id)
                  if signed_cpp_plan_collection.present?
                    lb_all_cpp_signed = false
                    break
                  else
                      lb_all_cpp_signed = true
                  end
              end
            end  # end active_adult_members.each

            if lb_all_cpp_signed == true
              if program_unit.service_program_id == 1 || program_unit.service_program_id == 4 # 1 - "TEA", 4- "Work Pays"
                queue_collection = WorkQueue.where("state = 6637 and reference_type = 6345 and reference_id = ?",arg_object.program_unit_id)
                if queue_collection.present?
                    queue_object = queue_collection.first
                    begin
                      lb_program_unit_open_status = ProgramUnitParticipation.is_program_unit_participation_status_open(arg_object.program_unit_id)
                      if lb_program_unit_open_status == true
                        #when CPP is approved from open program unit.
                        lb_saved = queue_object.move_ready_for_career_pathway_planning_approval_queue_to_open_program_unit_queue
                      else
                        lb_saved = queue_object.move_ready_for_career_pathway_planning_approval_queue_to_ready_for_Program_unit_activation
                      end

                      if lb_saved == false
                        raise "error"
                      end
                       # Make the program unit status to Requested state
                      # Rails.logger.debug("MNP-program unit status is complete.")
                      if lb_program_unit_open_status == false
                        #program unit is not open
                        program_unit.state = 6165
                        lb_saved =  program_unit.request
                        if lb_saved == false
                          raise "error"
                        end
                      end
                      # Rails.logger.debug("MNP-program unit status changed to requested now.")
                    rescue => err
                      error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
                    end
                end
              end # end of program_unit.service_program_id == 1 || program_unit.service_program_id == 4 # 1 - "TEA", 4- "Work Pays"
            end #lb_all_cpp_signed == true
          end # program_unit.case_type != 6048

        when 6616
          # Open Program Unit Queue
          queue_collection = WorkQueue.where("state = 6562 and reference_type = 6345 and reference_id = ?",li_reference_id)
          if queue_collection.present?
                queue_object = queue_collection.first
                begin
                  lb_saved =  queue_object.move_from_ready_for_Program_unit_activation_queue_to_active_program_units
                  if lb_saved == false
                      raise "error"
                  end
                rescue => err
                  error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
                end
          end
        when 6642
          #ready for sanction queue
          progressive_sanction_object = Sanction.find(li_reference_id)
          lb_progressive_sanction = Sanction.check_for_progressive_sanction(progressive_sanction_object.sanction_type)
          if ((WorkQueue.is_queue_record_needed?(li_queue_type,li_reference_type,li_reference_id) == true ) and
             (ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)) and
             (lb_progressive_sanction))
              queue_object = WorkQueue.new
              queue_object.reference_type = li_reference_type
              queue_object.reference_id = li_reference_id
              queue_object.state = 6642 # 6642 - "Ready for Sanctions Queue"
              begin
                  queue_object = queue_object.save!
                rescue => err
                    error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
              end
          end
        when 6653
          #FMS payment release queue
           #1."Application Queue"
          if WorkQueue.is_queue_record_needed?(li_queue_type,li_reference_type,li_reference_id) == true
            li_worker_id = arg_object.queue_worker_id
            queue_object = WorkQueue.new
            queue_object.reference_type = li_reference_type
            queue_object.reference_id = li_reference_id
            queue_object.state = 6653
            begin
                queue_object = queue_object.save!
                rescue => err
                    error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
              end
          end

        when 6654
          #"Approve provider payment queue"
          if WorkQueue.is_queue_record_needed?(li_queue_type,li_reference_type,li_reference_id) == true
            # service_authorization_line_item_object = ServiceAuthorizationLineItem.find(li_reference_id)
            # service_authorization_object = ServiceAuthorization.find(service_authorization_line_item_object.service_authorization_id)
            # client_id = service_authorization_object.client_id
            # program_unit_id = service_authorization_object.program_unit_id
            # member_status = ProgramUnitMember.get_member_status(program_unit_id,client_id)
            # if member_status == 4468 # Active member
              begin
                ActiveRecord::Base.transaction do
                  queue_object = WorkQueue.new
                  queue_object.reference_type = li_reference_type
                  queue_object.reference_id = li_reference_id
                  queue_object.state = 6654
                  queue_object.save!
                end
                rescue => err
                  error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
              end
            # end

          end

        when 6717
          # "Pre-screening queue"
          if WorkQueue.is_queue_record_needed?(li_queue_type,li_reference_type,li_reference_id) == true
            begin
              ActiveRecord::Base.transaction do
                li_worker_id = arg_object.queue_worker_id
                queue_object = WorkQueue.new
                queue_object.reference_type = li_reference_type
                queue_object.reference_id = li_reference_id
                queue_object.state = 6717
                queue_object.save!
              end
              rescue => err
                error_object = CommonUtil.write_to_attop_error_log_table("QueueService","process_request_to_save_record_into_queue",err,AuditModule.get_current_user.uid)
            end
          end
      end # case stmt end
 	end


 	def self.process_application_queue(arg_queue_object,arg_client_application_id,arg_intake_worker_id)
      # find the client application object
      client_application_object = ClientApplication.find(arg_client_application_id)
      client_application_object.intake_worker_id = arg_intake_worker_id
      arg_queue_object.save!
      client_application_object.save!
  end



end