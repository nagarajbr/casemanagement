class ServiceAuthorizationLineItemsController < AttopAncestorController
# Author : Manojkumar Patil
# Date : 12/15/2014
	#1
	def provider_service_authorizations_index
		# List of service authorizations for given provider
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_service_authorizations = ServiceAuthorization.get_service_authorizations_for_provider(@provider.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","provider_service_authorizations_index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid provider."
		redirect_to_back
	end
	#2
	def service_authorization_line_items_index
		@service_name = "Transport"
		# List of service authorization line items for given service authorization ID.
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_service_authorization = ServiceAuthorization.find(params[:service_authorization_id].to_i)
		@service_authorization_line_items = @provider_service_authorization.service_authorization_line_items.order("id ASC")
		@generated_line_items_found = ServiceAuthorizationLineItem.any_generated_line_items_found(@provider_service_authorization)
		@submitted_line_items_found = ServiceAuthorizationLineItem.any_submitted_line_items_found(@provider_service_authorization)
		@processed_line_items_found = ServiceAuthorizationLineItem.any_processed_line_items_found(@provider_service_authorization)
		@rejected_line_items_found = ServiceAuthorizationLineItem.any_rejected_line_items_found(@provider_service_authorization)
		if @provider_service_authorization.service_type != 6215
			@service_name = "Non Transport"
			@show_new_button = ServiceAuthorizationLineItem.can_create_non_transportation_payment_line_item?(@provider_service_authorization.id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","service_authorization_line_items_index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid service plan."
		redirect_to_back
	end
	#3
	def non_transport_service_payment_record_new
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_service_authorization = ServiceAuthorization.find(params[:service_authorization_id])
		@service_authorization_line_item = ServiceAuthorizationLineItem.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","service_authorization_line_item_update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when creating service authorization line item."
		redirect_to_back
	end
	#4
	def non_transport_service_payment_record_create
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_service_authorization = ServiceAuthorization.find(params[:service_authorization_id])
		l_params = non_ts_line_item_params
		@service_authorization_line_item = ServiceAuthorizationLineItem.new(l_params)
		@service_authorization_line_item.non_ts_service = "Y"
		@service_authorization_line_item.service_authorization_id = params[:service_authorization_id]
		@service_authorization_line_item.line_item_status = 6369 # Generated
		if @service_authorization_line_item.save
			flash[:notice] = "Payment record created successfully."
			redirect_to service_authorization_line_items_index_path(@provider_service_authorization.id)
		else
			render :non_transport_service_payment_record_new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","non_transport_service_payment_record_create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when saving service authorization line item."
		redirect_to_back
	end
	#5
	def service_authorization_line_item_show
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_service_authorization = ServiceAuthorization.find(params[:service_authorization_id])
		@service_authorization_line_item = ServiceAuthorizationLineItem.find(params[:service_authorization_line_item_id])
		program_unit_object = ProgramUnit.find(@provider_service_authorization.program_unit_id)
		# Rule: Service Line Items with status :
		# 6369 - Generated
		# 6168 - Reported
		# 6169 - Submitted
		# can be edited.
		@can_edit = "Y"
		if @service_authorization_line_item.provider_invoice_id.present?
			provider_invoice_object = ProviderInvoice.find(@service_authorization_line_item.provider_invoice_id)
			payment_line_item_object = PaymentLineItem.where("determination_id = ?",provider_invoice_object.id).first
			threshold_amount = CostCenter.provider_payments_threshold_amount(program_unit_object.service_program_id,@provider_service_authorization.service_type)
			@can_edit = "N"
			if provider_invoice_object.invoice_amount.to_f <= threshold_amount.to_f
				if payment_line_item_object.present? && payment_line_item_object.payment_status == 6191
					@can_edit = "Y"
				end
			end
			if provider_invoice_object.invoice_amount.to_f > threshold_amount.to_f
				if payment_line_item_object.blank? || payment_line_item_object.payment_status == 6191
					@can_edit = "Y"
				end
				if payment_line_item_object.present? && payment_line_item_object.payment_amount.to_f > threshold_amount.to_f && payment_line_item_object.payment_status == 6191
					@can_edit = "N"
				end
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","service_authorization_line_item_show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid service plan line item."
		redirect_to_back
	end
	#6
	def transport_service_authorization_line_item_edit
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_service_authorization = ServiceAuthorization.find(params[:service_authorization_id])
		@service_authorization_line_item = ServiceAuthorizationLineItem.find(params[:service_authorization_line_item_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","transport_service_authorization_line_edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit invalid service plan line item."
		redirect_to_back

	end
	#7
	def transport_service_authorization_line_item_update
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_service_authorization = ServiceAuthorization.find(params[:service_authorization_id])
		@service_authorization_line_item = ServiceAuthorizationLineItem.find(params[:service_authorization_line_item_id])
		program_unit_object = ProgramUnit.find(@provider_service_authorization.program_unit_id)
		l_params = line_item_params
		l_start_time = l_params["service_begin_time(5i)"]
		@service_authorization_line_item.service_begin_time =  l_start_time
		if l_params["service_end_time(5i)"].present?
			l_end_time = l_params["service_end_time(5i)"]
			@service_authorization_line_item.service_end_time = l_end_time
		end
		if l_params[:actual_quantity].present?
			@service_authorization_line_item.actual_quantity = l_params[:actual_quantity].to_f
		end
		@service_authorization_line_item.provider_invoice = l_params[:provider_invoice] #if l_params[:provider_invoice].present?
		@service_authorization_line_item.override_reason = l_params[:override_reason] # if l_params[:override_reason].present?
		@service_authorization_line_item.notes = l_params[:notes] if l_params[:notes].present?

		if params[:save].present?
			lb_can_proceed = true
			if session["CALCULATED_ACTUAL_COST"].present?
				@service_authorization_line_item.actual_cost = session["CALCULATED_ACTUAL_COST"].to_f
				session["CALCULATED_ACTUAL_COST"] = nil
			end

			# Rule : if actual cost is different from estimated cost - over ride reason is mandatory.
			if (@service_authorization_line_item.actual_cost != @service_authorization_line_item.estimated_cost ) && l_params[:override_reason].blank?
				@service_authorization_line_item.errors.add(:override_reason, "is required since actual cost is different from estimated cost.")
				lb_can_proceed = false
			end
			# Rule : if actual distance is different from estimated distance then actual cost also should be different from estimated cost


			if @service_authorization_line_item.actual_quantity_changed? #&& session["CALCULATED_ACTUAL_COST"].blank?
				if @service_authorization_line_item.actual_cost_changed?
		        else
		          @service_authorization_line_item.errors.add(:actual_cost, "should be recalculated when actual distance is changed.")
		            lb_can_proceed = false
		        end
			end

			# all validations passed so proceed to save
			if lb_can_proceed == true
				if  @service_authorization_line_item.save
					if @service_authorization_line_item.provider_invoice_id.present?
						@provider_invoice_object = ProviderInvoice.find(@service_authorization_line_item.provider_invoice_id)
						service_authorization_line_items_collection = ServiceAuthorizationLineItem.where("provider_invoice_id = ?",@provider_invoice_object.id)
						total_amount = 0.00
						service_authorization_line_items_collection.each do |each_line_item|
							total_amount = total_amount + each_line_item.actual_cost
						end
						threshold_amount = CostCenter.provider_payments_threshold_amount(program_unit_object.service_program_id,@provider_service_authorization.service_type)
						if total_amount.to_f <= threshold_amount.to_f
							payment_queue_object = WorkQueue.where("state = 6654 and reference_type = 6383 and reference_id = ? ",@service_authorization_line_item.provider_invoice_id).first
							work_task_object = WorkTask.where("task_category = 6352 and
															task_type = 6469 and
															client_id = ? and
															beneficiary_type = 6383 and
															reference_id = ? and
															complete_date is null and
															status = 6339",@provider_service_authorization.client_id,@service_authorization_line_item.provider_invoice_id).first #task_category(provider = 6352 ), task_type(request for approval = 6469), clientid,beneficiary_type(provider invoice = 6383),reference id (provider invoice id), complete date nil, status(incomplete = 6339)
							if work_task_object.present?
								work_task_object.complete_date = Date.today
								work_task_object.status = 6341
							end

							@provider_invoice_object.invoice_amount = total_amount
							@provider_invoice_object.payment_approver_id = nil

							lb_save = false
							program_unit_payment_collection = PaymentLineItem.get_payment_record_for_provider_invoice(@provider_invoice_object.id)
							if program_unit_payment_collection.present?
					            payment_line_item_object = program_unit_payment_collection.first
					            if payment_line_item_object.payment_status == 6191
					                lb_save = true
					            end
					        else
					        	payment_line_item_object = PaymentLineItem.new
					          	lb_save = true
					        end
					        if lb_save == true
					            payment_line_item_object.line_item_type = 6178 # Supportive Services
					            payment_line_item_object.payment_type = 5760 # Regular
					            payment_line_item_object.client_id = @provider_service_authorization.client_id
					            payment_line_item_object.beneficiary = 6173 # provider
					            payment_line_item_object.reference_id = @provider.id
					            payment_line_item_object.payment_amount = total_amount
					            payment_line_item_object.payment_date = @provider_invoice_object.invoice_date
					            payment_line_item_object.payment_status = 6191 # Generated.
					            payment_line_item_object.determination_id = @provider_invoice_object.id
					            payment_line_item_object.status = 6201 #Authorized.
					            payment_line_item_object.program_unit_id = @provider_service_authorization.program_unit_id
					             begin
					                ActiveRecord::Base.transaction do
					                	if payment_queue_object.present?
											payment_queue_object.destroy!
										end
					                	work_task_object.save! if work_task_object.present?
					                	payment_line_item_object.save!
					                  	@provider_invoice_object.save!
					                end
					                msg = "SUCCESS"
					            rescue => err
					                 msg = err.message
					            end
					        else
					           msg = "NOTHING_TO_PROCESS"
					        end

						end

						if total_amount.to_f > threshold_amount.to_f
							program_unit_payment_collection = PaymentLineItem.get_payment_record_for_provider_invoice(@provider_invoice_object.id)
							program_unit_payment_object = program_unit_payment_collection.first
							begin
					            ActiveRecord::Base.transaction do
					            		program_unit_payment_object.destroy! if program_unit_payment_object.present?

					            		@provider_invoice_object = ProviderInvoice.find(@service_authorization_line_item.provider_invoice_id)
					            		@provider_invoice_object.invoice_amount = total_amount
					            		@provider_invoice_object.invoice_status = 6369
					            		@provider_invoice_object.save!

					            		common_action_argument_object = CommonEventManagementArgumentsStruct.new
						                common_action_argument_object.event_id = 618 # Request for Approval of Service Payment
						                # Objects related to work task
						                common_action_argument_object.provider_invoice_id = @provider_invoice_object.id
						                # Queue related arguments
						                common_action_argument_object.queue_reference_type = 6383 #provider invoice
						                common_action_argument_object.queue_reference_id = @provider_invoice_object.id
						                # step2: call common method to process event.
						                msg = EventManagementService.process_event(common_action_argument_object)
					            end
					            rescue => err
					            msg = err.message
					        end

						end
					end
					redirect_to service_authorization_line_item_show_path(@provider_service_authorization.id,@service_authorization_line_item.id)
				else
					render :transport_service_authorization_line_item_edit
				end
			else
				render :transport_service_authorization_line_item_edit
			end

		end # end of params[:save].present?

		if params[:recalculate_cost].present?
			if @service_authorization_line_item.valid?
				# calculate cost and set it in actual cost
				# calculate_trip_cost(arg_service_date,arg_miles,arg_service_time)
				li_miles = l_params[:actual_quantity].to_f
				ld_actual_cost = ServiceAuthorization.calculate_trip_cost(@service_authorization_line_item.service_date,li_miles,@service_authorization_line_item.service_begin_time)
				ld_actual_cost = ld_actual_cost.round(2)
				@service_authorization_line_item.actual_cost =ld_actual_cost
				session["CALCULATED_ACTUAL_COST"] = @service_authorization_line_item.actual_cost
				render :transport_service_authorization_line_item_edit

			else
				render :transport_service_authorization_line_item_edit
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","transport_service_authorization_line_item_update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when updating service plan line item."
		redirect_to_back
	end
	#8
	def non_transport_service_authorization_line_item_edit
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_service_authorization = ServiceAuthorization.find(params[:service_authorization_id])
		@service_authorization_line_item = ServiceAuthorizationLineItem.find(params[:service_authorization_line_item_id])
  	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","non_transport_service_authorization_line_item_edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when editing service authorization line item."
		redirect_to_back
	end
	#9
	def non_transport_service_service_authorization_line_item_update
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_service_authorization = ServiceAuthorization.find(params[:service_authorization_id])
		@service_authorization_line_item = ServiceAuthorizationLineItem.find(params[:service_authorization_line_item_id])
		l_params = non_ts_line_item_params
		@service_authorization_line_item.non_ts_service = "Y"
		@service_authorization_line_item.service_date= l_params[:service_date]
		# @service_authorization_line_item.actual_cost = l_params[:actual_cost]
		@service_authorization_line_item.actual_quantity = l_params[:actual_quantity]
		# @service_authorization_line_item.provider_invoice = l_params[:provider_invoice]
		@service_authorization_line_item.notes = l_params[:notes]
		program_unit_object = ProgramUnit.find(@provider_service_authorization.program_unit_id)
		threshold_amount = CostCenter.provider_payments_threshold_amount(program_unit_object.service_program_id,@provider_service_authorization.service_type)
		if ((l_params[:actual_cost].to_f <= threshold_amount.to_f)) #(@service_authorization_line_item.actual_cost.to_f > threshold_amount.to_f) &&
			@service_authorization_line_item.actual_cost = l_params[:actual_cost]
			# @service_authorization_line_item.save
			# fail
			payment_queue_object = WorkQueue.where("state = 6654 and reference_type = 6383 and reference_id = ? ",@service_authorization_line_item.provider_invoice_id).first #state(queue_type = 6654) #referenec_type(provider invoice = 6383) reference_id = provider_invoice_id
			# if payment_queue_object.present?
			# 	payment_queue_object.destroy
			# end

			work_task_object = WorkTask.where("task_category = 6352 and
											task_type = 6469 and
											client_id = ? and
											beneficiary_type = 6383 and
											reference_id = ? and
											complete_date is null and
											status = 6339",@provider_service_authorization.client_id,@service_authorization_line_item.provider_invoice_id).first #task_category(provider = 6352 ), task_type(request for approval = 6469), clientid,beneficiary_type(provider invoice = 6383),reference id (provider invoice id), complete date nil, status(incomplete = 6339)
			if work_task_object.present?
				# fail
				work_task_object.complete_date = Date.today
				work_task_object.status = 6341
				# work_task_object.save
			end
			# fail
			if @service_authorization_line_item.provider_invoice_id.present?
				provider_invoice_object = ProviderInvoice.find(@service_authorization_line_item.provider_invoice_id)
				provider_invoice_object.invoice_amount = l_params[:actual_cost]
				provider_invoice_object.payment_approver_id = nil

				lb_save = false
				program_unit_payment_collection = PaymentLineItem.get_payment_record_for_provider_invoice(provider_invoice_object.id)
		        if program_unit_payment_collection.present?
		        	# fail
		            # Update
		            # what is the payment status
		            payment_line_item_object = program_unit_payment_collection.first
		            # only generated status record can be modified.
		            # If status is sent to AASIS/EBT vendor or paid - there is no need to do anything.
		            if payment_line_item_object.payment_status == 6191
		                lb_save = true
		            end
		        else
		        	# fail
		          # Insert
		          payment_line_item_object = PaymentLineItem.new
		          lb_save = true
		        end

		        if lb_save == true
		            payment_line_item_object.line_item_type = 6178 # Supportive Services
		            payment_line_item_object.payment_type = 5760 # Regular
		            payment_line_item_object.client_id = @provider_service_authorization.client_id
		            payment_line_item_object.beneficiary = 6173 # provider
		            payment_line_item_object.reference_id = @provider.id
		            payment_line_item_object.payment_amount = l_params[:actual_cost]
		            payment_line_item_object.payment_date = provider_invoice_object.invoice_date
		            payment_line_item_object.payment_status = 6191 # Generated.
		            payment_line_item_object.determination_id = provider_invoice_object.id
		            payment_line_item_object.status = 6201 #Authorized.
		            payment_line_item_object.program_unit_id = @provider_service_authorization.program_unit_id
		            # fail
		             begin
		                ActiveRecord::Base.transaction do
		                	if payment_queue_object.present?
								payment_queue_object.destroy!
							end
		                	work_task_object.save! if work_task_object.present?
		                	@service_authorization_line_item.save!
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
		    else
		    	@service_authorization_line_item.save!
			end

	        redirect_to service_authorization_line_item_show_path(@provider_service_authorization.id,@service_authorization_line_item.id)
		else
			@service_authorization_line_item.actual_cost = l_params[:actual_cost]
			provider_invoice_object = ProviderInvoice.find(@service_authorization_line_item.provider_invoice_id)
			program_unit_payment_collection = PaymentLineItem.get_payment_record_for_provider_invoice(provider_invoice_object.id)
			program_unit_payment_object = program_unit_payment_collection.first
			begin
	            ActiveRecord::Base.transaction do
	            	@service_authorization_line_item.save!

	            	program_unit_payment_object.destroy! if program_unit_payment_object.present?

	            	provider_invoice_object.invoice_amount = l_params[:actual_cost]
            		provider_invoice_object.invoice_status = 6369
            		provider_invoice_object.save!

            		common_action_argument_object = CommonEventManagementArgumentsStruct.new
	                common_action_argument_object.event_id = 618 # Request for Approval of Service Payment
	                # Objects related to work task
	                common_action_argument_object.provider_invoice_id = provider_invoice_object.id
	                # Queue related arguments
	                common_action_argument_object.queue_reference_type = 6383 #provider invoice
	                common_action_argument_object.queue_reference_id = provider_invoice_object.id
	                # step2: call common method to process event.
	                msg = EventManagementService.process_event(common_action_argument_object)
	                redirect_to service_authorization_line_item_show_path(@provider_service_authorization.id,@service_authorization_line_item.id)
	            end
	        	rescue => err
	            msg = err.message
	        end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","non_transport_service_service_authorization_line_item_update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when updating service authorization line item."
		redirect_to_back
	end
	#10
	def service_payment_request_for_approval
		# Submit payments button will call this action
		# Kiran 07/22/2015
		# This action is called by Submit Payments.
		ls_message = nil
		ls_msg = nil
		lb_saved = true
		@provider = Provider.find(session[:PROVIDER_ID].to_i)
		@provider_service_authorization = ServiceAuthorization.find(params[:service_authorization_id])
		@program_unit = ProgramUnit.find(@provider_service_authorization.program_unit_id)
		if params[:lineitem_ids].present?
		# fail
        	@service_authorization_line_items = ServiceAuthorizationLineItem.find(params[:lineitem_ids])
            begin
          		ActiveRecord::Base.transaction do
          		@service_authorization_line_items.each do |line_item|
          			if params[:provider_invoice_number].present?
				  		line_item.provider_invoice = params[:provider_invoice_number]
				  		line_item.save!
				  	end
				end # end of @service_authorization_line_items.each

        			lb_provider_invoice_found = false
					@submitted_provider_invoice = ""
					ls_error_message = ""
		# Rule 1: if provider invoice data is entered, then provider invoice should have same provider invoice number for all selected lime items.
		# step 1: get what is the provider invoice number to be compared with
					params[:lineitem_ids].each do |each_line_item_id|
						service_authorization_line_item_object = ServiceAuthorizationLineItem.find(each_line_item_id)
						Rails.logger.debug("service_authorization_line_item_object = #{service_authorization_line_item_object.inspect}")
						if 	service_authorization_line_item_object.provider_invoice.present?
							@submitted_provider_invoice = service_authorization_line_item_object.provider_invoice
							lb_provider_invoice_found = true
							break
						end
					end

					lb_proceed = true
					if lb_provider_invoice_found == true
						# Rule - each selected line item should have same provider invoice number.
						# our warrant number total = amount on provider submitted invoice
						# that way AASIS - can print -our warrnt number & provider submitted invoice on the check.
						params[:lineitem_ids].each do |each_line_item_id|
							service_authorization_line_item_object = ServiceAuthorizationLineItem.find(each_line_item_id)
							if service_authorization_line_item_object.provider_invoice.present?
								if service_authorization_line_item_object.provider_invoice != @submitted_provider_invoice
									ls_error_message = "All service line items should have same provider submitted invoice number."
									lb_proceed = false
									break
								end
							else
								ls_error_message = "One of the service line items does not have provider submitted invoice number, all service line items should have same provider submitted invoice number."
								lb_proceed = false
								break
							end
						end
					end

					if lb_proceed == true
						ls_message = ProviderInvoice.generate_invoice_for_selected_line_items(@provider.id,params[:lineitem_ids],@submitted_provider_invoice)
						if ls_message == "SUCCESS"
							flash[:notice] =  "Selected service payment line items are approved and invoice generated successfully."
						else
							flash[:alert] = ls_message
						end
					else
						flash[:alert] = ls_error_message
					end



			  	end
			  	rescue => err
			  		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","service_payment_request_for_approval",err,AuditModule.get_current_user.uid)
			  		lb_saved = false
			  		ls_msg = "Request to approve transportation payment failed - for more details refer to error ID: #{error_object.id}."
	        end
	        if lb_saved == true
				flash[:notice] = "Payment submitted successfully."
			else
				flash[:alert] =  ls_msg
		  	end
		else
			flash[:alert] = "Select atleast one service line item."
		end # end of if params[:lineitem_ids].present?
		redirect_to service_authorization_line_items_index_path(@provider_service_authorization.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationLineItemsController","service_payment_request_for_approval",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when requesting transportation service payment line items for approval."
		redirect_to_back
	end


private
		def line_item_params
			params.require(:service_authorization_line_item).permit(:service_begin_time, :service_end_time,
		                                                    :actual_quantity,:provider_invoice,:actual_cost,
		                                                    :override_reason,:notes
		                                                    )
	 	end

	 	def non_ts_line_item_params
		params.require(:service_authorization_line_item).permit(:service_date,
																:provider_invoice,
			 													:actual_cost,
																:actual_quantity,
			                                                    :notes
		                                                        )
	 	end
end