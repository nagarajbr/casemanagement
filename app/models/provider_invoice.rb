class ProviderInvoice < ActiveRecord::Base
	include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field


     has_many :service_authorization_line_items_invoices, dependent: :destroy

    HUMANIZED_ATTRIBUTES = {
      invoice_notes: "Notes",
      reason: "Rejection Reason"
    }
    def self.human_attribute_name(attr, options = {})
          HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

     # State machine state management start Kiran 07/21/2015
    state_machine :state, :initial => :requested do
        audit_trail context: [:created_by, :reason]
         # audit_trail context: :created_by

        # state :complete, value: 6165
        state :requested, value: 6373
        state :rejected, value: 6167
        state :approved, value: 6166

        event :approve do
          transition :requested => :approved
        end

        event :reject do
          transition :requested => :rejected
        end

        event :request do
          transition :rejected => :requested
        end



    end
  # State machine state management end Kiran 07/21/2015

    def created_by
      # updated user id
      AuditModule.get_current_user.uid
    end

    def self.get_invoice_list(arg_provider_id)
    	where("provider_id = ?",arg_provider_id)
    end

    # def self.get_invoice(arg_invoice_id)
    #   where("id = ?",arg_invoice_id)
    # end

    # def self.generate_invoice(arg_provider_id,arg_service_authorization_id)
    # 	msg = "SUCCESS"
    #   service_authorization_object = ServiceAuthorization.find(arg_service_authorization_id)
    # 	ready_to_be_invoiced_service_auth_collection =ServiceAuthorizationLineItem.get_ready_to_be_invoiced_line_items(arg_service_authorization_id)
    # 	total_invoice_amount = ServiceAuthorizationLineItem.get_amount_to_be_invoiced(arg_service_authorization_id)

    # 	#1. Populate provider_invoices - table
	   # 	provider_invoice_object = ProviderInvoice.new
	   # 	provider_invoice_object.provider_id = arg_provider_id
	   # 	provider_invoice_object.invoice_date = Time.now.to_date
	   # 	provider_invoice_object.invoice_amount = total_invoice_amount
    #   provider_invoice_object.invoice_status = 6182
    #   provider_invoice_object.service_authorization_id = service_authorization_object.id
	   # 	# provider_invoice_object.invoice_status = #pending
	   # 	if provider_invoice_object.save
    #     # 2. Update provider invoice ID to the submitted Line Items.
	   # 		ready_to_be_invoiced_service_auth_collection.each do |arg_invoice_line_item|
	   # 			arg_invoice_line_item.provider_invoice_id = provider_invoice_object.id
    #       arg_invoice_line_item.line_item_status = 6170 # Processed.
	   # 			if arg_invoice_line_item.save
	   # 				msg = "SUCCESS"
	   # 				# logger.debug("invoice_line_item_object - success - message = #{msg}")
	   # 			else
	   # 				provider_invoice_object.destroy
	   # 				msg = invoice_line_item_object.errors.full_messages.last
	   # 				# logger.debug("invoice_line_item_object - failed - message = #{msg}")
	   # 				break
	   # 			end
	   # 		end
	   # 	else
	   # 		msg = provider_invoice_object.errors.full_messages.last
	   # 		# logger.debug("provider_invoice_object - failed - message = #{msg}")
	   # 	end

	   # 	return msg
    # end

    def self.generate_invoice_for_selected_line_items(arg_provider_id,arg_service_authorization_line_items,arg_provider_submitted_invoice_number)

     # logger.debug("arg_service_authorization_line_items =  #{arg_service_authorization_line_items.inspect}")
      msg = "SUCCESS"
      # ready_to_be_invoiced_service_auth_collection =ServiceAuthorizationLineItem.get_ready_to_be_invoiced_line_items(arg_service_authorization_id)
      ready_to_be_invoiced_service_auth_collection =ServiceAuthorizationLineItem.find(arg_service_authorization_line_items)
       # logger.debug("ready_to_be_invoiced_service_auth_collection =  #{ready_to_be_invoiced_service_auth_collection.inspect}")
      total_invoice_amount = 0.00
      ready_to_be_invoiced_service_auth_collection.each do |arg_line_item_object|
        total_invoice_amount = total_invoice_amount + arg_line_item_object.actual_cost
      end

      service_authorization_line_item_object = ready_to_be_invoiced_service_auth_collection.first
      service_authorization_object = ServiceAuthorization.find(service_authorization_line_item_object.service_authorization_id)
      program_unit_object = ProgramUnit.find(service_authorization_object.program_unit_id)


      if service_authorization_line_item_object.provider_invoice_id.present?
         provider_invoice_object = ProviderInvoice.find(service_authorization_line_item_object.provider_invoice_id)
      else
         provider_invoice_object = ProviderInvoice.new
      end


      #1. Populate provider_invoices - table

      provider_invoice_object.provider_id = arg_provider_id
      provider_invoice_object.invoice_date = Time.now.to_date
      provider_invoice_object.invoice_amount = total_invoice_amount
      provider_invoice_object.invoice_status = 6369 # Generated
      provider_invoice_object.service_authorization_id = service_authorization_object.id
      # provider_invoice_object.payment_approver_id = nil
      provider_invoice_object.reason = nil
      if arg_provider_submitted_invoice_number.present?
        provider_invoice_object.provider_invoice = arg_provider_submitted_invoice_number
      end
      begin
        ActiveRecord::Base.transaction do
          # provider_invoice_object.invoice_status = #pending
          provider_invoice_object.save!
            # 2. Update provider invoice ID to the submitted Line Items.
            ready_to_be_invoiced_service_auth_collection.each do |arg_line_item|
              arg_line_item.provider_invoice_id = provider_invoice_object.id
              arg_line_item.provider_invoice = arg_provider_submitted_invoice_number
              arg_line_item.line_item_status = 6170 # Processed.
              arg_line_item.save!
            end

            #Threshold logic start
            amount_below_threshold = CostCenter.is_action_amount_below_threshold_amount(program_unit_object.service_program_id,
                                                                                        service_authorization_object.service_type,
                                                                                        total_invoice_amount)
            member_status = ProgramUnitMember.get_member_status(program_unit_object.id,service_authorization_object.client_id)
            #If amount is below threshold and member is active then follow normal reular procedure where supervisor approval is not needed
            if (amount_below_threshold && member_status == 4468)
                msg = ProviderInvoice.create_provider_payment_record(arg_provider_id,provider_invoice_object.id)
                if msg == "SUCCESS"
                  common_action_argument_object = CommonEventManagementArgumentsStruct.new
                  common_action_argument_object.provider_invoice_id = provider_invoice_object.id

                  event_to_action_mapping_object = EventToActionsMapping.find(311)
                  WorkTaskService.complete_work_task(common_action_argument_object,event_to_action_mapping_object)
                end
            else
              #Supervisor approval is needed is amount is above threshold OR if client is inactive
                #Above threshold requires supervisor approval , hence wrinting this record to supervisor approval queue
                # step1 : Populate common event management argument structure
                common_action_argument_object = CommonEventManagementArgumentsStruct.new
                common_action_argument_object.event_id = 618 # Request for Approval of Service Payment
                # Objects related to work task
                common_action_argument_object.provider_invoice_id = provider_invoice_object.id
                # Queue related arguments
                common_action_argument_object.queue_reference_type = 6383 #provider invoice
                common_action_argument_object.queue_reference_id = provider_invoice_object.id
                # step2: call common method to process event.
                msg = EventManagementService.process_event(common_action_argument_object)

                if msg == "SUCCESS"
                  lb_saved = provider_invoice_object.request
                  unless lb_saved
                    msg = provider_invoice_object.errors.full_messages.last
                  end
                end
            end
            #Threshold logic end
        end
        msg = "SUCCESS"
        rescue => err
          error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItem-Model","generate_invoice_for_selected_line_items Method",err,AuditModule.get_current_user.uid)
          msg = "Failed to create provider invoice - for more details refer to Error ID: #{error_object.id}"
      end
      return msg
    end



    def self.get_service_authorization_object_for_invoice(arg_invoice_id)
    	 step1 = ServiceAuthorizationLineItem.joins("INNER JOIN provider_invoices
                                                          ON service_authorization_line_items.provider_invoice_id = provider_invoices.id
                                                          INNER JOIN service_authorizations
														                              ON service_authorization_line_items.service_authorization_id = service_authorizations.id
                                                          "
                                                          )
      step2 = step1.where("service_authorization_line_items.provider_invoice_id = ?",arg_invoice_id)
      step3 = step2.select("service_authorizations.id as service_authorization_id")
      step4 = step3.order("service_authorization_id DESC")
      result_collection = step4
      result_object = result_collection.first
      srvc_auth_object_for_invoice = ServiceAuthorization.find(result_object.service_authorization_id)
      return srvc_auth_object_for_invoice

    end

    def self.update_new_status(arg_invoice_id, arg_invoice_status)
      update(arg_invoice_id, invoice_status: arg_invoice_status)
    end



    def self.get_client_for_provider_invoice(arg_invoice_id)
      step1 = ServiceAuthorization.joins("INNER JOIN provider_invoices ON
                                          provider_invoices.service_authorization_id = service_authorizations.id ")
      step2 = step1.where("provider_invoices.id = ?",arg_invoice_id)
      step3 = step2.select("distinct service_authorizations.id,service_authorizations.client_id")
      client_object = step3.first
      client_id = client_object.client_id
      return client_id

    end



     def self.create_provider_payment_record(arg_provider_id,arg_invoice_id)
        lb_save = false
        # provider_invoice_object = ProviderInvoice.where("id = ?",arg_invoice_id).first
        provider_invoice_object = ProviderInvoice.find(arg_invoice_id)
        provider_invoice_object.invoice_status = 6170 # processed
        provider_invoice_object.reason = nil
        l_client_id = ProviderInvoice.get_client_for_provider_invoice(arg_invoice_id)
        l_program_unit_id = ProviderInvoice.get_program_unit_id_for_provider_invoice(arg_invoice_id)
        program_unit_payment_collection = PaymentLineItem.get_payment_record_for_provider_invoice(arg_invoice_id)
        if program_unit_payment_collection.present?
            # Update
            # what is the payment status
            payment_line_item_object = program_unit_payment_collection.first
            # only generated status record can be modified.
            # If status is sent to AASIS/EBT vendor or paid - there is no need to do anything.
            if payment_line_item_object.payment_status == 6191
                lb_save = true
            end
        else
          # Insert
          payment_line_item_object = PaymentLineItem.new
          lb_save = true
        end

        if lb_save == true
            payment_line_item_object.line_item_type = 6178 # Supportive Services
            payment_line_item_object.payment_type = 5760 # Regular
            payment_line_item_object.client_id = l_client_id
            payment_line_item_object.beneficiary = 6173 # provider
            payment_line_item_object.reference_id = arg_provider_id
            payment_line_item_object.payment_amount = provider_invoice_object.invoice_amount
            payment_line_item_object.payment_date = provider_invoice_object.invoice_date
            payment_line_item_object.payment_status = 6191 # Generated.
            payment_line_item_object.determination_id = provider_invoice_object.id
            payment_line_item_object.status = 6201 #Authorized.
            payment_line_item_object.program_unit_id = l_program_unit_id

             begin
                ActiveRecord::Base.transaction do
                  payment_line_item_object.save!
                  provider_invoice_object.save!
                end
                msg = "SUCCESS"
            rescue => err
                 msg = err.message
            end
        else
           msg = "NOTHING_TO_PROCESS"
        end

        return msg
    end




    # def self.generate_invoice_for_non_transport_service(arg_provider_id,arg_service_authorization_line_item_id)
    #  # logger.debug("arg_service_authorization_line_items =  #{arg_service_authorization_line_items.inspect}")
    #   msg = "SUCCESS"
    #   # ready_to_be_invoiced_service_auth_collection =ServiceAuthorizationLineItem.get_ready_to_be_invoiced_line_items(arg_service_authorization_id)
    #   ready_to_be_invoiced_service_line_item =ServiceAuthorizationLineItem.find(arg_service_authorization_line_item_id)
    #   service_authorization_object = ServiceAuthorization.find(ready_to_be_invoiced_service_line_item.service_authorization_id)
    #   #1. Populate provider_invoices - table
    #   provider_invoice_object = ProviderInvoice.new
    #   provider_invoice_object.provider_id = arg_provider_id
    #   provider_invoice_object.invoice_date = Time.now.to_date
    #   provider_invoice_object.invoice_amount = ready_to_be_invoiced_service_line_item.actual_cost
    #   provider_invoice_object.invoice_status = 6182
    #   provider_invoice_object.service_authorization_id = service_authorization_object.id
    #   # provider_invoice_object.invoice_status = #pending
    #   if provider_invoice_object.save
    #     # 2. Update provider invoice ID to the submitted Line Items.

    #       ready_to_be_invoiced_service_line_item.provider_invoice_id = provider_invoice_object.id
    #       ready_to_be_invoiced_service_line_item.line_item_status = 6170 # Processed.
    #       if ready_to_be_invoiced_service_line_item.save
    #         msg = "SUCCESS"
    #         # logger.debug("invoice_line_item_object - success - message = #{msg}")
    #       else
    #         provider_invoice_object.destroy
    #         msg = invoice_line_item_object.errors.full_messages.last
    #         # logger.debug("invoice_line_item_object - failed - message = #{msg}")
    #       end
    #   else
    #     msg = provider_invoice_object.errors.full_messages.last
    #     # logger.debug("provider_invoice_object - failed - message = #{msg}")
    #   end

    #   return msg
    # end


    def self.get_program_unit_id_for_provider_invoice(arg_invoice_id)
        step1 = ServiceAuthorization.joins(" INNER JOIN provider_invoices ON
                                              provider_invoices.service_authorization_id = service_authorizations.id
                                           ")
      step2 = step1.where("provider_invoices.id = ?",arg_invoice_id)
      step3 = step2.select("distinct service_authorizations.id,service_authorizations.program_unit_id")
      program_unit_object = step3.first
      program_unit_id = program_unit_object.program_unit_id
      return program_unit_id

    end


    # def self.get_submitted_invoice_list()
    #   where("invoice_status = 6182")
    # end



end