class WorkQueue < ActiveRecord::Base

  has_paper_trail :class_name => 'WorkQueuesVersion',:on => [:update, :destroy]
	include AuditModule

  before_create :set_create_user_fields
  before_update :set_update_user_field
  # Manoj 10/10/2015

  def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
  end

  def set_update_user_field
    user_id = AuditModule.get_current_user.uid
    self.updated_by = user_id
  end

  attr_accessor :eligibility_worker_id

# 6557;196;"Application Screening"
# 6558;196;"Ready for Eligibility Determination"
# 6559;196;"Ready for Work Readiness Assessment"
# 6560;196;"Ready for Employment Readiness planning"
# 6637;196;"Ready for Career Pathway Planning Approval"
# 6562;196;"Ready for Program Unit Activation"
# 6616;196;"Active Program Units"


  # State machine state management start Manoj 07/14/2014
  state_machine :state do
    audit_trail context: [:created_by, :queue_reference_type, :queue_reference_id]

    state :application_queue, value: 6735

    state :ready_for_application_processing, value: 6557

    state :ready_for_eligibility_determination, value: 6558

    state :ready_for_work_readiness_assessment, value: 6559

    state :ready_for_employment_readiness_planning, value: 6560

    state :ready_for_Program_unit_activation, value: 6562

    state :reevaluation_queue, value: 6615

    state :active_program_units, value: 6616

    state :ready_for_career_planning_approval, value: 6637

    state :sanctions, value: 6642

    state :fms_payment_release_queue, value: 6653

    state :prescreening_queue, value: 6717

    state :provider_payment_queue, value: 6654

   #1.
    event :move_from_application_queue_to_ready_for_application_processing_queue do
        transition :application_queue => :ready_for_application_processing
    end

   #1.1
    event :move_from_application_processing_queue_to_ready_for_eligibility_determination do
        transition :ready_for_application_processing => :ready_for_eligibility_determination
    end

    #2.
    event :move_from_ready_for_eligibility_determination_queue_to_ready_for_work_readiness_assessment do
          transition :ready_for_eligibility_determination => :ready_for_work_readiness_assessment
    end
    #3.
    event :move_from_ready_for_work_readiness_assessment_queue_to_ready_for_employment_readiness_planning do
        transition :ready_for_work_readiness_assessment => :ready_for_employment_readiness_planning
    end

    #4.
    event :move_ready_for_employment_readiness_planning_queue_to_ready_for_career_pathway_planning_approval_queue do
      transition :ready_for_employment_readiness_planning => :ready_for_career_planning_approval
    end


    # 5. on Approval of CPP for PGU
     event :move_ready_for_career_pathway_planning_approval_queue_to_ready_for_Program_unit_activation do
      transition  :ready_for_career_planning_approval => :ready_for_Program_unit_activation
    end

    # 6. On REjection of CPP for PGU
    event :move_ready_for_career_pathway_planning_approval_queue_to_ready_for_employment_readiness_planning_queue_on_reject do
      transition  :ready_for_career_planning_approval => :ready_for_employment_readiness_planning
    end

     # 7.
    event :move_from_ready_for_Program_unit_activation_queue_to_active_program_units do
      transition :ready_for_Program_unit_activation => :active_program_units
    end

    # 8. TEA DIVERSION OR ALL ADUKTS ARE DEFERRED SCENARIO
    event :move_from_ready_for_work_readiness_assessment_queue_to_ready_for_Program_unit_activation do
      transition :ready_for_work_readiness_assessment => :ready_for_Program_unit_activation
    end

    # 9. CHILD ONLY CASE
    event :move_from_ready_for_eligibility_determination_queue_to_ready_for_Program_unit_activation do
      transition :ready_for_eligibility_determination => :ready_for_Program_unit_activation
    end

    # 10.
    event :move_from_active_program_units_queue_to_reevaluation_queue do
        transition :active_program_units => :reevaluation_queue
    end

    # 11.
    # event :move_program_unit_to_ready_for_ed_queue do
    #   transition all - [:application_queue, :ready_for_application_processing] => :ready_for_eligibility_determination
    # end
    #12 These are used in case of program unit transfer -- start
    # event :move_to_eligibility_determination_queue_to_perform_case_transfer do
    #   transition all - [:ready_for_work_readiness_assessment,:ready_for_employment_readiness_planning,:ready_for_career_pathway_planning_approval,
    #                     :ready_for_Program_unit_activation,:active_program_units,:reevaluation_queue] => :ready_for_eligibility_determination
    # end

    event :move_ready_for_career_pathway_planning_approval_queue_to_open_program_unit_queue do
      transition :ready_for_career_planning_approval => :active_program_units
    end
    # fOR open cHILD onlu pgu - when transfered to other local office - Manoj 04/26/2016
    event :move_from_ready_for_eligibility_determination_queue_to_open_program_unit_queue do
      transition :ready_for_eligibility_determination => :active_program_units
    end

    # TEA DIVERSION REJECTION - MANOJ 04/21/2016
    event :move_from_ready_for_program_unit_activation_to_ready_for_eligibility_determination_queue do

      transition :ready_for_Program_unit_activation => :ready_for_eligibility_determination
    end

  end
 # State machine state management end Manoj 07/14/2014

 # These methods are used to populate state transitions table - start
  def created_by
    # updated user id
     AuditModule.get_current_user.uid
  end

  def queue_reference_type
      # Previous reference_type needs to be saved in the transition table.
     li_queue_type = self.state
     case li_queue_type
      when 6558,6735
      # determine eligibility queue
        return 6587 # "Client Application"
      when 6559,6560,6637,6562,6616
        return 6345 # "Program Unit"
     else
        return nil
     end
  end

  def queue_reference_id
     # Previous reference_id needs to be saved in the transition table.
     li_queue_type = self.state
     case li_queue_type
      when 6558
        # get the client application id for pgu.
        if ProgramUnit.where("id = ?",self.reference_id).present?
          pgu_object = ProgramUnit.find(self.reference_id)
          return pgu_object.client_application_id
        else
          return self.reference_id
        end

      when 6559,6560,6637,6562,6616,6735
        # get program unit id
        return self.reference_id
      else
        return nil
     end
  end
