class ProviderAgreementsController <  AttopAncestorController
 respond_to :pdf, :html

	def index
  		@provider = Provider.find(session[:PROVIDER_ID])
    	@provider_agreements = ProviderAgreement.get_provider_agreements(session[:PROVIDER_ID])
   rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","index",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid provider"
			redirect_to_back
  	end

def show
	@read_only = false
	@agreement_approved = false
  	@can_show_approve_reject_buttons = false
  	@can_show_request_for_approval_button = false

  	@provider = Provider.find(session[:PROVIDER_ID])
	@provider_agreement = ProviderAgreement.find(params[:id])
	# @provider_agreement_areas = @provider_agreement.provider_agreement_areas
	# @provider_formatted_areas = get_formatted_provider_areas(@provider_agreement.id)
	# Rule1: After provider Agreement is approved - screen becomes read only - Only Termination can be done.
	# if @provider_agreement.status == 6166
	if @provider_agreement.state == 6166
		# Approved
		@agreement_approved = true
	end
	if @provider_agreement.state == 6266
		# terminated
		@read_only = true
	end
	# if @provider_agreement.status == 6373
	if @provider_agreement.state == 6373
		# Requested.
		@can_show_approve_reject_buttons = true
	end

	# if @provider_agreement.status == 6165
	if @provider_agreement.state == 6165
		# complete.
		@can_show_request_for_approval_button = true
	end

rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","show",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid agreement"
			redirect_to_back
