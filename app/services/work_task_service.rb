class WorkTaskService

  def self.create_work_task(arg_object,arg_event_to_action_mapping_object)
    return_work_task_objects = WorkTaskService.set_work_task_data(arg_object,arg_event_to_action_mapping_object)
    if return_work_task_objects.present?
        return_work_task_objects.each do |return_work_task_object|
          return_work_task_object.save!
        end

    end
  end


  def self.complete_work_task(arg_object,arg_event_to_action_mapping_object)
    return_work_task_objects = WorkTaskService.set_complete_work_task_data(arg_object,arg_event_to_action_mapping_object)
    if return_work_task_objects.present?
      return_work_task_objects.each do |work_task_object|
        work_task_object.save!
      end
    end

  end

    def self.set_complete_work_task_data(arg_object,arg_event_to_action_mapping_object)
      li_reference_id = nil
      work_task_objects = Array.new
      li_task_type = arg_event_to_action_mapping_object.task_type
      case li_task_type
      when 6353
        li_reference_id = arg_object.provider_agreement_id
      when 2178,6633
         li_reference_id = arg_object.program_unit_id
      when 6607,6464
        li_reference_id = arg_object.cpp_id
      when 6469,6470
        li_reference_id = arg_object.provider_invoice_id
      when 2172,6388
        li_reference_id = arg_object.program_wizard_id
      when 6593,6736,2155
        li_reference_id = arg_object.client_application_id
      when 6387,6605,2142
        li_reference_id = arg_object.client_id
      # Manoj 09/16/2015 - commented 6386
      # records are added in Determing ED Queue , users subscribed to it can assign it to themselves OR
      # /supervisors subscribed to queue will assign to user. There is no need to create task.
      when 6344,6346,6386
        if arg_object.model_object.present?
          li_reference_id = arg_object.model_object.id
        else
          li_reference_id = arg_object.program_unit_id
        end
      when 2168
         li_reference_id = arg_object.sanction_id
      when 2140
          li_reference_id = arg_object.action_plan_detail_id
      end


      if li_task_type == 6607 && arg_object.reason.present?
        # REjected and reason present - then close all CPP approval tasks.

           work_task_collection = WorkTask.where("task_type = ?
                                            and program_unit_id = ?
                                            and status = 6339",li_task_type,arg_object.program_unit_id)
           if work_task_collection.present?
              work_task_collection.each do |work_task_object|
                work_task_object.complete_date = Date.today
                work_task_object.status = 6341
                work_task_objects << work_task_object
              end
           end
      elsif li_task_type == 6635 || li_task_type == 2142
        # MANOJ 05/26/2016
        # Rule : 6635 - submit ED run
        #        2142 - Run ED determination
        #  if task 6635 is complete - then if there task-2142 pending that also should be closed.
          work_task_collection = WorkTask.where("task_type in (6635,2142)
                                            and program_unit_id = ?
                                            and status = 6339",arg_object.program_unit_id)
           if work_task_collection.present?
              work_task_collection.each do |work_task_object|
                work_task_object.complete_date = Date.today
                work_task_object.status = 6341
                work_task_objects << work_task_object
              end
           end
      else
           work_task_collection = WorkTask.where("task_type = ?
                                            and reference_id = ?
                                            and status = 6339",li_task_type,li_reference_id)

          if work_task_collection.present?
            work_task_object = work_task_collection.first
            work_task_object.complete_date = Date.today
            work_task_object.status = 6341

            work_task_objects << work_task_object
          end
      end
      return work_task_objects

    end


  def self.set_work_task_data(arg_action_arguments_object,arg_event_action_mapping_object)
    ls_local_office = ""
    # identify the task type for the action ID.
    if arg_action_arguments_object.client_id.present?
      client_object = Client.find(arg_action_arguments_object.client_id)
      ls_client_name = client_object.get_full_name
    end

    if arg_action_arguments_object.program_unit_id.present?
      program_unit_object = ProgramUnit.find(arg_action_arguments_object.program_unit_id)
      ls_service_program = ServiceProgram.service_program_name(program_unit_object.service_program_id)
      ls_local_office = ProgramUnit.get_processing_local_office_name(arg_action_arguments_object.program_unit_id)
    end

    work_task_objects = Array.new

    li_task_type = arg_event_action_mapping_object.task_type

    # for task type 6621, there are sub task types use it to compute the number of days to complete the task
    if li_task_type.present? && li_task_type != 6621 && li_task_type != 6633
      ldt_due_date = get_due_date(li_task_type)
    end
    case li_task_type
       when 2172
            # called for TEA DIVERSION RESUBMIT/AFTER REJECTION , so that ED worker who rejected will get a task to work on it again.
            if arg_action_arguments_object.user_id.present? && program_unit_object.service_program_id == 3
                ls_action_text = "Approve benefit amount for #{ls_service_program} program unit for client:#{ls_client_name}."
                ls_instructions ="This is a system generated task to approve first time benefit amount for #{ls_service_program} program unit:#{program_unit_object.id} for client:#{ls_client_name}."
                ldt_due_date = get_due_date(2172)
                work_task_object = WorkTask.set_work_task(2172,#arg_task_type,
                                                          6378,#arg_beneficiary_type, "Program Wizard"
                                                          arg_action_arguments_object.program_wizard_id,#arg_reference_id,
                                                          ls_action_text,#arg_action_text,
                                                          6342,#arg_assigned_to_type, - user
                                                          arg_action_arguments_object.user_id,#arg_assigned_to_id,
                                                          AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                          6366,#arg_task_category, "Client"
                                                          client_object.id,#arg_client_id,
                                                          ldt_due_date,#arg_due_date,
                                                          ls_instructions,#arg_instructions,
                                                          2188,#arg_urgency,
                                                          '',#arg_notes,
                                                          6339 #arg_status
                                                          )
                program_wizard = ProgramWizard.find(arg_action_arguments_object.program_wizard_id)
                work_task_object.program_unit_id = program_wizard.program_unit_id
                work_task_objects << work_task_object
            end
       when 6764 # "Assessment modified by other user"

            ls_user_name = User.get_user_full_name(AuditModule.get_current_user.uid)
            ls_action_text = "Assessment for client: #{ls_client_name } is modified by user: #{ls_user_name }, you may need to modify his employment plan."
            ls_instructions = "This is a system created task- Assessment for client: #{ls_client_name } is modified by user: #{ls_user_name }, you may need to modify his employment plan if assessment changes resulted new barriers.This task should be marked complete by user, system will not automatically close this task."
            work_task_object = WorkTask.set_work_task(li_task_type,#arg_task_type,
                                                     6345,#arg_beneficiary_type, - Program Unit
                                                     program_unit_object.id,#arg_reference_id,
                                                     ls_action_text,#arg_action_text,
                                                     6342,#arg_assigned_to_type,# user
                                                     program_unit_object.case_manager_id,#arg_assigned_to_id,
                                                     AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                     6366,#arg_task_category, - client
                                                     client_object.id,#arg_client_id,
                                                     ldt_due_date,#arg_due_date,
                                                     ls_instructions,#arg_instructions,
                                                     2188,#arg_urgency,
                                                     '',#arg_notes,
                                                     6339 #arg_status
                                                    )
            work_task_objects << work_task_object
      when 6736 # "Complete Application Screening"
            # ls_action_text = "Complete Application Intake for client:#{ls_client_name}"
            ls_household_name = Household.get_household_name_from_application_id(arg_action_arguments_object.client_application_id)
            ls_action_text = "Complete application intake for household:#{ls_household_name}"
            ls_instructions = "This is a system created task- application ID:#{arg_action_arguments_object.client_application_id} of household:#{ls_household_name} is assigned to you. Complete application intake process."
            work_task_object = WorkTask.set_work_task(li_task_type,#arg_task_type,
                                                     6587,#arg_beneficiary_type, - Client Application
                                                     arg_action_arguments_object.client_application_id,#arg_reference_id,
                                                     ls_action_text,#arg_action_text,
                                                     6342,#arg_assigned_to_type,# user
                                                     AuditModule.get_current_user.uid,#arg_assigned_to_id,
                                                     AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                     6366,#arg_task_category, - client
                                                     nil,#arg_client_id,
                                                     ldt_due_date,#arg_due_date,
                                                     ls_instructions,#arg_instructions,
                                                     2188,#arg_urgency,
                                                     '',#arg_notes,
                                                     6339 #arg_status
                                                    )
            work_task_objects << work_task_object
      when 2178
          # 6344 - "Assign Case Manager to Program Unit"
          ls_action_text = "Assign case manager to program unit for client:#{ls_client_name}"
          ls_instructions ="This is a system generated task to assign case manager to program unit:#{program_unit_object.id} of Client:#{ls_client_name}."
          work_task_object = WorkTask.set_work_task(2178,#arg_task_type,
                                                    6345,#arg_beneficiary_type, - program unit
                                                    program_unit_object.id,#arg_reference_id,
                                                    ls_action_text,#arg_action_text,
                                                    6343,#arg_assigned_to_type,# Local office
                                                    program_unit_object.processing_location,#arg_assigned_to_id,
                                                    AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                    6366,#arg_task_category, - client
                                                    client_object.id,#arg_client_id,
                                                    ldt_due_date,#arg_due_date,
                                                    ls_instructions,#arg_instructions,
                                                    2188,#arg_urgency,
                                                    '',#arg_notes,
                                                    6339 #arg_status
                                                    )
          work_task_objects << work_task_object

      when 6353
          provider_agreement_object = ProviderAgreement.find(arg_action_arguments_object.provider_agreement_id)
          ls_provider_name = Provider.get_provider_name(provider_agreement_object.provider_id)
          # ls_action_text = "Assign Eligibility Determination Worker to New Program Unit:#{program_unit_object.id}(#{ls_service_program}) for Client:#{ls_client_name}"
          ls_action_text = "Approve provider agreement for provider: #{ls_provider_name}."
          ls_local_office = CodetableItem.get_short_description (18)
          ls_instructions ="This is a system generated task for provider agreement between provider: #{ls_provider_name} and DWS. This task is assigned to: #{ls_local_office}.Local office manager/supervisor will approve this provider agreement."
          work_task_object = WorkTask.set_work_task(6353,#arg_task_type,
                                                    6354, #beneficiary_type # provider agreement
                                                    provider_agreement_object.id ,#arg_reference_id,
                                                    ls_action_text,#arg_action_text,
                                                    6343,#arg_assigned_to_type,# Local office
                                                    18,#arg_assigned_to_id,
                                                    AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                    6352,#arg_task_category, - provider
                                                    nil,#arg_client_id,
                                                    ldt_due_date,#arg_due_date,
                                                    ls_instructions,#arg_instructions,
                                                    2188,#arg_urgency,
                                                    '',#arg_notes,
                                                    6339 #arg_status
                                                    )
          work_task_objects << work_task_object

       when 6607
          # Approve CPP
          #  Now only called from complete CPP after reject
          if arg_action_arguments_object.reason == "REJECT_TO_REQUEST"
            # this is set only when resubmitting rejected CPP.
            if ProgramUnit.check_is_cpp_completed_by_program_unit_members(arg_action_arguments_object.program_unit_id)
              # only when all rejected cpp plans are resubmitted.
              # create approve CPP tasks to supervisor who rejected the CPP.
              cpp_requested_record_collection =  ProgramUnit.get_completed_cpp_for_adult_program_unit_members(arg_action_arguments_object.program_unit_id)
              if cpp_requested_record_collection.present?
                  cpp_requested_record_collection.each do |each_cpp|
                        client_object = Client.find(each_cpp.client_signature)
                        ls_client_name = client_object.get_full_name
                        ls_action_text = "Approve CPP for client:#{ls_client_name}"
                        ls_instructions ="This is a system generated task for approval of CPP for client:#{ls_client_name}, Program unit:#{arg_action_arguments_object.program_unit_id}."
                        work_task_object = WorkTask.set_work_task(6607,#arg_task_type,
                                                                6465,#arg_beneficiary_type, - Career Pathway Plan
                                                                each_cpp.id,#arg_reference_id,
                                                                ls_action_text,#arg_action_text,
                                                                6342,#arg_assigned_to_type,# User
                                                                arg_action_arguments_object.ownership_user_id,#arg_assigned_to_id,
                                                                AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                                6366,#arg_task_category, - client
                                                                client_object.id,#arg_client_id,
                                                                ldt_due_date,#arg_due_date,
                                                                ls_instructions,#arg_instructions,
                                                                2188,#arg_urgency,
                                                                '',#arg_notes,
                                                                6339 #arg_status
                                                                )
                      work_task_object.program_unit_id = arg_action_arguments_object.program_unit_id
                      work_task_objects << work_task_object
                  end # end of cpp_requested_record_collection
              end

            end
          end
          # program_unit_participation = ProgramUnitParticipation.is_program_unit_participation_exists?(arg_action_arguments_object.program_unit_id)
          # if program_unit_participation.blank? && program_unit_object.disposition_status != 6041 # "Denied"







          # end
      when 6464
          # Work on rejected CPP
          # get the cpp records for PGU
          cpp_rejected_collection = ProgramUnit.get_completed_cpp_for_adult_program_unit_members(arg_action_arguments_object.program_unit_id)
          if cpp_rejected_collection.present?
            cpp_rejected_collection.each do |cpp_object|
              client_object = Client.find(cpp_object.client_signature)
              ls_client_name = client_object.get_full_name
              ls_action_text = "Work on rejected CPP for client:#{ls_client_name}"
              ls_instructions ="The supervisor has rejected all CPP plans associated with program unit: #{arg_action_arguments_object.program_unit_id},because of following
                            reason: #{arg_action_arguments_object.reason}.Please review all the client's CPP plan(s) and resubmit for approval."
              li_user_to_be_assigned = cpp_object.case_worker_signature
              work_task_object = WorkTask.set_work_task(6464,#arg_task_type,
                                          6465,#arg_beneficiary_type, - Career Pathway Plan
                                          cpp_object.id,#arg_reference_id,
                                          ls_action_text,#arg_action_text,
                                          6342,#arg_assigned_to_type,# User
                                          li_user_to_be_assigned,#arg_assigned_to_id,
                                          AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                          6366,#arg_task_category, - client
                                          client_object.id,#arg_client_id,
                                          ldt_due_date,#arg_due_date,
                                          ls_instructions,#arg_instructions,
                                          2188,#arg_urgency,
                                          '',#arg_notes,
                                          6339 #arg_status
                                          )
                work_task_object.program_unit_id = arg_action_arguments_object.program_unit_id
                work_task_objects << work_task_object

            end
          end



      when 6459
          # Work on Rejected Provider Agreement
          provider_agreement_obj = ProviderAgreement.find(arg_action_arguments_object.provider_agreement_id)
          ls_provider_name = Provider.get_provider_name(provider_agreement_obj.provider_id)
          # Work on Rejected Provider Agreement
          ls_action_text = "Work on rejected provider agreement for provider: #{ls_provider_name}."
          ls_instructions ="This is a system generated task to acknowledge that supervisor rejected your request to approve the provider agreement for provider: #{ls_provider_name}.
                            Please work on the provider agreement and resubmit for approval."
          provider_agreement_transition_obj = ProviderAgreementStateTransition.get_latest_transition_record(arg_action_arguments_object.provider_invoice_id)
          li_user_to_be_assigned = provider_agreement_transition_obj.present? ? provider_agreement_transition_obj.created_by : 0
          work_task_object = WorkTask.set_work_task(6459,#arg_task_type,
                                                    6354,#arg_beneficiary_type, - Provider Agreement
                                                    arg_action_arguments_object.provider_agreement_id,#arg_reference_id,
                                                    ls_action_text,#arg_action_text,
                                                    6342,#arg_assigned_to_type,# User
                                                    li_user_to_be_assigned,#arg_assigned_to_id,
                                                    AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                    6352,#arg_task_category, - provider
                                                    nil,#arg_client_id,
                                                    ldt_due_date,#arg_due_date,
                                                    ls_instructions,#arg_instructions,
                                                    2188,#arg_urgency,
                                                    '',#arg_notes,
                                                    6339 #arg_status
                                                    )
          work_task_objects << work_task_object

      when 6469
          # Request to approve Service Payment
          ldt_due_date = get_due_date(6469)
          provider_invoice_object = ProviderInvoice.find(arg_action_arguments_object.provider_invoice_id)
          service_authorization_object = ServiceAuthorization.find(provider_invoice_object.service_authorization_id)
          provider_object = Provider.find(service_authorization_object.provider_id)
          client_object = Client.find(service_authorization_object.client_id)
          ls_action_text = "Work on provider invoice approval for provider: #{provider_object.provider_name}."
          ls_instructions = "This is a system generated task to work on approving invoice: (#{arg_action_arguments_object.provider_invoice_id}) for provider : #{provider_object.provider_name}."
          if provider_invoice_object.payment_approver_id.present? #&& amount_above_threshold
            work_task_object = WorkTask.set_work_task(6469,#arg_task_type,
                                                      6383,#arg_beneficiary_type, - "Provider Invoice"
                                                      arg_action_arguments_object.provider_invoice_id,#arg_reference_id,
                                                      ls_action_text,#arg_action_text,
                                                      6342,#arg_assigned_to_type,# User
                                                      provider_invoice_object.payment_approver_id,#arg_assigned_to_id,
                                                      AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                      6352,#arg_task_category, -provider
                                                      client_object.id,#arg_client_id,
                                                      ldt_due_date,#arg_due_date,
                                                      ls_instructions,#arg_instructions,
                                                      2188,#arg_urgency,
                                                      '',#arg_notes,
                                                      6339 #arg_status
                                                      )
            work_task_objects << work_task_object
          end
      when 6470
          # "Request to Approve Service Payment is Rejected"
          ldt_due_date = get_due_date(6470)
          provider_invoice_object = ProviderInvoice.find(arg_action_arguments_object.provider_invoice_id)
          service_authorization_object = ServiceAuthorization.find(provider_invoice_object.service_authorization_id)
          provider_object = Provider.find(service_authorization_object.provider_id)
          client_object = Client.find(service_authorization_object.client_id)
          ls_client_name = client_object.get_full_name
          ls_action_text = "Work on the rejected provider invoice for provider:#{provider_object.provider_name}, (Provider inoice ID: #{provider_invoice_object.id})."
          ls_instructions ="This is a system generated task to work on rejected provider invoice for provider: #{provider_object.provider_name} for client: #{ls_client_name}, (Provider inoice ID: #{provider_invoice_object.id}). Reason for rejection: #{provider_invoice_object.reason}."
          provider_invoice_transition_obj = ProviderInvoiceStateTransition.get_latest_transition_record(provider_invoice_object.id)
          li_user_to_be_assigned = provider_invoice_transition_obj.present? ? provider_invoice_transition_obj.created_by : 0
          work_task_object = WorkTask.set_work_task(6470,#arg_task_type,
                                                  6383,#arg_beneficiary_type, - Provider invoice
                                                  arg_action_arguments_object.provider_invoice_id,#arg_reference_id,
                                                  ls_action_text,#arg_action_text,
                                                  6342,#arg_assigned_to_type, - User
                                                  li_user_to_be_assigned,#arg_assigned_to_id,
                                                  AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                  6352,#arg_task_category, -provider
                                                  client_object.id,#arg_client_id,
                                                  ldt_due_date,#arg_due_date,
                                                  ls_instructions,#arg_instructions,
                                                  2188,#arg_urgency,
                                                  '',#arg_notes,
                                                  6339 #arg_status
                                                 )
          work_task_objects << work_task_object

          when 6491
          # Request to approve Service Payment
          service_authorization_line_item_obj = ServiceAuthorizationLineItem.find(arg_action_arguments_object.service_authorization_line_item_id)
          ls_provider_name = Provider.find(arg_action_arguments_object.provider_id).provider_name
          provider_invoice_obj = ProviderInvoice.find(service_authorization_line_item_obj.provider_invoice_id)
          # Work on Rejected Provider Agreement
          ls_action_text = "Approve provider invoice for provider:#{ls_provider_name}, (Provider Invoice: #{provider_invoice_obj.id})."
          ls_instructions ="This is a system generated task to approve provider invoice for provider: #{ls_provider_name} for client: #{ls_client_name}, (Provider Invoice: #{provider_invoice_obj.id})."
          work_task_object = WorkTask.set_work_task(6491,#arg_task_type,
                                                  6383,#arg_beneficiary_type, - Provider Invoice
                                                  provider_invoice_obj.id,#arg_reference_id,
                                                  ls_action_text,#arg_action_text,
                                                  6343,#arg_assigned_to_type, - local office
                                                  18,#arg_assigned_to_id, Little Rock Workforce Center
                                                  AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                  6352,#arg_task_category, -provider
                                                  arg_action_arguments_object.client_id,#arg_client_id,
                                                  ldt_due_date,#arg_due_date,
                                                  ls_instructions,#arg_instructions,
                                                  2188,#arg_urgency,
                                                  '',#arg_notes,
                                                  6339 #arg_status
                                                 )
          work_task_objects << work_task_object

          when 6492
          # "Request to Approve Provider Invoice is Rejected"
          ls_provider_name = Provider.find(arg_action_arguments_object.provider_id).provider_name
          provider_invoice_obj = ProviderInvoice.find(arg_action_arguments_object.provider_invoice_id)
          # Work on Rejected Provider Invoice
          ls_action_text = "Work on the rejected provider invoice for provider:#{ls_provider_name}, (Provider Invoice: #{arg_action_arguments_object.provider_invoice_id})."
          ls_instructions ="This is a system generated task to work on the rejected provider invoice for provider: #{ls_provider_name} for client: #{ls_client_name}, (Provider Invoice: #{arg_action_arguments_object.provider_invoice_id})."
          provider_invoice_transition_obj = ProviderInvoiceStateTransition.get_latest_transition_record(arg_action_arguments_object.provider_invoice_id)
          li_user_to_be_assigned = provider_invoice_transition_obj.present? ? provider_invoice_transition_obj.created_by : 0
          work_task_object = WorkTask.set_work_task(6492,#arg_task_type,
                                                  6383,#arg_beneficiary_type, - Provider Invoice
                                                  arg_action_arguments_object.provider_invoice_id,#arg_reference_id,
                                                  ls_action_text,#arg_action_text,
                                                  6342,#arg_assigned_to_type, - User
                                                  li_user_to_be_assigned,#arg_assigned_to_id,
                                                  AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                  6352,#arg_task_category, -provider
                                                  arg_action_arguments_object.client_id,#arg_client_id,
                                                  ldt_due_date,#arg_due_date,
                                                  ls_instructions,#arg_instructions,
                                                  2188,#arg_urgency,
                                                  '',#arg_notes,
                                                  6339 #arg_status
                                                 )
          work_task_objects << work_task_object


          when 6388 # "Work on First Time benefit Rejected program unit"
          ls_action_text = "Work on supervisor rejected #{ls_service_program} program unit for client:#{ls_client_name}."

          # program_unit_transition_obj = ProgramUnitStateTransition.where("program_unit_id = ? and event = 'reject'",arg_action_arguments_object.program_unit_id).order("created_at DESC").first
          # program_unit_transition_obj = ProgramUnitStateTransition.get_latest_transition_record(arg_action_arguments_object.program_unit_id)
          ls_instructions = "This is a system generated work task. Supervisor rejected the approval of first time benefit amount for #{ls_service_program} program unit for client:#{ls_client_name}, work on the program unit and resubmit program unit for approval. Rejection reason: #{arg_action_arguments_object.reason}."
          # li_case_manager_id = program_unit_transition_obj.present? ? program_unit_transition_obj.created_by : 0
          li_ed_worker_id = program_unit_object.eligibility_worker_id
          work_task_object = WorkTask.set_work_task(6388, # arg_task_type = "Work on First Time benefit Rejected program unit"
                                                     6345, #arg_beneficiary_type = program unit
                                                     arg_action_arguments_object.program_wizard_id,# arg_reference_id
                                                     ls_action_text,# arg_action_text
                                                     6342, # arg_assigned_to_type = User
                                                     li_ed_worker_id,# arg_assigned_to_id
                                                     AuditModule.get_current_user.uid, #arg_assigned_by_user_id
                                                     6366,# arg_task_category = client
                                                     client_object.id,#arg_client_id
                                                     ldt_due_date, #arg_due_date
                                                     ls_instructions, # arg_instructions
                                                     2188, #  arg_urgency = High
                                                     '',#arg_notes
                                                     6339#arg_status = {pending}
                                                     )
          work_task_object.program_unit_id = program_unit_object.id
          work_task_objects << work_task_object

      when 6344 # "Assign Case Manager to Program Unit"
          ls_action_text = "Assign case manager to program unit for client:#{ls_client_name}."
          ls_instructions = "This is a system generated task to assign case manager to program unit:#{program_unit_object.id} for client:#{ls_client_name}."
          work_task_object = WorkTask.set_work_task(6344,#arg_task_type,
                                                    6345,#arg_beneficiary_type, - program unit
                                                    program_unit_object.id,#arg_reference_id,
                                                    ls_action_text,#arg_action_text,
                                                    6343,#arg_assigned_to_type,# Local office
                                                    program_unit_object.processing_location,#arg_assigned_to_id,
                                                    AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                    6366,#arg_task_category, - client
                                                    client_object.id,#arg_client_id,
                                                    ldt_due_date,#arg_due_date,
                                                    ls_instructions,#arg_instructions,
                                                    2188,#arg_urgency,
                                                    '',#arg_notes,
                                                    6339 #arg_status
                                                   )
          work_task_objects << work_task_object

          when 6387 # "Complete work readiness Assessment and CPP"
            ls_action_text = "Work on the assessment for client:#{ls_client_name}"
            ls_instructions = "This is a system created task- program unit:#{arg_action_arguments_object.model_object.id} of client:#{ls_client_name} is assigned to you. Complete assessment for the client."
            work_task_object = WorkTask.set_work_task(6387,#arg_task_type,
                                                     6510,#arg_beneficiary_type, - client
                                                     client_object.id,#arg_reference_id,
                                                     ls_action_text,#arg_action_text,
                                                     6342,#arg_assigned_to_type,# user
                                                     arg_action_arguments_object.model_object.case_manager_id,#arg_assigned_to_id,
                                                     AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                     6366,#arg_task_category, - client
                                                     client_object.id,#arg_client_id,
                                                     ldt_due_date,#arg_due_date,
                                                     ls_instructions,#arg_instructions,
                                                     2188,#arg_urgency,
                                                     '',#arg_notes,
                                                     6339 #arg_status
                                                    )
            work_task_object.program_unit_id = arg_action_arguments_object.model_object.id
            work_task_objects << work_task_object

          when 2155 # "Identify Program Units"
            ls_action_text = "Identify eligible program units for client:#{ls_client_name}"
            ls_instructions = "This is a system created task - Identify program units is assigned to you. Select eligible program units for client:#{ls_client_name}."
            work_task_object = WorkTask.set_work_task(2155,#arg_task_type,
                                                       6587,#arg_beneficiary_type, - client application
                                                       arg_action_arguments_object.model_object.id,#arg_reference_id,
                                                       ls_action_text,#arg_action_text,
                                                       6342,#arg_assigned_to_type,# Local office
                                                       arg_action_arguments_object.model_object.application_processor,#arg_assigned_to_id,
                                                       AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                       6366,#arg_task_category, - client
                                                       client_object.id,#arg_client_id,
                                                       ldt_due_date,#arg_due_date,
                                                       ls_instructions,#arg_instructions,
                                                       2188,#arg_urgency,
                                                       '',#arg_notes,
                                                       6339 #arg_status
                                                      )
            # work_task_object.program_unit_id = arg_action_arguments_object.model_object.id
            work_task_objects << work_task_object

          when 6346 # "Complete program unit and determine eligibility"
            srvc_pgm_name = ServiceProgram.service_program_description(program_unit_object.service_program_id)
            ls_action_text = "Determine eligibility for the #{srvc_pgm_name} program unit for: #{ls_client_name}."
            ls_instructions = "This is a system created task- #{srvc_pgm_name} program unit is assigned to you. Complete and determine eligibility of the program unit for: #{ls_client_name}"
            work_task_object = WorkTask.set_work_task(6346,#arg_task_type,
                                                       6345,#arg_beneficiary_type, - program unit
                                                       program_unit_object.id,#arg_reference_id,
                                                       ls_action_text,#arg_action_text,
                                                       6342,#arg_assigned_to_type,# Local office
                                                       program_unit_object.eligibility_worker_id,#arg_assigned_to_id,
                                                       AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                       6366,#arg_task_category, - client
                                                       client_object.id,#arg_client_id,
                                                       ldt_due_date,#arg_due_date,
                                                       ls_instructions,#arg_instructions,
                                                       2188,#arg_urgency,
                                                       '',#arg_notes,
                                                       6339 #arg_status
                                                      )
            work_task_object.program_unit_id = program_unit_object.id
            work_task_objects << work_task_object

          when 2142
            if arg_action_arguments_object.model_object.present?
              model_object = arg_action_arguments_object.model_object
            elsif arg_action_arguments_object.event_id == 834 # Sanction Detail New Entry
              model_object = SanctionDetail.new
            elsif arg_action_arguments_object.event_id == 778 # OutOfStatePayments
              model_object = OutOfStatePayment.new
            end
            model_name = model_object.class.name
            # attribute_name = RubyElement.find(arg_action_arguments_object.event_id).element_title
            # humanized_attr_name = arg_action_arguments_object.model_object.class.human_attribute_name(attribute_name)
            if arg_action_arguments_object.event_id == 778
              humanized_attr_name = "Out of state payments"
            else
              humanized_attr_name = arg_action_arguments_object.changed_attributes.map{|i| model_object.class.human_attribute_name(i)}.to_sentence
              humanized_attr_name = "#{model_name} #{humanized_attr_name}" unless humanized_attr_name.include? model_name
            end
            if client_object.present?
              ls_instructions = "#{humanized_attr_name} information changed for client: #{client_object.get_full_name} in program_unit: #{program_unit_object.id}, run eligiblity determination and submit the run. "
              ls_action_text = "#{humanized_attr_name} information changed for client: #{ls_client_name}. Redetermine eligibility and submit the run"
            end

            beneficiary_type = nil
            can_create_work_task = false
            case arg_action_arguments_object.event_id
            when 755,757,759,816 # "Client - dob, citizenship, date of death, residency"
              beneficiary_type = 6510
              can_create_work_task = true
            when 779..783 # "Income field changes"
              beneficiary_type = 6374 # "Income"
              can_create_work_task = true
            when 760,786,787,788,789 # "IncomeDetail field changes"
              beneficiary_type = 6508 # "Income Detail"
              can_create_work_task = true
            when 790 # "IncomeDetailAdjustReason - adjusted_amount"
              beneficiary_type = 6790 # "IncomeDetailAdjustReason"
              can_create_work_task = true
            when 793,794,795 # "Resource field changes"
              beneficiary_type = 6375 # "Resource"
              can_create_work_task = true
            when 796,797,798 # "ResourceDetail field changes"
              beneficiary_type = 6509 # "Resource Details"
              can_create_work_task = true
            when 799..802 # "Resource Adjustment field changes"
              beneficiary_type = 6779 # "Resource Adjustment"
              can_create_work_task = true
            when 803 # "ResourceUse"
              beneficiary_type = 6780 # "Resource Use"
              can_create_work_task = true
            when 778 # "OutOfStatePayments - save"
              beneficiary_type = 6791 # "OutOfStatePayments"
              can_create_work_task = true
            when 762..767 # "Address field changes"
              beneficiary_type = 6377 # "Address"
              if arg_action_arguments_object.entity_type == 6150
                can_create_work_task = true
              end
            when 769,770,771 # "ClientCharacteristic"
              beneficiary_type = 6781 # ClientCharacteristic
              can_create_work_task = true
              ed_reason = nil
              characteristic_type = arg_action_arguments_object.model_object.characteristic_type
              characteristic_id = arg_action_arguments_object.model_object.characteristic_id.to_i
              case characteristic_type
              when "WorkCharacteristic"
                ed_reason = 6532 # "Work Participation Characteristic Changed"
              when "LegalCharacteristic"
                # ed_reason = 6533 # "Legal Characteristic Changed"
                # if arg_event_action_mapping_object.event_type == 771
                  # can_create_work_task = false
                # else
                  case characteristic_id
                  when 5611 # "Felony Drug Conviction"
                    ed_reason = 6596 # "Drug conviction Information Changed"
                  when 5612 # "Fleeing Felon"
                    ed_reason = 6595 # "Fleeing Felon Information Changed"
                  when 5614,5631,5632 # "IPV"
                    ed_reason = 6594 # "IPV Information Changed"
                  when 5616 # "Gang Activity"
                    ed_reason = 6597 # "Gang activity Information Changed"
                  end
                # end
              when "OtherCharacteristic"
                ed_reason = nil
                # create an entry for ED for other characteristic type is either "Family Cap" or "No School Attendance"
                if characteristic_id == 5610 # "Family Cap Child"
                  ed_reason = 6534 # "Other Characteristic Family Cap Information Changed"
                elsif characteristic_id == 6541 # "No school attendance"
                  ed_reason = 6583 # "Other Characteristic No School Attendance Information Changed"
                end
                can_create_work_task = false
                if ed_reason.present?
                  can_create_work_task = true
                  # if arg_object.is_a_new_record
                  #   can_create_work_task = true
                  # elsif arg_event_action_mapping_object.event_type == 770 || arg_event_action_mapping_object.event_type == 769# In case of edit the start date change should only trigger an ed entry
                  #   can_create_work_task = true
                  # end
                end
              when "DisabilityCharacteristic"
                can_create_work_task = false
              end
              if ed_reason.present?
                changed_info = CodetableItem.get_short_description (ed_reason)
                ls_instructions = "#{changed_info} for client: #{client_object.get_full_name} in program_unit: #{program_unit_object.id}, run eligiblity determination and submit the run. "
                ls_action_text = "#{changed_info} for client: #{ls_client_name}. Redetermine eligibility and submit the run"
              end
            when 825, 834 # "SanctionDetail"
              beneficiary_type = 6782 # "SanctionDetail"
              if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_action_arguments_object.client_id) &&
                        (arg_action_arguments_object.is_a_new_record || arg_action_arguments_object.model_object.release_indicatior == '1')
                program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_action_arguments_object.client_id)
                case arg_action_arguments_object.sanction_type
                when 3081 # "Immunizations"
                  ed_reason = 6598 # "Immunizations Sanction"
                when 3062 # "OCSE Non-Compliance"
                  ed_reason = 6599 # "OCSE Sanction"
                when 3064,3067,3068,3070,3073,3085 # Progressive Sanction
                  ed_reason = 6600 # "Progressive Sanction"
                when 6349 # "Refusal to sign PRA by minor parent"
                  ed_reason = 6601 # "Refusal to sign PRA by minor parent"
                when 6225 # #Class Attendance-Minor Parent
                  ed_reason = 6602 # "Class attendance-minor parent"
                end
              end
              if ed_reason.present?
                can_create_work_task = true
                if arg_action_arguments_object.model_object.present? && arg_action_arguments_object.model_object.release_indicatior.present?
                  released_or_applied = arg_action_arguments_object.model_object.release_indicatior == '0' ? "applied" : "released"
                  changed_info = "Sanction: #{CodetableItem.get_short_description (ed_reason)} is #{released_or_applied}"
                  ls_instructions = "#{changed_info} for client: #{client_object.get_full_name} in program_unit: #{program_unit_object.id}, run eligiblity determination and submit the run. "
                  ls_action_text = "#{changed_info} for client: #{ls_client_name}. Redetermine eligibility and submit the run"
                end
              end
            when 791,792 # "Employment" - "effective_begin_date", "effective_end_date"
              client_age = Client.get_age(arg_action_arguments_object.client_id)
              if ProgramUnitMember.is_the_client_active_in_work_pays_program_unit(arg_action_arguments_object.client_id)
                can_create_work_task = true
                beneficiary_type = 6783 # "Employment"
              end
            when 827..832 # "EmploymentDetail" - "current_status", "effective_begin_date", "effective_end_date", "salary_pay_amt", "salary_pay_frequency", "hours_per_period"
              client_is_active_adult_in_workpays = ProgramUnitMember.is_the_client_adult_and_active_in_work_pays_program_unit(arg_action_arguments_object.client_id)
              if true#client_is_active_adult_in_workpays.present?
                can_create_work_task = true
                beneficiary_type = 6784 # "EmploymentDetail"
              end
            end
            if arg_action_arguments_object.model_object.present?
              reference_id = arg_action_arguments_object.model_object.id
            elsif arg_action_arguments_object.event_id == 834 # Sanction Detail New Entry
              reference_id = arg_action_arguments_object.sanction_detail_id
            elsif arg_action_arguments_object.event_id == 778 # OutOfStatePayments
              reference_id = arg_action_arguments_object.out_of_state_payment_id
            end
            if can_create_work_task
              work_task_object =  WorkTask.set_work_task(2142, # arg_task_type = ED data change
                                   beneficiary_type, #arg_beneficiary_type = program unit
                                   reference_id,# arg_reference_id
                                   ls_action_text,# arg_action_text
                                   6342, # arg_assigned_to_type = User
                                   program_unit_object.eligibility_worker_id,# arg_assigned_to_id
                                   AuditModule.get_current_user.uid, #arg_assigned_by_user_id
                                   6366,# arg_task_category = client
                                   client_object.id,#arg_client_id
                                   ldt_due_date, #arg_due_date
                                   ls_instructions, # arg_instructions
                                   2188, #  arg_urgency = High
                                   '',#arg_notes
                                   6339#arg_status = {pending}
                                   )
              work_task_object.program_unit_id = program_unit_object.id
              work_task_objects << work_task_object
            end
          when 6576 # "Close Program Unit"
            if ActionPlan.an_open_action_plan_exist(arg_action_arguments_object.client_id) && arg_action_arguments_object.selected_pgu_action ==  6100
              ls_action_text = "Close necessary activities for client :#{ls_client_name}."
              ls_instructions ="This is a system generated task to close necessary activities for #{ls_service_program} program unit:#{program_unit_object.id} for client:#{ls_client_name}."
              li_assigned_to =  program_unit_object.case_manager_id
              work_task_object = WorkTask.set_work_task(li_task_type,#arg_task_type,
                                                      6345,#arg_beneficiary_type, "Program Wizard"
                                                      arg_action_arguments_object.program_unit_id,#arg_reference_id,
                                                      ls_action_text,#arg_action_text,
                                                      6342,#arg_assigned_to_type, - "User"
                                                      li_assigned_to,#arg_assigned_to_id,
                                                      AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                      6366,#arg_task_category, "Client"
                                                      client_object.id,#arg_client_id,
                                                      ldt_due_date,#arg_due_date,
                                                      ls_instructions,#arg_instructions,
                                                      2188,#arg_urgency,
                                                      '',#arg_notes,
                                                      6339 #arg_status
                                                     )
              work_task_object.program_unit_id = arg_action_arguments_object.program_unit_id
              work_task_objects << work_task_object
            end
          when 6593 # "Complete Application Screening"
            # ls_action_text = "Complete Application Processing for client:#{ls_client_name}"
            ls_household_name = Household.get_household_name_from_application_id(arg_action_arguments_object.client_application_id)
            ls_action_text = "Complete application processing for household:#{ls_household_name}."
            ls_instructions = "This is a system created task- application ID:#{arg_action_arguments_object.client_application_id} of household:#{ls_household_name} is assigned to you. Complete application processing."
            work_task_object = WorkTask.set_work_task(6593,#arg_task_type,
                                                     6587,#arg_beneficiary_type, - Client Application
                                                     arg_action_arguments_object.client_application_id,#arg_reference_id,
                                                     ls_action_text,#arg_action_text,
                                                     6342,#arg_assigned_to_type,# user
                                                     AuditModule.get_current_user.uid,#arg_assigned_to_id,
                                                     AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                     6366,#arg_task_category, - client
                                                     nil,#arg_client_id,
                                                     ldt_due_date,#arg_due_date,
                                                     ls_instructions,#arg_instructions,
                                                     2188,#arg_urgency,
                                                     '',#arg_notes,
                                                     6339 #arg_status
                                                    )
            work_task_objects << work_task_object

          when 6633 # "Request for Approval of benefit amount"
              # Rails.logger.debug("MNP - task type = 6633 -case")
              if ProgramUnitParticipation.is_program_unit_participation_status_open(program_unit_object.id) == false
                 client_name = ProgramUnitMember.get_primary_beneficiary_name(program_unit_object.id)
                 ldt_due_date = get_due_date(6605)
                 ls_action_text = "Request first time benefit amount approval for program unit: #{program_unit_object.id}, self of program unit is #{client_name}."
                 ls_instructions = "This is a system created task- Request first time benefit amount approval for program unit: #{program_unit_object.id}, self of program unit is #{client_name}."
                  # check if program unit is present in Assessment completed Queue - that means this program unit does not need CPP.
                  # It will go from Assessment completed queue to request for benefit amount queue, hence we need task 6633
                  assessment_completed_queue_collection = WorkQueue.where("state = 6631 and reference_type = 6345 and reference_id = ?",program_unit_object.id)
                  if assessment_completed_queue_collection.present?
                      work_task_object = WorkTask.set_work_task(6633,#arg_task_type,
                                                               6345,#arg_beneficiary_type, - program unit
                                                               arg_action_arguments_object.program_unit_id,#program unit id,
                                                               ls_action_text,#arg_action_text,
                                                               6342,#arg_assigned_to_type,# user
                                                               program_unit_object.eligibility_worker_id,#arg_assigned_to_id,
                                                               AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                               6366,#arg_task_category, - client
                                                               client_object.id,#arg_client_id,
                                                               ldt_due_date,#arg_due_date,
                                                               ls_instructions,#arg_instructions,
                                                               2188,#arg_urgency,
                                                               '',#arg_notes,
                                                               6339 #arg_status
                                                              )
                      work_task_object.program_unit_id = arg_action_arguments_object.program_unit_id
                      work_task_objects << work_task_object


                  else
                    # is the state present in approved CPP for PGU ?
                    cpp_for_pgu_completed_queue_collection = WorkQueue.where("state = 6626 and reference_type = 6345 and reference_id = ?",program_unit_object.id)
                    if cpp_for_pgu_completed_queue_collection.present?
                      work_task_object = WorkTask.set_work_task(6633,#arg_task_type,
                                                               6345,#arg_beneficiary_type, - program unit
                                                               arg_action_arguments_object.program_unit_id,#program unit id,
                                                               ls_action_text,#arg_action_text,
                                                               6342,#arg_assigned_to_type,# user
                                                               program_unit_object.eligibility_worker_id,#arg_assigned_to_id,
                                                               AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                               6366,#arg_task_category, - client
                                                               client_object.id,#arg_client_id,
                                                               ldt_due_date,#arg_due_date,
                                                               ls_instructions,#arg_instructions,
                                                               2188,#arg_urgency,
                                                               '',#arg_notes,
                                                               6339 #arg_status
                                                              )
                      work_task_object.program_unit_id = arg_action_arguments_object.program_unit_id
                      work_task_objects << work_task_object

                    end
                  end
              end



      when 6621 # "Create work task for assignments done on queue tasks"
          case arg_action_arguments_object.ownership_type
          when 6619 # "CPP Approval"
              ldt_due_date = get_due_date(6607)
              ls_action_text = "Approve career plan for client:#{ls_client_name}"
              ls_instructions = "This is a system created task to approve career plan for client:#{ls_client_name} of program unit: #{program_unit_object.id}."
              work_task_object = WorkTask.set_work_task(6607,#arg_task_type,
                                                        6465,#arg_beneficiary_type, - Career Pathway Plan
                                                        arg_action_arguments_object.cpp_id,#arg_reference_id,
                                                        ls_action_text,#arg_action_text,
                                                        6342,#arg_assigned_to_type,# user
                                                        arg_action_arguments_object.user_id,#arg_assigned_to_id,
                                                        AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                        6366,#arg_task_category, - client
                                                        client_object.id,#arg_client_id,
                                                        ldt_due_date,#arg_due_date,
                                                        ls_instructions,#arg_instructions,
                                                        2188,#arg_urgency,
                                                        '',#arg_notes,
                                                        6339 #arg_status
                                                        )
              work_task_object.program_unit_id = arg_action_arguments_object.program_unit_id
              work_task_objects << work_task_object

          when 6620 # "Benefit Amount Approval"

            ls_action_text = "Approve benefit amount for #{ls_service_program} program unit for client:#{ls_client_name}."
            ls_instructions ="This is a system generated task to approve first time benefit amount for #{ls_service_program} program unit:#{program_unit_object.id} for client:#{ls_client_name}."
            ldt_due_date = get_due_date(2172)
            work_task_object = WorkTask.set_work_task(2172,#arg_task_type,
                                                      6378,#arg_beneficiary_type, "Program Wizard"
                                                      arg_action_arguments_object.program_wizard_id,#arg_reference_id,
                                                      ls_action_text,#arg_action_text,
                                                      6342,#arg_assigned_to_type, - user
                                                       arg_action_arguments_object.user_id,#arg_assigned_to_id,
                                                      AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                      6366,#arg_task_category, "Client"
                                                      client_object.id,#arg_client_id,
                                                      ldt_due_date,#arg_due_date,
                                                      ls_instructions,#arg_instructions,
                                                      2188,#arg_urgency,
                                                      '',#arg_notes,
                                                      6339 #arg_status
                                                      )
            program_wizard = ProgramWizard.find(arg_action_arguments_object.program_wizard_id)
            work_task_object.program_unit_id = program_wizard.program_unit_id
            work_task_objects << work_task_object

          when 6623 # "Employment Planning"
              ldt_due_date = get_due_date(6605)
              ls_action_text = "Work on employment planning and career plan for client:#{ls_client_name}."
              ls_instructions = "This is a system created task- Program unit:#{program_unit_object.id} of client:#{ls_client_name} is assigned to you. Work on employment planning and career plan for the client."
              work_task_object = WorkTask.set_work_task(6605,#arg_task_type,
                                                       6510,#arg_beneficiary_type, - client
                                                       arg_action_arguments_object.client_id,#arg_reference_id,
                                                       ls_action_text,#arg_action_text,
                                                       6342,#arg_assigned_to_type,# user
                                                       arg_action_arguments_object.user_id,#arg_assigned_to_id,
                                                       AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                       6366,#arg_task_category, - client
                                                       client_object.id,#arg_client_id,
                                                       ldt_due_date,#arg_due_date,
                                                       ls_instructions,#arg_instructions,
                                                       2188,#arg_urgency,
                                                       '',#arg_notes,
                                                       6339 #arg_status
                                                      )
              work_task_object.program_unit_id = arg_action_arguments_object.program_unit_id
              work_task_objects << work_task_object
          when 6642
              ldt_due_date = get_due_date(2168)
              sanction_object =  Sanction.find(arg_action_arguments_object.sanction_id)
              ls_action_text = "Work on sanctions for client:#{ls_client_name}"
              ls_instructions = "This is a system generated task to work on sanction for client: #{ls_client_name}. Review the client details and check if sanctions is needed for the client"
              work_task_object = WorkTask.set_work_task(2168,#arg_task_type - sanction,
                                                        6367,#arg_beneficiary_type, - Sanction
                                                        sanction_object.id,#arg_reference_id,
                                                        ls_action_text,#arg_action_text,
                                                        6342,#arg_assigned_to_type,# User
                                                        sanction_object.compliance_office_id,#arg_assigned_to_id,
                                                        AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                        6366,#arg_task_category, - client
                                                        sanction_object.client_id,#arg_client_id,
                                                        ldt_due_date,#arg_due_date,
                                                        ls_instructions,#arg_instructions,
                                                        2188,#arg_urgency,
                                                        '',#arg_notes,
                                                        6339 #arg_status
                                                        )
              work_task_objects << work_task_object
          when 6649
            ldt_due_date = get_due_date(2154)
            ls_action_text = "Work on re-evaluation for client:#{ls_client_name}."
            ls_instructions = "This is a system generated task to work on re-evaluation for client: #{ls_client_name}. Review the client details and check re-evaluation for the client."
            work_task_object = WorkTask.set_work_task(2154,#arg_task_type - Re evaluation,
                                                      6345,#arg_beneficiary_type, - program unit
                                                      program_unit_object.id,#arg_reference_id,
                                                      ls_action_text,#arg_action_text,
                                                      6342,#arg_assigned_to_type,# User
                                                      arg_action_arguments_object.user_id,#arg_assigned_to_id,
                                                      AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                      6366,#arg_task_category, - client
                                                      client_object.id,#arg_client_id,
                                                      ldt_due_date,#arg_due_date,
                                                      ls_instructions,#arg_instructions,
                                                      2188,#arg_urgency,
                                                      '',#arg_notes,
                                                      6339 #arg_status
                                                      )
            work_task_objects << work_task_object

          # when 6717
          #   ldt_due_date = get_due_date(6718) #6718 prescreening process
          #   primary_household_member = HouseholdMember.get_head_of_household_member(arg_action_arguments_object.household_id).first
          #   client_object = Client.find(primary_household_member.client_id)
          #   ls_client_name = client_object.get_full_name
          #   ls_action_text = "Work on prescreening for client: #{ls_client_name}."
          #   ls_instructions = "This is a system generated task to work on initiating intake process for client: #{ls_client_name}."
          #   work_task_object = WorkTask.set_work_task(6718,#arg_task_type -prescreening process,
          #                                             6721,#arg_beneficiary_type, - client
          #                                             arg_action_arguments_object.household_id,#arg_reference_id,
          #                                             ls_action_text,#arg_action_text,
          #                                             6342,#arg_assigned_to_type,# User
          #                                             arg_action_arguments_object.user_id,#arg_assigned_to_id,
          #                                             AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
          #                                             6366,#arg_task_category, - client
          #                                             primary_household_member.client_id,#arg_client_id,
          #                                             ldt_due_date,#arg_due_date,
          #                                             ls_instructions,#arg_instructions,
          #                                             2188,#arg_urgency,
          #                                             '',#arg_notes,
          #                                             6339 #arg_status
          #                                             )
          #   work_task_objects << work_task_object
          when 6654
            #provider payment approval
            ldt_due_date = get_due_date(6469) #6491 "Request to approve Provider Invoice"
            provider_invoice_object = ProviderInvoice.find(arg_action_arguments_object.provider_invoice_id)
            service_authorization_object = ServiceAuthorization.find(provider_invoice_object.service_authorization_id)
            # service_authorization_line_item_object = ServiceAuthorizationLineItem.find(arg_action_arguments_object.service_authorization_line_item_id)
            # service_authorization_object = ServiceAuthorization.find(service_authorization_line_item_object.service_authorization_id)
            provider_object = Provider.find(service_authorization_object.provider_id)
            client_object = Client.find(service_authorization_object.client_id)
            # ls_client_name = client_object.get_full_name
            ls_action_text = "Work on provider invoice approval for provider: #{provider_object.provider_name}."
            ls_instructions = "This is a system generated task to work on approving invoice: (#{arg_action_arguments_object.provider_invoice_id}) for provider : #{provider_object.provider_name}."
            work_task_object = WorkTask.set_work_task(6469,#arg_task_type,
                                                      6383,#arg_beneficiary_type, - "Provider Invoice"
                                                      arg_action_arguments_object.provider_invoice_id,#arg_reference_id,
                                                      ls_action_text,#arg_action_text,
                                                      6342,#arg_assigned_to_type,# User
                                                      arg_action_arguments_object.user_id,#arg_assigned_to_id,
                                                      AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                      6352,#arg_task_category, - provider
                                                      client_object.id,#arg_client_id,
                                                      ldt_due_date,#arg_due_date,
                                                      ls_instructions,#arg_instructions,
                                                      2188,#arg_urgency,
                                                      '',#arg_notes,
                                                      6339 #arg_status
                                                      )
            work_task_objects << work_task_object
          end # case arg_action_arguments_object.ownership_type
      when 6635 # "Work on the program unit, daily batch ED"
              ls_action_text = "Submit ED run for program unit:#{program_unit_object.id} for client:#{ls_client_name}."
              ls_instructions = "This is a system generated task to Submit new ED run for ED data changes on program unit:#{program_unit_object.id} for client:#{ls_client_name}. Daily Eligibility batch program created this task."
              work_task_object = WorkTask.set_work_task(6635,#arg_task_type,
                                                          6378,#arg_beneficiary_type, - "Program Wizard"
                                                          arg_action_arguments_object.program_wizard_id,#arg_reference_id,
                                                          ls_action_text,#arg_action_text,
                                                          6342,#arg_assigned_to_type,# User
                                                          program_unit_object.eligibility_worker_id,#arg_assigned_to_id,
                                                          AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                          6366,#arg_task_category, - client
                                                          arg_action_arguments_object.client_id,#arg_client_id,
                                                          ldt_due_date,#arg_due_date,
                                                          ls_instructions,#arg_instructions,
                                                          2188,#arg_urgency,
                                                          '',#arg_notes,
                                                          6339 #arg_status
                                                          )
              work_task_object.program_unit_id = program_unit_object.id
              work_task_objects << work_task_object

      when 6766
          ldt_due_date = get_due_date(6766)
          primary_contact = PrimaryContact.get_primary_contact(program_unit_object.id, 6345)
          client_object = Client.find(primary_contact.client_id)
          ls_client_name = client_object.get_full_name
          ls_action_text = "Program unit:#{program_unit_object.id} for client:#{ls_client_name} is transfered to new local office."
          ls_instructions = "This is a system generated task to work on program unit:#{program_unit_object.id} for client:#{ls_client_name}. Program unit is transfered to a different local office. Take necessary actions on this program unit."
          action_plan_object = ActionPlan.where("program_unit_id = ? and end_date is null",program_unit_object.id).order("id desc").first
          work_task_object = WorkTask.set_work_task(6766,#arg_task_type,
                                                    6345,#arg_beneficiary_type, - program unit
                                                    program_unit_object.id,#arg_reference_id,
                                                    ls_action_text,#arg_action_text,
                                                    6342,#arg_assigned_to_type,# User
                                                    program_unit_object.case_manager_id,#arg_assigned_to_id,
                                                    AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                    6366,#arg_task_category, - client
                                                    action_plan_object.client_id,#arg_client_id,
                                                    ldt_due_date,#arg_due_date,
                                                    ls_instructions,#arg_instructions,
                                                    2188,#arg_urgency,
                                                    '',#arg_notes,
                                                    6339 #arg_status
                                                    )
          work_task_objects << work_task_object
      when 6386
        ldt_due_date = get_due_date(6386)
        srvc_pgm_name = ServiceProgram.service_program_description(arg_action_arguments_object.model_object.service_program_id)
        Rails.logger.debug("arg_action_arguments_object.program_unit_id =  #{arg_action_arguments_object.model_object.id}")
        primary_contact = PrimaryContact.get_primary_contact(arg_action_arguments_object.model_object.id, 6345)
        client_object = Client.find(primary_contact.client_id)
        # program_unit_member = ProgramUnitMember.get_active_program_unit_members(arg_action_arguments_object.model_object.id).first
        # Rails.logger.debug("program_unit_member =  #{program_unit_member.inspect}")
        # client_object = Client.find(program_unit_member.client_id)
        ls_client_name = client_object.get_full_name
        ls_action_text = "Determine eligibility for the #{srvc_pgm_name} program unit for: #{ls_client_name}."
        ls_instructions = "This is a system created task- #{srvc_pgm_name} program unit is assigned to you. Complete and determine eligibility of the program unit for: #{ls_client_name}"
        work_task_object = WorkTask.set_work_task(6386,#arg_task_type,
                                                   6345,#arg_beneficiary_type, - program unit
                                                   arg_action_arguments_object.model_object.id,#arg_reference_id,
                                                   ls_action_text,#arg_action_text,
                                                   6342,#arg_assigned_to_type,# Local office
                                                   arg_action_arguments_object.model_object.eligibility_worker_id,#arg_assigned_to_id,
                                                   AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
                                                   6366,#arg_task_category, - client
                                                   client_object.id,#arg_client_id,
                                                   ldt_due_date,#arg_due_date,
                                                   ls_instructions,#arg_instructions,
                                                   2188,#arg_urgency,
                                                   '',#arg_notes,
                                                   6339 #arg_status
                                                  )
        work_task_object.program_unit_id = arg_action_arguments_object.model_object.id
        work_task_objects << work_task_object
      end # end of case li_task_type
    return work_task_objects

  end


  def self.get_due_date(arg_task_type)
    l_days_to_complete_task = SystemParam.get_key_value(18,arg_task_type.to_s,"Number of days to complete Task ")
    l_days_to_complete_task = l_days_to_complete_task.to_i
    ldt_due_date = Date.today + l_days_to_complete_task
    return ldt_due_date
  end


end