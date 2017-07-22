class ProviderInvoicesController <  AttopAncestorController

	def provider_invoice_index
		if session[:PROVIDER_ID].present?
			@provider = Provider.find(session[:PROVIDER_ID].to_i)
			@provider_invoices = ProviderInvoice.get_invoice_list(@provider).order("id DESC")
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderInvoicesController","provider_invoice_index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Provider"
		redirect_to_back
	end

	def provider_invoice_show
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_invoice = ProviderInvoice.find(params[:provider_invoice_id].to_i)
		if (@provider_invoice.invoice_status == 6183 || @provider_invoice.invoice_status == 6184)
			# 6184;"Reimbursed"
			# 6183;"Authorized"
			@can_edit = false
		else
			@can_edit = true
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderInvoicesController","provider_invoice_show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Warrant Number"
		redirect_to_back
	end

	def provider_invoice_edit
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_invoice = ProviderInvoice.find(params[:provider_invoice_id].to_i)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderInvoicesController","provider_invoice_edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Warrant Number"
		redirect_to_back
	end

	def provider_invoice_update
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_invoice = ProviderInvoice.find(params[:provider_invoice_id].to_i)
		l_params = invoice_params
		if l_params[:invoice_notes].present?
			@provider_invoice.invoice_notes = l_params[:invoice_notes]
			if @provider_invoice.save
				redirect_to provider_invoice_show_path(@provider_invoice.id)
			else
				render :provider_invoice_edit
			end
		else
			@provider_invoice.invoice_notes = nil
			if @provider_invoice.save
				redirect_to provider_invoice_show_path(@provider_invoice.id)
			else
				render :provider_invoice_edit
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderInvoicesController","provider_invoice_update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error Occured when updating Warrant notes"
		redirect_to_back
	end

	# def provider_invoice_request_for_approval
	# 	# Kiran 07/22/2015
	# 	# This action is called by Submit Payments.
	# 	lb_saved = true
	# 	ls_msg = ""
	# 	@provider = Provider.find(session[:PROVIDER_ID].to_i)
	# 	@provider_invoice = ProviderInvoice.find(params[:provider_invoice_id].to_i)
	# 	# step1 : Populate common event management argument structure
 #  		common_action_argument_object = CommonEventManagementArgumentsStruct.new
	#         common_action_argument_object.event_id = 745 # "Request for Approval of Provider Invoice"
	#         common_action_argument_object.provider_invoice_id = @provider_invoice.id
	#         common_action_argument_object.client_id = ProviderInvoice.get_client_for_provider_invoice(@provider_invoice.id)
	#         common_action_argument_object.service_authorization_line_item_id = ServiceAuthorizationLineItem.get_line_item_id(@provider_invoice.id)
	#         common_action_argument_object.provider_id = @provider.id
	# 	begin
 #      		ActiveRecord::Base.transaction do
	# 	  		# step2: call common method to process event.
	# 	        ls_msg = EventManagementService.process_event(common_action_argument_object)
	# 	        if ls_msg == "SUCCESS"
	# 	        	lb_saved = @provider_invoice.request
	# 				unless lb_saved
	# 					ls_msg = @provider_invoice.errors.full_messages.last
	# 				end
	# 			else
	# 				lb_saved = false
	# 			end

	# 	  	end
	# 	  	rescue => err
	# 	  		error_object = CommonUtil.write_to_attop_error_log_table("ProviderInvoicesController","provider_invoice_request_for_approval",err,AuditModule.get_current_user.uid)
	# 	  		lb_saved = false
	# 	  		ls_msg = "Request to approve Provider Invoice failed - for more details refer to Error ID: #{error_object.id}"
 #        end
 #        if lb_saved == true
	#   		flash[:notice] = "Provider Invoice is rejected"
	# 	else
	# 		flash[:alert] =  ls_msg
	#   	end
	#   	redirect_to provider_invoice_line_items_index_path(@provider_invoice.id)
	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("ProviderInvoicesController","provider_invoice_request_for_approval",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Error occured when requesting Provider Invoice for approval"
	# 	redirect_to_back
	# end

	def provider_invoice_authorize
		# fail
		lb_saved = true
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_invoice = ProviderInvoice.find(params[:provider_invoice_id].to_i)
		# step1 : Populate common event management argument structure
  		common_action_argument_object = CommonEventManagementArgumentsStruct.new
        common_action_argument_object.event_id = 692 # "Request to Approve Provider Invoice is Approved"
        common_action_argument_object.provider_invoice_id = @provider_invoice.id
        common_action_argument_object.client_id = ProviderInvoice.get_client_for_provider_invoice(@provider_invoice.id)
        common_action_argument_object.provider_id = @provider.id

        #Queue related arguments have to be passed
        common_action_argument_object.queue_reference_type = 6383 #provider invoice
        common_action_argument_object.queue_reference_id = @provider_invoice.id

		begin
      		ActiveRecord::Base.transaction do
      			ls_msg = ProviderInvoice.create_provider_payment_record(@provider.id,@provider_invoice.id)
      			if ls_msg == "SUCCESS"
      				# step2: call common method to process event.
			        ls_msg = EventManagementService.process_event(common_action_argument_object)
			        if ls_msg == "SUCCESS"
						lb_saved = @provider_invoice.approve
						unless lb_saved
							ls_msg = @provider_invoice.errors.full_messages.last
						end
					else
						ls_msg = ls_msg
						lb_saved = false
					end
      			else
  					lb_saved = false
      			end
		  	end
		  	rescue => err
		  		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","provider_invoice_authorize",err,AuditModule.get_current_user.uid)
		  		lb_saved = false
		  		ls_msg = "Failed to Approve Payment- for more details refer to Error ID: #{error_object.id}"
        end
		if lb_saved == true
	  		flash[:notice] = "Provider invoice approved"
		else
			flash[:alert] =  ls_msg
	  	end
		redirect_to provider_invoice_line_items_index_path(@provider_invoice.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderInvoicesController","provider_invoice_authorize",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error Occured When Authorizing Warrant Number"
		redirect_to_back
	end

	def edit_provider_invoice_reject
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_invoice = ProviderInvoice.find(params[:provider_invoice_id].to_i)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderInvoicesController","edit_provider_invoice_reject",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Provider Invoice"
		redirect_to provider_invoice_line_items_index_path(params[:provider_invoice_id].to_i)
	end

	def update_provider_invoice_reject
		lb_saved = true
		ls_msg = nil
		l_params = rejection_params
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_invoice = ProviderInvoice.find(params[:provider_invoice_id].to_i)
		if l_params[:reason].present?
			@provider_invoice.reason = l_params[:reason]
        	@provider_invoice.invoice_status = 6369
        	@provider_invoice.save
        	# step1 : Populate common event management argument structure
	  		common_action_argument_object = CommonEventManagementArgumentsStruct.new
	        common_action_argument_object.event_id = 549 # "Request to Approve Provider Invoice is Rejected"
	        common_action_argument_object.provider_invoice_id = @provider_invoice.id
	        common_action_argument_object.client_id = ProviderInvoice.get_client_for_provider_invoice(@provider_invoice.id)
	        # common_action_argument_object.program_unit_id = @provider_service_authorization.program_unit_id
	        common_action_argument_object.provider_id = @provider.id
	        #queue related arguments
	        common_action_argument_object.queue_reference_type = 6383 #provider invoice
            common_action_argument_object.queue_reference_id = @provider_invoice.id


			begin
	      		ActiveRecord::Base.transaction do
	      			#service authorization line item status is changed
	      			service_authorization_line_item_collection = ServiceAuthorizationLineItem.where("provider_invoice_id = ?", @provider_invoice.id)
		            service_authorization_line_item_collection.each do |line_item|
		            	line_item.line_item_status = 6168 #status is changed back to Reported
		            	line_item.save!
		            end

	            	# step2: call common method to process event.
			        ls_msg = EventManagementService.process_event(common_action_argument_object)
			        # lb_saved = (ls_return == "SUCCESS") ? true : false
			        if ls_msg == "SUCCESS"
						lb_saved = @provider_invoice.reject
						unless lb_saved
							ls_msg = @provider_invoice.errors.full_messages.last
							lb_saved = false
						end
					end
			  	end
			  	rescue => err
			  		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","update_service_payment_reject",err,current_user.uid)
			  		lb_saved = false
			  		ls_msg = "Failed to reject Provider Invoice - for more details refer to Error ID: #{error_object.id}"
	        end
			if lb_saved == true
		  		flash[:notice] = "Provider invoice is rejected"
			else
				flash[:alert] =  ls_msg
		  	end
		  	redirect_to provider_invoice_line_items_index_path(@provider_invoice.id)
		else
			@provider_invoice.errors[:reason] = "is required"
			render :edit_provider_invoice_reject
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderInvoicesController","update_provider_invoice_reject",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while rejecting Provider Invoice"
		redirect_to provider_invoice_line_items_index_path(params[:provider_invoice_id].to_i)
	end

	def provider_invoice_line_items_index
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_invoice = ProviderInvoice.find(params[:provider_invoice_id].to_i)
		@provider_invoice_line_items = ServiceAuthorizationLineItem.get_provider_invoice_line_items(@provider_invoice.id)
		@service_authorization_object = ProviderInvoice.get_service_authorization_object_for_invoice(@provider_invoice.id)
		if (@provider_invoice.invoice_status == 6183 || @provider_invoice.invoice_status == 6184)
			# 6184;"Reimbursed"
			# 6183;"Authorized"
			@can_edit = false
		else
			@can_edit = true
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderInvoicesController","provider_invoice_line_items_index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Warrant Number"
		redirect_to_back
  end

	def provider_invoice_line_item_show
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_invoice = ProviderInvoice.find(params[:provider_invoice_id].to_i)
		@service_authorization_line_item = ServiceAuthorizationLineItem.find(params[:invoice_line_item_id])
		# @provider_service_authorization = ServiceAuthorization.find(@service_authorization_line_item.service_authorization_id)
		@service_authorization_object = ProviderInvoice.get_service_authorization_object_for_invoice(@provider_invoice.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderInvoicesController","provider_invoice_line_item_show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Warrant Line Item"
		redirect_to_back
	end


	# def finance_pending_payments_to_be_released
	# 	@submitted_payments = ProviderInvoice.get_submitted_invoice_list()
	# end

	# def select_pending_payment_for_authorization
	# 	li_warrant_id = params[:warrant_id]
	# 	provider_invoice_object = ProviderInvoice.find(li_warrant_id)
	# 	session[:PROVIDER_ID] = provider_invoice_object.provider_id
	# 	redirect_to provider_invoice_line_items_index_path(li_warrant_id)
	# end

private

	def invoice_params
		params.require(:provider_invoice).permit(:invoice_notes)
  	end

  	def rejection_params
 		params.require(:provider_invoice).permit(:reason)
 	end


end