end

  def provider_agreement_wizard_initialize
  	session[:PROVIDER_AGREEMENT_STEP] = session[:PROVIDER_AGREEMENT_ID] = nil

  	redirect_to start_provider_agreement_wizard_path
  end

  # Edit Link on Application show page will call this action.
	def edit_provider_agreement_wizard
		@provider = Provider.find(session[:PROVIDER_ID])
		session[:PROVIDER_AGREEMENT_STEP] =  nil
		session[:PROVIDER_AGREEMENT_ID] =  params[:id]
      	redirect_to start_provider_agreement_wizard_path
	end



  def start_provider_agreement_wizard
  	@provider = Provider.find(session[:PROVIDER_ID])
	if session[:PROVIDER_AGREEMENT_STEP].blank?
  	 	session[:PROVIDER_AGREEMENT_STEP] = nil
  	end

	if session[:PROVIDER_AGREEMENT_ID].present?
	  	@provider_agreement = ProviderAgreement.find(session[:PROVIDER_AGREEMENT_ID].to_i)
	  	# get the service type selected.
	  	li_service_id = @provider_agreement.provider_service_id
	  	@provider_service_areas_for_service_type = ProviderServiceArea.get_service_areas_for_provider_service_id(li_service_id)

	  	if @provider_service_areas_for_service_type.present?
	  		li_areas_array = Array.new
	  		 @provider_service_areas_for_service_type.each do |each_area|
	  		 	li_areas_array << each_area.local_office_id
	  		 end
	  		 # @service_area_drop_down = CodetableItem.items_to_include (code_table_id,id,description)
	  		 @service_area_drop_down = CodetableItem.items_to_include(2,li_areas_array,"local offices selected for service area")
	  	else
	  		@service_area_drop_down = CodetableItem.where("1=2")
	  	end
	else
		@provider_agreement = ProviderAgreement.new
		@service_area_drop_down = CodetableItem.where("1=2")
	end
	@provider_agreement.current_step = session[:PROVIDER_AGREEMENT_STEP]
	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","start_provider_agreement_wizard",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid provider"
			redirect_to_back
  end

  def process_provider_agreement_wizard

  		# like create REST action
		# Multi step form create - wizard
		#  Rule1 - Processing takes place only when "NEXT" button is clicked.
		#  Rule2 - When "BACK" button is clicked just navigate to previous step - NO PROCESSING needed.
		# Instantiate client object
		# populate instance variables
		# Instantiate client_application object
		@provider = Provider.find(session[:PROVIDER_ID])
		# populate instance variables
		if session[:PROVIDER_AGREEMENT_ID].blank?
      	 	@provider_agreement = ProviderAgreement.new
      	else
      	 	@provider_agreement = ProviderAgreement.find(session[:PROVIDER_AGREEMENT_ID].to_i)
      	end
      	@provider_agreement.current_step = session[:PROVIDER_AGREEMENT_STEP]

      	 # manage steps
      	if params[:back_button].present?
      		 @provider_agreement.previous_step
      	elsif @provider_agreement.last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
           @provider_agreement.next_step
        end
       session[:PROVIDER_AGREEMENT_STEP] = @provider_agreement.current_step
       #manage steps - end

        # what step to process?
		if @provider_agreement.get_process_object == "provider_agreement_details_first" && params[:next_button].present?

			local_params = params_first_step
		 	if session[:PROVIDER_AGREEMENT_ID].present?
		 		@provider_agreement = ProviderAgreement.find(session[:PROVIDER_AGREEMENT_ID].to_i)
		 		# @provider_agreement_area = ProviderAgreementArea.
		 		@provider_agreement.provider_id = session[:PROVIDER_ID]
		 		@provider_agreement.provider_service_id = local_params[:provider_service_id]
		 		@provider_agreement.agreement_start_date = local_params[:agreement_start_date]
		 		@provider_agreement.agreement_end_date = local_params[:agreement_end_date]
		 		@provider_agreement.state = 6164
		 	else
		 		@provider_agreement = ProviderAgreement.new(local_params)
		 		@provider_agreement.provider_id = session[:PROVIDER_ID]
		 		@provider_agreement.state = 6164
		 	end

	 		if @provider_agreement.valid?
	 			# if there is an incomplete agreement found - delete it. / incomplete in previous step.
	 			# @provider_agreement = ProviderAgreement.save_provider_agreement(@provider_agreement)
	 			@provider_agreement.save
	 			session[:PROVIDER_AGREEMENT_ID]  =  @provider_agreement.id
	 			redirect_to start_provider_agreement_wizard_path
	 		else
	 			session[:PROVIDER_AGREEMENT_STEP] = nil
				render :start_provider_agreement_wizard
	 		end
		elsif @provider_agreement.get_process_object == "provider_agreement_county_second" && params[:next_button].present?
				local_params = params_step_two
				@provider_agreement.dws_local_office_id = local_params[:dws_local_office_id]
		 		@provider_agreement.dws_local_office_manager_id = local_params[:dws_local_office_manager_id]
		 	if @provider_agreement.valid?
		 		@provider_agreement.save
		 		# save provider agreement area
				ProviderAgreementArea.save_provider_agreement_area(@provider_agreement.id,@provider_agreement.dws_local_office_id)
		 		redirect_to start_provider_agreement_wizard_path
			else
				# go back to previous step and show flash message as error message
		 		@provider_agreement.previous_step
		 		session[:PROVIDER_AGREEMENT_STEP] = @provider_agreement.current_step
		 		# populate dropdown to show in view
		 		li_service_id = @provider_agreement.provider_service_id
			  	@provider_service_areas_for_service_type = ProviderServiceArea.get_service_areas_for_provider_service_id(li_service_id)
			  	if @provider_service_areas_for_service_type.present?
			  		li_areas_array = Array.new
			  		 @provider_service_areas_for_service_type.each do |each_area|
			  		 	li_areas_array << each_area.local_office_id
			  		 end
			  		 # @service_area_drop_down = CodetableItem.items_to_include (code_table_id,id,description)
			  		 @service_area_drop_down = CodetableItem.items_to_include(2,li_areas_array,"local offices selected for service area")
			  	else
			  		@service_area_drop_down = CodetableItem.where("1=2")
			  	end
		 		render :start_provider_agreement_wizard
			end
		elsif @provider_agreement.current_step == "provider_agreement_review_last"
			 @provider_agreement.state = 6165
			# @provider_agreement.complete
			 @provider_agreement.save
			redirect_to provider_agreements_show_path(@provider_agreement.id)
		else
			# back button
			redirect_to start_provider_agreement_wizard_path
		end
	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","process_provider_agreement_wizard",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error occured when processing agreement"
			redirect_to_back
  end


	def approve_provider_agreement
		lb_saved = true
		@provider = Provider.find(session[:PROVIDER_ID])
		provider_agreement_object = ProviderAgreement.find(params[:id])
		# if @provider.status == 6156 # AASIS VERIFIED
              # step1 : Populate common event management argument structure
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
		        common_action_argument_object.event_id = 687 # "Request to Approve Provider Agreement is Approved"
		        common_action_argument_object.provider_agreement_id = provider_agreement_object.id
		        begin
      				ActiveRecord::Base.transaction do
				        # step2: call common method to process event.
				        ls_msg = EventManagementService.process_event(common_action_argument_object)
				        if ls_msg == "SUCCESS"
				        	lb_saved = provider_agreement_object.approve
							unless lb_saved
								ls_msg = provider_agreement_object.errors.full_messages.last
							end
						else
							lb_saved = false
						end
				  	end
			  	rescue => err
			  		error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","approve_provider_agreement",err,current_user.uid)
			  		lb_saved = false
			  		ls_msg = "Failed to approve Provider agreement failed - for more details refer to Error ID: #{error_object.id}"
		        end

				if lb_saved
					flash[:notice] = "Provider agreement Approved Successfully."
				else
					flash[:alert] = ls_msg
				end
				redirect_to provider_agreements_path
		# else
		# 	flash[:alert] = "This Provider is not Verified by AASIS.Only AASIS verified Provider's Agreement can be Approved."
		# 	redirect_to provider_agreements_show_path(provider_agreement_object.id)
		# end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","approve_provider_agreement",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when approving Provider Agreement"
		redirect_to_back

	end




	def provider_agreement_print
		provider = ProviderAgreement.agreement_details_to_print(params[:id])
 		@file = Tea1432.new(provider).export
 		send_file(@file, :type => "pdf", :filename => "Agreement_for_#{provider.provider_name}.pdf", :dispostion => "inline" )