# These methods are used to populate state transitions table - end



  def self.is_queue_record_needed?(arg_queue_type,arg_reference_type,arg_reference_id)
      queue_collection = WorkQueue.where("state = ? and reference_type = ? and reference_id = ?",arg_queue_type,arg_reference_type,arg_reference_id)
      if queue_collection.present?
        # No queue record is not needed to be created.
        return false
      else
        # Yes queue record needs to be created.
        return true
      end
  end



  # def self.get_distinct_queues_with_records_for_user_id(arg_user_id)
  #   step1 = WorkQueue.joins("inner join work_queue_user_subscriptions
  #                            on work_queues.state = work_queue_user_subscriptions.queue_type
  #                            inner join codetable_items
  #                            on work_queues.state = codetable_items.id
  #                          ")
  #   step2 = step1.where("work_queue_user_subscriptions.user_id = ?",arg_user_id)
  #   step3 = step2.select("distinct work_queues.state,codetable_items.short_description").order("codetable_items.short_description ASC")
  #   queue_collection = step3
  #   return queue_collection
  # end




  def self.assign_record_from_queue_to_me(arg_user_id,arg_queue_id)
      ls_msg = WorkQueue.assign_record_from_queue_to_user(arg_user_id,arg_queue_id, nil)
      return ls_msg
  end

  def self.assign_multiple_queue_records_to_user(arg_user_id,arg_queue_records_array, arg_eligibility_worker_id)
        ls_msg = ""
        arg_queue_records_array.each do |each_queue_record_id|
            ls_msg = WorkQueue.assign_record_from_queue_to_user(arg_user_id,each_queue_record_id, arg_eligibility_worker_id)
            if  ls_msg != "SUCCESS"
              break
            end
        end
        return ls_msg
  end



  def self.assign_record_from_queue_to_user(arg_user_id, arg_queue_id, arg_eligibility_worker_id)
    ls_msg = "SUCCESS"
    queue_object = WorkQueue.find(arg_queue_id)
    # fail
    case queue_object.state
          when 6557
             #1."Application Queue"
                client_application_object = ClientApplication.find(queue_object.reference_id)
                if client_application_object.intake_worker_id != arg_user_id
                  client_application_object.intake_worker_id = arg_user_id
                  begin
                    ActiveRecord::Base.transaction do
                      client_application_object.save!
                      # if record from queue is assigned to other user - if it is already being worked by somebody, then his work task should be transefered to new user.
                      WorkTask.transfer_task_to_other_user(arg_user_id,6593,client_application_object.id)
                    end
                  rescue => err
                        error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.uid)
                        ls_msg = "Error occurred when assigning user, for more details refer to error ID: #{error_object.id}."
                  end
                else
                  ls_msg = "No change in assignment."
                end

          when 6558
            #2. "Determine Eligibility Queue"
                case queue_object.reference_type
                when 6587
                  # fail
                  client_application_object = ClientApplication.find(queue_object.reference_id)
                  begin
                    ActiveRecord::Base.transaction do
                      if client_application_object.application_processor.present?
                        if client_application_object.application_processor != arg_user_id
                          client_application_object.application_processor = arg_user_id
                          client_application_object.save!
                            # if record from queue is assigned to other user - if it is already being worked by somebody, then his work task should be transefered to new user.
                            WorkTask.transfer_task_to_other_user(arg_user_id,2155,client_application_object.id)
                        else
                          ls_msg = "No change in assignment."
                        end
                      else
                        client_application_object.application_processor = arg_user_id
                        app_member_object = PrimaryContact.get_primary_contact(client_application_object.id, 6587)
                        # proceed with event to action mapping code to create task
                        # step1 : Populate common event management argument structure
                        common_action_argument_object = CommonEventManagementArgumentsStruct.new
                        common_action_argument_object.client_id = app_member_object.client_id
                        common_action_argument_object.model_object = client_application_object
                        common_action_argument_object.changed_attributes = client_application_object.changed_attributes().keys
                        # step2
                        ls_msg = EventManagementService.process_event(common_action_argument_object)
                        if ls_msg == "SUCCESS"
                            client_application_object.save!
                            # ProgramUnitTaskOwner.set_program_unit_task_owner(program_unit_object.id,6617,arg_user_id)
                        end
                      end
                    end
                  rescue => err
                        error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.uid)
                        ls_msg = "Error occurred when assigning user, for more details refer to error ID: #{error_object.id}."
                  end

                when 6345
                  program_unit_object = ProgramUnit.find(queue_object.reference_id)
                  begin
                        ActiveRecord::Base.transaction do
                            if program_unit_object.eligibility_worker_id.present?
                                if program_unit_object.eligibility_worker_id != arg_user_id
                                    program_unit_object.eligibility_worker_id = arg_user_id
                                    program_unit_object.save!
                                    # if record from queue is assigned to other user - if it is already being worked by somebody, then his work task should be transefered to new user.
                                    WorkTask.transfer_task_to_other_user(arg_user_id,6346,program_unit_object.id)
                                else
                                    ls_msg = "No change in assignment."
                                end
                            else
                                program_unit_object.eligibility_worker_id = arg_user_id
                                 # get primary applicant id.
                                # app_member_object = ApplicationMember.get_primary_applicant(program_unit_object.client_application_id).first

                                app_member_object = PrimaryContact.get_primary_contact(program_unit_object.client_application_id, 6587)
                                # proceed with event to action mapping code to create task
                                # step1 : Populate common event management argument structure
                                common_action_argument_object = CommonEventManagementArgumentsStruct.new
                                common_action_argument_object.client_id = app_member_object.client_id
                                common_action_argument_object.model_object = program_unit_object
                                common_action_argument_object.changed_attributes = program_unit_object.changed_attributes().keys
                                # step2
                                ls_msg = EventManagementService.process_event(common_action_argument_object)
                                if ls_msg == "SUCCESS" || ls_msg.blank?
                                    program_unit_object.save!
                                    ProgramUnitTaskOwner.set_program_unit_task_owner(program_unit_object.id,6617,arg_user_id)
                                end
                            end
                        end
                  rescue => err
                          error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.uid)
                          ls_msg = "Error occurred when when assigning user, for more details refer to error ID: #{error_object.id}."
                  end
                end

          when 6559
            # "Assessment Queue"
              program_unit_object = ProgramUnit.find(queue_object.reference_id)

              begin
                    ActiveRecord::Base.transaction do
                        if program_unit_object.case_manager_id.present?
                            if program_unit_object.case_manager_id != arg_user_id
                                program_unit_object.case_manager_id = arg_user_id
                                program_unit_object.save!
                                active_adult_members = ProgramUnit.get_non_children_program_unit_members(program_unit_object.id)
                                if active_adult_members.class.name != "String"
                                   active_adult_members.each do |each_client_id|
                                     # if record from queue is assigned to other user - if it is already being worked by somebody, then his work task should be transefered to new user.
                                      WorkTask.transfer_task_to_other_user(arg_user_id,6387,each_client_id)
                                   end
                                end
                            else
                                ls_msg = "No change in assignment."
                            end
                        else
                            program_unit_object.case_manager_id = arg_user_id
                            active_adult_members = ProgramUnit.get_non_children_program_unit_members(program_unit_object.id)
                            if active_adult_members.class.name != "String"
                              active_adult_members.each do |each_client_id|
                                 # step1 : Populate common event management argument structure
                                common_action_argument_object = CommonEventManagementArgumentsStruct.new
                                common_action_argument_object.client_id = each_client_id
                                common_action_argument_object.model_object = program_unit_object
                                common_action_argument_object.changed_attributes = program_unit_object.changed_attributes().keys
                                common_action_argument_object.program_unit_id = program_unit_object.id
                                # Rails.logger.debug("common_action_argument_object.changed_attributes = #{common_action_argument_object.changed_attributes.inspect}")
                                # step2
                                ls_msg = EventManagementService.process_event(common_action_argument_object)
                                if ls_msg != "SUCCESS"
                                  break
                                end
                              end # end of active_adult_members.each
                            end
                            if ls_msg == "SUCCESS"
                                program_unit_object.save!
                                ProgramUnitTaskOwner.set_program_unit_task_owner(program_unit_object.id,6618,arg_user_id)
                            end
                        end
                    end
              rescue => err
                      error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.uid)
                      ls_msg = "Error occurred when when assigning user, for more details refer to error ID: #{error_object.id}."
              end

          when 6560
            #3. "Employment Planning Queue"
            program_unit_object = ProgramUnit.find(queue_object.reference_id)
            begin
                ActiveRecord::Base.transaction do
                  program_unit_task_owner = ProgramUnitTaskOwner.get_program_unit_task_owner(program_unit_object.id,6623)
                  if program_unit_task_owner.present?
                       if program_unit_task_owner.ownership_user_id != arg_user_id
                          program_unit_task_owner.ownership_user_id = arg_user_id
                          program_unit_object.case_manager_id = arg_user_id
                          program_unit_object.save!
                          program_unit_task_owner.save!
                          # if record from queue is assigned to other user - if it is already being worked by somebody, then his work task should be transefered to new user.
                          active_adult_members = ProgramUnit.get_non_children_program_unit_members(program_unit_object.id)
                          if active_adult_members.class.name != "String"
                             active_adult_members.each do |each_client_id|
                               # if record from queue is assigned to other user - if it is already being worked by somebody, then his work task should be transefered to new user.
                              if ClientCharacteristic.is_open_client_mandatory_work_caharacteric_present?(each_client_id)
                                WorkTask.transfer_task_to_other_user(arg_user_id,6605,each_client_id)
                              end
                             end
                          end
                       else
                          ls_msg = "No change in assignment."
                       end
                  else
                    # program_unit_object.employment_planning_user_id = arg_user_id
                    # event to action - to create task
                    active_adult_members = ProgramUnit.get_non_children_program_unit_members(program_unit_object.id)
                    # Rails.logger.debug("active_adult_members = #{active_adult_members.inspect}")
                    # fail
                      if active_adult_members.class.name != "String"
                          active_adult_members.each do |each_client_id|
                            if ClientCharacteristic.is_open_client_mandatory_work_caharacteric_present?(each_client_id)
                                # step1 : Populate common event management argument structure
                                common_action_argument_object = CommonEventManagementArgumentsStruct.new
                                common_action_argument_object.event_id = 835 # "Assign to me"
                                common_action_argument_object.user_id = arg_user_id
                                common_action_argument_object.program_unit_id = program_unit_object.id
                                common_action_argument_object.client_id = each_client_id
                                common_action_argument_object.ownership_type = 6623 # "Employment Planning"
                                # step2
                                ls_msg = EventManagementService.execute_event(common_action_argument_object)
                                if ls_msg != "SUCCESS"
                                    break
                                end
                            end
                          end # end of active_adult_members.each
                      end

                      # Rails.logger.debug("ls_msg = #{ls_msg}")
                      if ls_msg == "SUCCESS"
                          # program_unit_object.save!
                          ProgramUnitTaskOwner.set_program_unit_task_owner(program_unit_object.id,6623,arg_user_id)
                      end
                  end



                end
            rescue => err
                    error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.uid)
                    ls_msg = "Error occurred when when assigning user, for more details refer to error ID: #{error_object.id}."
            end
          when 6562
            # 5. "First Time Benefit Amount Approval Queue"
              program_unit_object = ProgramUnit.find(queue_object.reference_id)
              program_wizard_object = ProgramWizard.get_selected_run_id_for_assessment(queue_object.reference_id) # program unit id
              program_unit_task_owner = ProgramUnitTaskOwner.get_program_unit_task_owner(queue_object.reference_id,6620)
              begin
                  ActiveRecord::Base.transaction do
                      if program_unit_task_owner.present?
                          if program_unit_task_owner.ownership_user_id != arg_user_id
                              program_unit_task_owner.ownership_user_id = arg_user_id
                              program_unit_task_owner.save!
                              program_unit_object.case_manager_id = arg_user_id
                              program_unit_object.save!
                              # if record from queue is assigned to other user - if it is already being worked by somebody, then his work task should be transefered to new user.
                              WorkTask.transfer_task_to_other_user(arg_user_id,2172,program_wizard_object.id)
                          else
                              ls_msg = "No change in assignment."
                          end
                      else
                          # program_unit_memebers = ProgramUnitMember.get_primary_beneficiary(queue_object.reference_id)
                          # self_of_pgu = program_unit_memebers.first
                          primary_contact = PrimaryContact.get_primary_contact(queue_object.reference_id, 6345)
                          # step1 : Populate common event management argument structure
                          common_action_argument_object = CommonEventManagementArgumentsStruct.new
                          common_action_argument_object.client_id = primary_contact.client_id if primary_contact.present?
                          common_action_argument_object.event_id = 835 # "Assign to me"
                          common_action_argument_object.user_id = arg_user_id
                          common_action_argument_object.program_unit_id = queue_object.reference_id
                          common_action_argument_object.ownership_type = 6620 # "Benefit Amount Approval"
                          common_action_argument_object.program_wizard_id = program_wizard_object.id

                          # step2
                          ls_msg = EventManagementService.process_event(common_action_argument_object)
                          if ls_msg == "SUCCESS"
                              ProgramUnitTaskOwner.set_program_unit_task_owner(program_wizard_object.program_unit_id,6620,arg_user_id)
                          end
                      end
                  end
              rescue => err
                  error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.uid)
                  ls_msg = "Error occurred when when assigning user, for more details refer to error ID: #{error_object.id}."
              end


           when 6637
            # 5. "Ready for Career Pathway Planning Approval"
              program_unit_object = ProgramUnit.find(queue_object.reference_id)
              cpp_obj_collection = CareerPathwayPlan.where("program_unit_id = ?",program_unit_object.id).order("id desc")
              cpp_obj = nil
              if cpp_obj_collection.present?
                cpp_obj = cpp_obj_collection.first
              end
              begin
                ActiveRecord::Base.transaction do
                  program_unit_task_owner = ProgramUnitTaskOwner.get_program_unit_task_owner(program_unit_object.id,6619) # CPP Approval
                  if program_unit_task_owner.present?
                       if program_unit_task_owner.ownership_user_id != arg_user_id
                          program_unit_task_owner.ownership_user_id = arg_user_id
                          program_unit_task_owner.save!
                          program_unit_object.case_manager_id = arg_user_id
                          program_unit_object.save!
                          if cpp_obj.present?
                            cpp_obj.supervisor_signature = arg_user_id
                            cpp_obj.save!
                          end
                          # if record from queue is assigned to other user - if it is already being worked by somebody, then his work task should be transefered to new user.
                          active_adult_members = ProgramUnit.get_non_children_program_unit_members(program_unit_object.id)
                          if active_adult_members.class.name != "String"
                             active_adult_members.each do |each_client_id|
                               # if record from queue is assigned to other user - if it is already being worked by somebody, then his work task should be transefered to new user.
                                # WorkTask.transfer_task_to_other_user(arg_user_id,6607,each_client_id)
                                work_task_collection = WorkTask.where("task_type = ? and program_unit_id = ? and status = ?",6607,program_unit_object.id,6339)
                                if work_task_collection.present?
                                  work_task_collection.each do |each_task|
                                      each_task.assigned_to_id = arg_user_id
                                      each_task.assigned_by_user_id = AuditModule.get_current_user.uid
                                      each_task.save!
                                  end
                                end
                             end
                          end
                       else
                          ls_msg = "No change in assignment."
                       end
                  else
                     # event to action - to create task
                    active_adult_members_with_cpp =  ProgramUnit.get_completed_cpp_for_adult_program_unit_members(program_unit_object.id)
                    Rails.logger.debug("ABC-active_adult_members_with_cpp = #{active_adult_members_with_cpp.inspect}")
                    active_adult_members_with_cpp.each do |each_cpp|
                        # step1 : Populate common event management argument structure
                        common_action_argument_object = CommonEventManagementArgumentsStruct.new
                        common_action_argument_object.event_id = 835 # "Assign to me"
                        common_action_argument_object.user_id = arg_user_id
                        common_action_argument_object.program_unit_id = program_unit_object.id
                        common_action_argument_object.client_id = each_cpp.client_signature
                        common_action_argument_object.ownership_type = 6619 # "CPP Approval"
                        common_action_argument_object.cpp_id = each_cpp.id
                        # step2
                        ls_msg = EventManagementService.execute_event(common_action_argument_object)
                        if ls_msg != "SUCCESS"
                          break
                        end
                    end # end of active_adult_members.each
                    if ls_msg == "SUCCESS"
                        ProgramUnitTaskOwner.set_program_unit_task_owner(program_unit_object.id,6619,arg_user_id)
                        if cpp_obj.present?
                          cpp_obj.supervisor_signature = arg_user_id
                          cpp_obj.save!
                        end
                    end
                  end

                end # ActiveRecord::Base.transaction do
              rescue => error
                    error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.uid)
                    ls_msg = "Error occurred when when assigning user, for more details refer to error ID: #{error_object.id}."
              end



          when 6616
             #1."Open Program Unit Queue"
                program_unit_object = ProgramUnit.find(queue_object.reference_id)
                if (arg_user_id.present? && program_unit_object.case_manager_id != arg_user_id) || (arg_eligibility_worker_id.present? && program_unit_object.eligibility_worker_id != arg_eligibility_worker_id)

                  begin
                    ActiveRecord::Base.transaction do
                       # if record from queue is assigned to other user - if it is already being worked by somebody, then his work task should be transefered to new user.
                      # 1.
                      # WorkTask.transfer_pending_tasks_from_one_user_to_another(6345,program_unit_object.id,program_unit_object.case_manager_id,arg_user_id)
                      WorkTask.transfer_pending_tasks_from_one_user_to_another_for_program_unit(program_unit_object.id,program_unit_object.case_manager_id,arg_user_id) if program_unit_object.case_manager_id != arg_user_id && arg_user_id != 0
                      WorkTask.transfer_pending_tasks_from_one_user_to_another_for_program_unit(program_unit_object.id,program_unit_object.eligibility_worker_id,arg_eligibility_worker_id) if program_unit_object.eligibility_worker_id != arg_eligibility_worker_id && arg_eligibility_worker_id != 0
                      program_unit_object.case_manager_id = arg_user_id  if program_unit_object.case_manager_id != arg_user_id && arg_user_id != 0
                      program_unit_object.eligibility_worker_id = arg_eligibility_worker_id if program_unit_object.eligibility_worker_id != arg_eligibility_worker_id && arg_eligibility_worker_id != 0


                      # Alert the new worker of case transfer.
                      ls_client_name = ProgramUnitMember.get_primary_beneficiary_name(program_unit_object.id)
                      ls_alert_text ="Program Unit for Client: #{ls_client_name} is transferred to you.You will be the Case Manager for this Program Unit: #{program_unit_object.id}"
                      alert_object = Alert.set_alert(6348, #arg_alert_category, Business Alert
                                                    6634,#arg_alert_type, "Change in Case Manager of Program Unit"
                                                    6345, #arg_alert_for_type,
                                                    program_unit_object.id, #arg_alert_for_id,
                                                    ls_alert_text,#arg_alert_text,
                                                    6339, #arg_status,
                                                    program_unit_object.case_manager_id#arg_alert_assigned_to_user_id
                                                    )
                      # 2.
                      alert_object.save!
                      # 3.
                      program_unit_object.save!
                    end
                  rescue => err
                        error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.uid)
                        ls_msg = "Error occurred when assigning user,for more details refer to Error ID: #{error_object.id}"
                  end
                else
                  ls_msg = "No change in assignment."
                end

          when 6642
            # Sanction queue
            sanction_object = Sanction.find(queue_object.reference_id)

            if sanction_object.compliance_office_id != arg_user_id
              sanction_object.compliance_office_id = arg_user_id
              begin
                ActiveRecord::Base.transaction do
                  sanction_object.save!

                  common_action_argument_object = CommonEventManagementArgumentsStruct.new
                  common_action_argument_object.event_id = 835 # request for Approval of Provider Agreement
                  common_action_argument_object.user_id = arg_user_id
                  common_action_argument_object.ownership_type = 6642
                  common_action_argument_object.sanction_id = sanction_object.id
                  common_action_argument_object.client_id = sanction_object.client_id
                  ls_msg = EventManagementService.process_event(common_action_argument_object)
                end
                rescue => err
                  error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.id)
                  ls_msg = "Error occurred when assigning user, for more details refer to error ID: #{error_object.id}."
              end
            else
              ls_msg = "No change in assignment"
            end

          when 6615
            #reevaluation queue
            program_unit_object = ProgramUnit.find(queue_object.reference_id)
            begin
                ActiveRecord::Base.transaction do
                  program_unit_task_owner = ProgramUnitTaskOwner.get_program_unit_task_owner(program_unit_object.id,6649)
                  if program_unit_task_owner.present?
                    if program_unit_task_owner.ownership_user_id != arg_user_id
                        program_unit_task_owner.ownership_user_id = arg_user_id
                        program_unit_task_owner.save!
                        program_unit_object.case_manager_id = arg_user_id
                        program_unit_object.save!
                        # primary_member_of_program_unit = ProgramUnitMember.get_primary_beneficiary(queue_object.reference_id)
                        # if primary_member_of_program_unit.present?
                          # if record from queue is assigned to other user - if it is already being worked by somebody, then his work task should be transefered to new user.
                          WorkTask.transfer_task_to_other_user(arg_user_id,2154,queue_object.reference_id)
                        # end
                    else
                      ls_msg = "No change in assignment."
                    end
                  else
                    #create work task
                    # step1 : Populate common event management argument structure
                        # primary_member_of_program_unit = ProgramUnitMember.get_primary_beneficiary(queue_object.reference_id).first
                        primary_member_of_program_unit = PrimaryContact.get_primary_contact(queue_object.reference_id, 6345)

                        common_action_argument_object = CommonEventManagementArgumentsStruct.new
                        common_action_argument_object.event_id = 835 # "Assign to me"
                        common_action_argument_object.user_id = arg_user_id
                        common_action_argument_object.program_unit_id = program_unit_object.id
                        common_action_argument_object.client_id = primary_member_of_program_unit.client_id if primary_member_of_program_unit.present?
                        common_action_argument_object.ownership_type = 6649 # "Reevaluation"
                        # step2
                        ls_msg = EventManagementService.execute_event(common_action_argument_object)
                    #Insert into pgu task owners
                    #update PU ED worker
                        if ls_msg == "SUCCESS"
                          ProgramUnitTaskOwner.set_program_unit_task_owner(program_unit_object.id,6649,arg_user_id)
                          program_unit_object.eligibility_worker_id = arg_user_id
                          program_unit_object.save!
                        end
                  end
                end
                # rescue => err
                #     error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.uid)
                #     ls_msg = "Error occurred when when assigning user,for more details refer to Error ID: #{error_object.id}"
            end

          when 6717
            # Pre screening queue
              household_object = Household.find(queue_object.reference_id)
             if household_object.intake_worker_id != arg_user_id
              household_object.intake_worker_id = arg_user_id
              begin
                ActiveRecord::Base.transaction do
                  household_object.save!

                  common_action_argument_object = CommonEventManagementArgumentsStruct.new
                  common_action_argument_object.event_id = 835 # request for Approval of Provider Agreement
                  common_action_argument_object.user_id = arg_user_id
                  common_action_argument_object.ownership_type = 6717
                  common_action_argument_object.household_id = household_object.id
                  # common_action_argument_object.sanction_id = sanction_object.id
                  # common_action_argument_object.client_id = sanction_object.client_id
                  ls_msg = EventManagementService.process_event(common_action_argument_object)
                end
                rescue => err
                  error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.id)
                  ls_msg = "Error occurred when assigning user, for more details refer to error ID: #{error_object.id}."
              end
            else
              ls_msg = "No change in assignment"
            end
          when 6654
            # Approve provider payment queue 6654
            provider_invoice_object = ProviderInvoice.find(queue_object.reference_id)
            if provider_invoice_object.payment_approver_id != arg_user_id
              provider_invoice_object.payment_approver_id = arg_user_id
              begin
                ActiveRecord::Base.transaction do
                  provider_invoice_object.save!

                  common_action_argument_object = CommonEventManagementArgumentsStruct.new
                  common_action_argument_object.event_id = 835 # request for Approval of Provider Agreement
                  common_action_argument_object.user_id = arg_user_id
                  common_action_argument_object.ownership_type = 6654
                  common_action_argument_object.provider_invoice_id = provider_invoice_object.id
                  ls_msg = EventManagementService.process_event(common_action_argument_object)
                end
                rescue => err
                  error_object = CommonUtil.write_to_attop_error_log_table("WorkQueue","assign_record_from_queue_to_user",err,AuditModule.get_current_user.id)
                  ls_msg = "Error occurred when assigning user, for more details refer to error ID: #{error_object.id}."
              end
            end


      end # end of case
      return ls_msg
  end




  def self.get_self_of_program_unit_for_a_given_queue(arg_queue_id)
    ls_self_name = " "
    queue_object = WorkQueue.find(arg_queue_id)
    case queue_object.reference_type
    when 6345
        # self_of_pgu_collection = ProgramUnitMember.get_primary_beneficiary(queue_object.reference_id)
        # self_of_pgu_object = self_of_pgu_collection.first
        # client_object = Client.find(self_of_pgu_object.client_id)
        # ls_self_name = client_object.get_client_name
        ls_self_name = ProgramUnitMember.get_primary_beneficiary_name(queue_object.reference_id)
    end
    return ls_self_name
  end

  def self.get_the_state_of_the_reference_id(arg_reference_type,arg_reference_id)
    work_queues = where("reference_type = ? and reference_id = ?",arg_reference_type,arg_reference_id)
    return work_queues.present? ? work_queues.first.state : nil
  end



# Manoj New method - 10/13/2015  program_units.processing_location
  def self.get_queue_records_for_given_queue_type_and_local_office_and_user_id(arg_queue_type,arg_local_office_id,arg_user_id)
        # Rails.logger.debug("arg_queue_type = #{arg_queue_type}")
        # Rails.logger.debug("arg_user_id = #{arg_user_id}")
        case arg_queue_type.to_i
         when 6735
            #1."Application Queue"
              step1 = WorkQueue.joins("inner join work_queue_user_subscriptions
                                       on (work_queues.state = work_queue_user_subscriptions.queue_type
                                            and work_queue_user_subscriptions.queue_type = 6735

                                           )

                                       inner join client_applications
                                       on (client_applications.id = work_queues.reference_id

                                           )

                                       inner join codetable_items local_office_names
                                       on client_applications.application_received_office = local_office_names.id

                                       inner join users
                                       on client_applications.intake_worker_id = users.uid


                                       ")
              step2 = step1.where("work_queues.state = 6735
                                  and work_queue_user_subscriptions.user_id = ?
                                  and work_queue_user_subscriptions.local_office_id = ?
                                  and client_applications.application_received_office = ?",arg_user_id,arg_local_office_id,arg_local_office_id)
              step3 = step2.select("distinct work_queues.id,
                                    client_applications.application_received_office,
                                    client_applications.intake_worker_id,
                                    work_queues.state,
                                    work_queues.reference_type,
                                    work_queues.reference_id,
                                    local_office_names.short_description as queue_loal_office_name,

                                    users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
                                  ").order("work_queues.updated_at desc")
              queue_collection = step3
         when 6557
            #1."Ready for Application processing Queue"
              step1 = WorkQueue.joins("inner join work_queue_user_subscriptions
                                       on (work_queues.state = work_queue_user_subscriptions.queue_type
                                            and work_queue_user_subscriptions.queue_type = 6557

                                           )

                                       inner join client_applications
                                       on (client_applications.id = work_queues.reference_id

                                           )

                                       inner join codetable_items local_office_names
                                       on client_applications.application_received_office = local_office_names.id

                                       inner join users
                                       on client_applications.intake_worker_id = users.uid


                                       ")
              step2 = step1.where("work_queues.state = 6557
                                  and work_queue_user_subscriptions.user_id = ?
                                  and work_queue_user_subscriptions.local_office_id = ?
                                  and client_applications.application_received_office = ?",arg_user_id,arg_local_office_id,arg_local_office_id)
              step3 = step2.select("distinct work_queues.id,
                                    client_applications.application_received_office,
                                    client_applications.intake_worker_id,
                                    work_queues.state,
                                    work_queues.reference_type,
                                    work_queues.reference_id,
                                    local_office_names.short_description as queue_loal_office_name,

                                    users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
                                  ").order("work_queues.updated_at desc")
              queue_collection = step3
              # Rails.logger.debug("queue_collection = #{queue_collection.inspect}")
          when 6558
            #2. "Ready for Eligibility Determination"
            step1 = WorkQueue.joins("INNER JOIN work_queue_user_subscriptions
                                      on (work_queues.state = work_queue_user_subscriptions.queue_type
                                          and work_queue_user_subscriptions.queue_type = 6558
                                        )
                                      LEFT OUTER join client_applications
                                      on (client_applications.id = work_queues.reference_id
                                          AND work_queues.reference_type = 6587)

                                      LEFT OUTER join program_units
                                      on (program_units.id = work_queues.reference_id
                                      AND work_queues.reference_type = 6345
                                      )
                                      LEFT OUTER join users ED_WORKERS
                                      on program_units.eligibility_worker_id = ED_WORKERS.uid

                                      LEFT OUTER join users AP_PROCESSORS
                                      on client_applications.application_processor = AP_PROCESSORS.uid
                                      ")
              step2 = step1.where("work_queues.state = 6558
                                  and work_queue_user_subscriptions.user_id = ?
                                  and work_queue_user_subscriptions.local_office_id = ?
                                  and (client_applications.application_received_office = ?
                                       OR
                                       program_units.processing_location = ?)",arg_user_id,arg_local_office_id,arg_local_office_id,arg_local_office_id)
              step3 = step2.select("distinct work_queues.id ,
                                    CASE
                                        WHEN work_queues.reference_type = 6587 THEN client_applications.application_received_office
                                        WHEN work_queues.reference_type = 6345 THEN program_units.processing_location
                                    END AS processing_location,
                                    CASE
                                        WHEN work_queues.reference_type = 6587 THEN 0
                                        WHEN work_queues.reference_type = 6345 THEN program_units.service_program_id
                                    END AS service_program_id,
                                    work_queues.state,
                                    work_queues.reference_type,
                                    work_queues.reference_id,
                                    CASE
                                        WHEN work_queues.reference_type = 6587 THEN AP_PROCESSORS.name ||'(' || AP_PROCESSORS.uid ||')'
                                        WHEN work_queues.reference_type = 6345 THEN ED_WORKERS.name ||'(' || ED_WORKERS.uid ||')'
                                    END AS assigned_worker_name,
                                    work_queues.updated_at
                                  ").order("work_queues.updated_at desc")
              queue_collection = step3




              # Manoj - before SQL injection commented code start

        #        step1 = WorkQueue.joins("inner join
        #                            (SELECT distinct work_queues.id as qid,
        #                             client_applications.application_received_office as processing_location,
        #                             client_applications.application_processor as worker_id,
        #                             0 as service_program_id,
        #                             work_queues.state,
        #                             work_queues.reference_type,
        #                             work_queues.reference_id,
        #                             local_office_names.short_description as queue_loal_office_name,
        #                              users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
        #                            FROM work_queues inner join work_queue_user_subscriptions
        #                                on (work_queues.state = work_queue_user_subscriptions.queue_type
        #                                     and work_queue_user_subscriptions.queue_type = 6558
        #                                     and work_queue_user_subscriptions.local_office_id = #{arg_local_office_id.to_i}
        #                                    )
        #                                inner join client_applications
        #                                on (client_applications.id = work_queues.reference_id
        #                                    and client_applications.application_received_office = #{arg_local_office_id.to_i}
        #                                   )

        #                                inner join codetable_items local_office_names
        #                                on client_applications.application_received_office = local_office_names.id

        #                                 left outer join users
        #                                on client_applications.application_processor = users.uid
        #                                WHERE (work_queues.state = 6558
        #                             and work_queues.updated_at > (current_date - 15)
        #                            and work_queues.reference_type = 6587
        #                            and work_queue_user_subscriptions.user_id = '#{arg_user_id}'
        #                            and work_queue_user_subscriptions.local_office_id = #{arg_local_office_id.to_i}
        #                            and client_applications.application_received_office = #{arg_local_office_id.to_i})



        #                           union

        #                           SELECT distinct work_queues.id as qid,
        #                             program_units.processing_location,
        #                             program_units.eligibility_worker_id as worker_id,
        #                             program_units.service_program_id,
        #                             work_queues.state,
        #                             work_queues.reference_type,
        #                             work_queues.reference_id,
        #                             local_office_names.short_description as queue_loal_office_name,
        #                              users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
        #                            FROM work_queues inner join work_queue_user_subscriptions
        #                                on (work_queues.state = work_queue_user_subscriptions.queue_type
        #                                     and work_queue_user_subscriptions.queue_type = 6558
        #                                     and work_queue_user_subscriptions.local_office_id = #{arg_local_office_id.to_i}
        #                                    )
        #                                inner join program_units
        #                                on (program_units.id = work_queues.reference_id
        #                                    and program_units.processing_location = #{arg_local_office_id.to_i}
        #                                   )

        #                                inner join codetable_items local_office_names
        #                                on program_units.processing_location = local_office_names.id

        #                                 left outer join users
        #                                on program_units.eligibility_worker_id = users.uid
        #                                 WHERE (work_queues.state = 6558
        #                             and work_queues.updated_at > (current_date - 15)
        #                            and work_queues.reference_type = 6345
        #                            and work_queue_user_subscriptions.user_id = '#{arg_user_id}'
        #                            and work_queue_user_subscriptions.local_office_id = #{arg_local_office_id.to_i}
        #                            and program_units.processing_location = #{arg_local_office_id.to_i})
        #                          ) wk
        #              on wk.qid =work_queues.id
        #               ")

        #  queue_collection = step1.select("distinct work_queues.id,
        #                              processing_location,
        #                              worker_id,
        #                              service_program_id,
        #                              work_queues.state,
        #                              work_queues.reference_type,
        #                              work_queues.reference_id,
        #                              queue_loal_office_name,
        #                              assigned_worker_name,
        #                              work_queues.updated_at").order("work_queues.updated_at desc")
        # Rails.logger.debug("OLD queue_collection = #{queue_collection.inspect}")
       # Manoj - before SQL injection commented code end


          when 6559
            # "Assessment Queue"
             step1 = WorkQueue.joins("inner join work_queue_user_subscriptions
                                       on (work_queues.state = work_queue_user_subscriptions.queue_type
                                            and work_queue_user_subscriptions.queue_type = 6559

                                          )

                                       inner join program_units
                                       on (program_units.id = work_queues.reference_id

                                           )
                                       inner join codetable_items local_office_names
                                       on program_units.processing_location = local_office_names.id

                                        left outer join users
                                       on program_units.case_manager_id = users.uid
                                       ")
              step2 = step1.where("work_queues.state = 6559
                                   and work_queue_user_subscriptions.user_id = ?
                                   and work_queue_user_subscriptions.local_office_id = ?
                                   and program_units.processing_location = ?",arg_user_id,arg_local_office_id,arg_local_office_id)
              step3 = step2.select("distinct work_queues.id,
                                    program_units.processing_location,
                                    program_units.case_manager_id as worker_id,
                                    work_queues.state,
                                    work_queues.reference_type,
                                    work_queues.reference_id,
                                    local_office_names.short_description as queue_loal_office_name,
                                     users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
                                  ").order("work_queues.updated_at desc")
              queue_collection = step3
              # Rails.logger.debug("queue_collection = #{queue_collection.inspect}")
          when 6560

            #3. "Employment Planning Queue"
              step1 = WorkQueue.joins("inner join work_queue_user_subscriptions
                             on (work_queues.state = work_queue_user_subscriptions.queue_type
                                  and work_queue_user_subscriptions.queue_type = 6560

                                )

                             inner join program_units
                             on (program_units.id = work_queues.reference_id

                                )

                             inner join codetable_items local_office_names
                             on program_units.processing_location = local_office_names.id

                              left outer join program_unit_task_owners
                              on (program_units.id = program_unit_task_owners.program_unit_id
                                  and program_unit_task_owners.ownership_type = 6623
                                  )
                              left outer join users
                             on (program_unit_task_owners.ownership_user_id = users.uid
                                 and program_unit_task_owners.ownership_type = 6623
                                 )
                             ")
            step2 = step1.where("work_queues.state = 6560
                        and work_queue_user_subscriptions.user_id = ?
                        and work_queue_user_subscriptions.local_office_id = ?
                        and program_units.processing_location = ?
                         ",arg_user_id,arg_local_office_id,arg_local_office_id)
            step3 = step2.select("distinct work_queues.id,
                          program_units.processing_location,
                          program_unit_task_owners.ownership_user_id as worker_id,
                          work_queues.state,
                          work_queues.reference_type,
                          work_queues.reference_id,
                          local_office_names.short_description as queue_loal_office_name,
                           users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
                        ").order("work_queues.updated_at desc")
             queue_collection = step3



          when 6562
            #5. "First Time Benefit Amount Approval Queue"
             step1 = WorkQueue.joins("inner join work_queue_user_subscriptions
                             on (work_queues.state = work_queue_user_subscriptions.queue_type
                                  and work_queue_user_subscriptions.queue_type = 6562

                                )

                            inner join program_units
                             on (program_units.id = work_queues.reference_id

                                )

                             inner join codetable_items local_office_names
                             on program_units.processing_location = local_office_names.id

                              left outer join program_unit_task_owners
                              on (program_units.id = program_unit_task_owners.program_unit_id
                                  and program_unit_task_owners.ownership_type = 6620
                                  )
                              left outer join users
                             on (program_unit_task_owners.ownership_user_id = users.uid
                                 and program_unit_task_owners.ownership_type = 6620
                                 )
                             ")
            step2 = step1.where("work_queues.state = 6562
                                and work_queue_user_subscriptions.user_id = ?
                                and work_queue_user_subscriptions.local_office_id = ?
                                and program_units.processing_location = ?
                                ",arg_user_id,arg_local_office_id,arg_local_office_id)
            # Rails.logger.debug("step2 = #{step2.inspect}")
            step3 = step2.select("distinct work_queues.id,
                                  program_units.processing_location,
                                  program_unit_task_owners.ownership_user_id as worker_id,
                                  work_queues.state,
                                  work_queues.reference_type,
                                  work_queues.reference_id,
                                  local_office_names.short_description as queue_loal_office_name,
                                   users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
                                ").order("work_queues.updated_at desc")
            queue_collection = step3
          when 6637
            Rails.logger.debug("queue- type = 6637")
            # "Ready for Career Pathway Planning Approval"
             step1 = WorkQueue.joins("inner join work_queue_user_subscriptions
                             on (work_queues.state = work_queue_user_subscriptions.queue_type
                                  and work_queue_user_subscriptions.queue_type = 6637

                                )

                             inner join program_units
                             on (program_units.id =work_queues.reference_id

                                )

                             inner join codetable_items local_office_names
                             on program_units.processing_location = local_office_names.id

                              left outer join program_unit_task_owners
                              on (program_units.id = program_unit_task_owners.program_unit_id
                                  and program_unit_task_owners.ownership_type = 6619
                                  )
                              left outer join users
                             on (program_unit_task_owners.ownership_user_id = users.uid
                                 and program_unit_task_owners.ownership_type = 6619
                                 )
                             ")
            step2 = step1.where("work_queues.state = 6637
                                and work_queue_user_subscriptions.user_id = ?
                                and work_queue_user_subscriptions.local_office_id = ?
                                and program_units.processing_location = ?
                                ",arg_user_id,arg_local_office_id,arg_local_office_id)
            # Rails.logger.debug("step2 = #{step2.inspect}")
            step3 = step2.select("distinct work_queues.id,
                                  program_units.processing_location,
                                  program_unit_task_owners.ownership_user_id as worker_id,
                                  work_queues.state,
                                  work_queues.reference_type,
                                  work_queues.reference_id,
                                  local_office_names.short_description as queue_loal_office_name,
                                   users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
                                ").order("work_queues.updated_at desc")
             queue_collection =   step3
          when 6616
            # "Open Program unit queue"

             step1 = WorkQueue.joins("inner join work_queue_user_subscriptions
                                       on (work_queues.state = work_queue_user_subscriptions.queue_type
                                            and work_queue_user_subscriptions.queue_type = 6616

                                          )

                                       inner join program_units
                                       on ( program_units.id = work_queues.reference_id

                                        )

                                       inner join codetable_items local_office_names
                                       on program_units.processing_location = local_office_names.id


                                        left outer join users
                                       on program_units.case_manager_id = users.uid
                                       ")
              step2 = step1.where("work_queues.state = 6616
                                  and work_queue_user_subscriptions.user_id = ?
                                  and work_queue_user_subscriptions.local_office_id = ?
                                  and program_units.processing_location = ?",arg_user_id,arg_local_office_id,arg_local_office_id)
              step3 = step2.select("distinct work_queues.id,
                                    program_units.processing_location,
                                    program_units.case_manager_id as worker_id,
                                    work_queues.state,
                                    work_queues.reference_type,
                                    work_queues.reference_id,
                                    local_office_names.short_description as queue_loal_office_name,
                                     users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
                                  ").order("work_queues.updated_at desc")
              queue_collection = step3

          when 6642
            # 6642 sanction queue
            step1 = WorkQueue.joins("inner join work_queue_user_subscriptions
                                    on (work_queues.state = work_queue_user_subscriptions.queue_type
                                         and work_queue_user_subscriptions.queue_type = 6642
                                         )
                                     inner join sanctions
                                      on ( sanctions.id = work_queues.reference_id
                                          and work_queues.reference_type = 6367
                                          )
                                      inner join clients on clients.id = sanctions.client_id
                                      inner join program_unit_members
                                      on program_unit_members.client_id = sanctions.client_id
                                      inner join program_units
                                      on program_units.id = program_unit_members.program_unit_id
                                      INNER JOIN PROGRAM_UNIT_PARTICIPATIONS
                                      ON (PROGRAM_UNITS.ID=PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID
                                          AND PROGRAM_UNIT_PARTICIPATIONS.ID = ( SELECT MAX(ID)
                                                                                 FROM PROGRAM_UNIT_PARTICIPATIONS A
                                                                                 WHERE A.PROGRAM_UNIT_ID = PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID
                                                                                )
                                          AND PROGRAM_UNIT_PARTICIPATIONS.PARTICIPATION_STATUS = 6043
                                         )
                                      left outer join users
                                      on sanctions.compliance_office_id = users.uid
                                   ")
            step2 = step1.where("work_queues.state = 6642
                                  and work_queue_user_subscriptions.user_id = ?
                                  and work_queue_user_subscriptions.local_office_id = ?
                                  and program_units.processing_location = ?
                                ",arg_user_id,arg_local_office_id,arg_local_office_id)
            step3 = step2.select("distinct work_queues.id as id,
                                  clients.last_name || ',' || clients.first_name as client_name,
                                  sanctions.service_program_id as service_program_id,
                                  sanctions.sanction_type as sanction_type,
                                  work_queues.state as state,
                                  work_queues.reference_type as reference_type,
                                  work_queues.reference_id as reference_id,
                                  users.name ||'(' || users.id ||')' as assigned_worker_name,work_queues.updated_at
                                  ").order("work_queues.updated_at desc")
            queue_collection = step3
          when 6615
            #6615 reevaluation queue
            step1 = WorkQueue.joins("inner join work_queue_user_subscriptions
                                       on (work_queues.state = work_queue_user_subscriptions.queue_type
                                            and work_queue_user_subscriptions.queue_type = 6615

                                          )

                                      inner join program_units
                                       on (program_units.id =work_queues.reference_id

                                          )

                                       inner join codetable_items local_office_names
                                       on program_units.processing_location = local_office_names.id

                                        left outer join program_unit_task_owners
                                        on (program_units.id = program_unit_task_owners.program_unit_id
                                            and program_unit_task_owners.ownership_type = 6649
                                            )
                                        left outer join users
                                       on (program_unit_task_owners.ownership_user_id = users.uid
                                           and program_unit_task_owners.ownership_type = 6649
                                           )
                                    ")
            step2 = step1.where("work_queues.state = 6615
                                and work_queue_user_subscriptions.user_id = ?
                                and work_queue_user_subscriptions.local_office_id = ?
                                and program_units.processing_location = ?
                                ",arg_user_id,arg_local_office_id,arg_local_office_id)
            # Rails.logger.debug("step2 = #{step2.inspect}")
            step3 = step2.select("distinct work_queues.id,
                                  program_units.processing_location,
                                  program_unit_task_owners.ownership_user_id as worker_id,
                                  work_queues.state,
                                  work_queues.reference_type,
                                  work_queues.reference_id,
                                  local_office_names.short_description as queue_loal_office_name,
                                   users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
                                ").order("work_queues.updated_at desc")
             queue_collection =   step3
          # when 6717
          #   # 6717 pre screening queue
          #   step1 = WorkQueue.joins("inner join work_queue_user_subscriptions
          #                             on (work_queues.state = work_queue_user_subscriptions.queue_type
          #                                 and work_queue_user_subscriptions.queue_type = 6717
          #                                 and work_queue_user_subscriptions.local_office_id = #{arg_local_office_id.to_i}
          #                                 )

          #                           inner join households
          #                             on (households.id = work_queues.reference_id
          #                                  and households.processing_location_id = #{arg_local_office_id.to_i}
          #                                  )

          #                           inner join codetable_items local_office_names
          #                             on households.processing_location_id = local_office_names.id

          #                           left outer join users
          #                              on households.intake_worker_id = users.uid

          #                           inner join household_members
          #                               on (household_members.household_id = households.id
          #                                   and household_members.head_of_household_flag = 'Y')

          #                           inner join clients
          #                             on household_members.client_id = clients.id
          #                             ")

          #   step2 = step1.where("work_queues.state = 6717
          #                         and work_queue_user_subscriptions.user_id = ?
          #                         and work_queue_user_subscriptions.local_office_id = ?
          #                         and households.processing_location_id  = ?",arg_user_id,arg_local_office_id,arg_local_office_id)

          #   step3 = step2.select("distinct work_queues.id,
          #                         households.processing_location_id,
          #                         households.intake_worker_id,
          #                         work_queues.state,
          #                         work_queues.reference_type,
          #                         work_queues.reference_id,
          #                         local_office_names.short_description as queue_loal_office_name,
          #                         clients.last_name || ' ' ||clients.first_name as client_name,
          #                         clients.ssn as ssn,
          #                         users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
          #                         ").order("work_queues.updated_at desc")

          #   queue_collection =   step3
          when 6654
            #provider approval queue
            step1 = WorkQueue.joins("work_queues inner join work_queue_user_subscriptions
                                      on (work_queues.state = work_queue_user_subscriptions.queue_type
                                           and work_queue_user_subscriptions.queue_type = 6654
                                         )

                                    inner join provider_invoices
                                     on (provider_invoices.id = work_queues.reference_id)

                                    inner join providers
                                      on (provider_invoices.provider_id = providers.id )

                                    inner join service_authorizations
                                  on service_authorizations.id =  provider_invoices.service_authorization_id

                                    inner join program_units
                                      on (program_units.id = service_authorizations.program_unit_id
                                         )

                                    inner join codetable_items local_office_names
                                      on program_units.processing_location = local_office_names.id

                                   left outer join users
                                     on provider_invoices.payment_approver_id = users.uid

                                   inner join clients
                                    on service_authorizations.client_id = clients.id
                                      ")

            step2 = step1.where("work_queues.state = 6654
                                  and work_queue_user_subscriptions.user_id = ?
                                  and work_queue_user_subscriptions.local_office_id = ?
                                  and program_units.processing_location  = ?",arg_user_id,arg_local_office_id,arg_local_office_id)

            step3 = step2.select("distinct work_queues.id,
                                  program_units.processing_location,
                                  provider_invoices.payment_approver_id,
                                  provider_invoices.id as warrent_id,
                                  work_queues.state,
                                  work_queues.reference_type,
                                  work_queues.reference_id,
                                  local_office_names.short_description as queue_loal_office_name,
                                  clients.last_name || ' ' ||clients.first_name as client_name,
                                  providers.provider_name as provider_name,
                                  users.name ||'(' || users.uid ||')' as assigned_worker_name,work_queues.updated_at
                                  ").order("work_queues.updated_at desc")

            queue_collection =   step3
          end
        # queue_collection = queue_collection.order("id DESC")
    return queue_collection
  end


def self.delete_reeval_queue(arg_state,arg_reference_type,arg_reference_id)
    work_queues = WorkQueue.where("state = ? and reference_type = ? and reference_id = ?",arg_state,arg_reference_type,arg_reference_id)
    if work_queues.present?
        work_queue = work_queues.first
        work_queue.destroy!
    end
end


end