#        send_data(@file.to_pdf)
   		#File.delete(@file)
   		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","provider_agreement_print",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when printinging Provider Agreement"
		redirect_to_back

    end



	def provider_agreement_termination_date_reason_update
		@provider_agreement = ProviderAgreement.find(params[:id])
		@provider_agreement.state = 6266
		# ls_message = ProviderAgreement.termination_reason_and_date_required(params_termination[:termination_reason],params_termination[:termination_date])
		# if  ls_message == "SUCESS"
			if @provider_agreement.update(params_termination)
				redirect_to provider_agreements_show_path(@provider_agreement.id), notice: "Termination added"
		    else
		    	@provider = Provider.find(session[:PROVIDER_ID])
		    	render :provider_agreement_termination_edit
		    end
		# else
		# 	@provider_agreement_error = ProviderAgreement.termination_reason_and_date_required(params_termination[:termination_reason],params_termination[:termination_date])
		# 	render :provider_agreement_termination_edit
		# end
		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","provider_agreement_termination_date_reason_update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating Provider Agreement"
		redirect_to_back

	end


	def provider_agreement_reject_edit

		@provider = Provider.find(session[:PROVIDER_ID])
		@provider_agreement = ProviderAgreement.find(params[:id])
		@provider_formatted_areas = get_formatted_provider_areas(@provider_agreement.id)
		# @provider_agreements = ProviderAgreement.where("provider_id = ?", @provider_agreement.provider_id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","provider_agreement_reject_edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when rejecting the Provider agreement"
		redirect_to_back
	end

	def provider_agreement_reject_update
		lb_saved = true
		@provider = Provider.find(session[:PROVIDER_ID])
		@provider_agreement = ProviderAgreement.find(params[:id])
		l_params = params_rejection
		@provider_agreement.reason = l_params[:reason]
		li_pa_state = @provider_agreement.state
		@provider_agreement.state = 6167
		# @provider_agreement.reject
		# @provider_agreement.rejected_by = current_user.uid
		# @provider_agreement.rejected_date = DateTime.now
		if @provider_agreement.valid?
			@provider_agreement.state = li_pa_state
			# step1 : Populate common event management argument structure
			common_action_argument_object = CommonEventManagementArgumentsStruct.new
	        common_action_argument_object.event_id = 691 # "Request to Approve Provider Agreement is Rejected"
	        common_action_argument_object.provider_agreement_id = @provider_agreement.id
	        begin
  				ActiveRecord::Base.transaction do
			        # common_action_argument_object.provider_id = @provider_agreement.provider_id
			        # step2: call common method to process event.
			        ls_msg = EventManagementService.process_event(common_action_argument_object)
		        	if ls_msg == "SUCCESS"
			        	lb_saved = @provider_agreement.reject
						unless lb_saved
							ls_msg = @provider_agreement.errors.full_messages.last
						end
					else
						lb_saved = false
					end
			  	end
		  	rescue => err
		  		error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","approve_provider_agreement",err,current_user.uid)
		  		lb_saved = false
		  		ls_msg = "Failed to reject Provider agreement - for more details refer to Error ID: #{error_object.id}"
	        end

			if lb_saved
				flash[:notice] = "Provider Agreement rejected."
				redirect_to provider_agreements_path
			else
				flash[:alert] = ls_msg
				redirect_to provider_agreements_show_path(@provider_agreement.id)
			end
	    else
	    	render :provider_agreement_reject_edit
	    end



	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","provider_agreement_reject_update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Error when rejecting the Provider agreement"
		redirect_to_back
	end

	def request_for_approval
		lb_saved = true
		li_provider_agreement_id = params[:id]
		provider_agreement_object = ProviderAgreement.find(li_provider_agreement_id)
		ls_local_office = CodetableItem.get_short_description (18)
		# ls_return  = WorkTask.create_provider_agreement_request_for_approval_task(li_provider_agreement_id)

		# step1 : Populate common event management argument structure
		common_action_argument_object = CommonEventManagementArgumentsStruct.new
        common_action_argument_object.event_id = 690 # request for Approval of Provider Agreement
        common_action_argument_object.provider_agreement_id = li_provider_agreement_id
        begin
			ActiveRecord::Base.transaction do
		        # step2: call common method to process event.
		        ls_msg = EventManagementService.process_event(common_action_argument_object)
		        if ls_msg == "SUCCESS"
		        	lb_saved = provider_agreement_object.request
					unless lb_saved
						ls_msg = provider_agreement_object.errors.full_messages.last
					end
				else
					lb_saved = false
				end
		  	end
	  	rescue => err
	  		error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","approve_provider_agreement",err,current_user.uid)
	  		lb_saved = false
	  		ls_msg = "Failed to approve Provider agreement failed - for more details refer to Error ID: #{error_object.id}"
        end

		if lb_saved
			flash[:notice] = "Request for Approval of Provider Agreement is sent to: #{ls_local_office},Supervisor will review and approve the Agreement."
		else
			flash[:alert] = ls_msg
		end
		redirect_to provider_agreements_show_path(li_provider_agreement_id)
	end



	def provider_agreement_termination_edit
		@provider = Provider.find(session[:PROVIDER_ID])
		@provider_agreement = ProviderAgreement.find(params[:id])

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","provider_agreement_termination_edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing Provider Agreement"
		redirect_to_back

	end



	def provider_agreement_termination_date_reason_update
		@provider_agreement = ProviderAgreement.find(params[:id])
		li_pa_state = @provider_agreement.state
		@provider_agreement.state = 6266
		l_params = params_termination
		@provider_agreement.termination_reason = l_params[:termination_reason]
		@provider_agreement.termination_date = l_params[:termination_date]
		# ls_message = ProviderAgreement.termination_reason_and_date_required(params_termination[:termination_reason],params_termination[:termination_date])
		# if  ls_message == "SUCESS"
			if @provider_agreement.valid?
				@provider_agreement.state = li_pa_state
				@provider_agreement.terminate
				ls_flash_message = "Provider Agreement Terminated"
				flash[:notice] = ls_flash_message
				redirect_to provider_agreements_show_path(@provider_agreement.id)
		    else
		    	@provider = Provider.find(session[:PROVIDER_ID])
		    	render :provider_agreement_termination_edit
		    end
		# else
		# 	@provider_agreement_error = ProviderAgreement.termination_reason_and_date_required(params_termination[:termination_reason],params_termination[:termination_date])
		# 	render :provider_agreement_termination_edit
		# end
		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","provider_agreement_termination_date_reason_update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating Provider Agreement"
		redirect_to_back

	end

	def provider_agreement_print
		provider = ProviderAgreement.agreement_details_to_print(params[:id])
 		@file = Tea1432.new(provider).export
 		#send_file(@file, :type => "pdf", :filename => "Agreement_for_#{provider.provider_name}.pdf", :dispostion => "inline" )
#        send_data(@file.to_pdf)
   		#File.delete(@file)
   		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderAgreementsController","provider_agreement_print",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when printinging Provider Agreement"
		redirect_to_back

    end



private


	def get_formatted_provider_areas(arg_agreement_id)
		service_area_collection = ProviderAgreementArea.get_distinct_local_offices(arg_agreement_id)
		ls_return = ""
		service_area_collection.each do |service_area|
			ls_description = CodetableItem.get_short_description(service_area.served_local_office_id)
			ls_return = ls_return + ls_description+","
		end
		ls_return_length = ls_return.length
		ls_return_length = ls_return_length - 2
		ls_return[0..ls_return_length]
	end

	def params_first_step
		params.require(:provider_agreement).permit(:provider_service_id,:dws_local_office_id,:dws_local_office_manager_id,:agreement_start_date,:agreement_end_date)
	end

	def params_step_two
		params.require(:provider_agreement).permit(:dws_local_office_id,:dws_local_office_manager_id)
	end



      def params_termination

      	params.require(:provider_agreement).permit(:termination_reason , :termination_date)

      end

 def params_rejection

      	params.require(:provider_agreement).permit(:reason )

      end


end




