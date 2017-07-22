class InStatePaymentsController < AttopAncestorController
	def index
        @client = Client.find(session[:CLIENT_ID])
		l_records_per_page = SystemParam.get_pagination_records_per_page
		 @in_state_payment = InStatePayment.get_payments_for_the_client(session[:CLIENT_ID]).order("payment_month  desc").page(params[:page]).per(l_records_per_page)
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InStatePaymentsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def show
         # @client = Client.find(session[:CLIENT_ID])
         # @in_state_payment = InStatePayment.find(params[:id])
         show_intake_payment_details(params[:id])
         Rails.logger.debug("show_intake_payment_details(params[:id]) = #{show_intake_payment_details(params[:id]).inspect}")
      rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InStatePaymentsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when showing in state payment details."
		redirect_to_back
	end


	def edit
		# @client = Client.find(session[:CLIENT_ID])
		#  @in_state_payment = InStatePayment.find(params[:id])
		edit_intake_payment(params[:id])
		@path = URI(request.referer).path
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InStatePaymentsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing in state payment details."
		redirect_to_back

	end

	def update
        # @in_state_payment = InStatePayment.find(params[:id])
		# if @in_state_payment.update(params_values)
		@in_state_payment = InStatePayment.find(params[:id])
		@path = URI(request.referer).path
		msg = InStatePayment.save_in_state_payment(@in_state_payment,params_values)
		if msg == "SUCCESS"
			redirect_to show_in_state_payments_url(@in_state_payment.id), notice: "In state payment information saved."
		else
			flash[:alert] = "#{msg}"
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InStatePaymentsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating in state payment details."
		redirect_to_back
	end


	def program_unit_instatepayments
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		@client_program_units = ProgramUnit.get_client_program_units(@client.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
	    @in_state_payment_list= InStatePayment.get_payments_program_unit(session[:PROGRAM_UNIT_ID])
	    if @in_state_payment_list.present?
	    	 @in_state_payment = @in_state_payment_list.order("payment_month  desc").page(params[:page]).per(l_records_per_page)
	    end
	     rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InStatePaymentsController","program_unit_instatepayments",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when showing  payment history."
		redirect_to_back
	end

	def program_unit_instatepayments_show
		 @selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		 show_intake_payment_details(params[:id])
		 Rails.logger.debug("show_intake_payment_details(params[:id]) = #{show_intake_payment_details(params[:id]).inspect}")
       # @client = Client.find(session[:CLIENT_ID])
		# @in_state_payment = InStatePayment.find(params[:id])
         # @in_state_payment = InStatePayment.get_payments_program_unit(session[:PROGRAM_UNIT_ID])
     rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InStatePaymentsController","program_unit_instatepayments_show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when showing detail payment history."
		redirect_to_back
	end

	def program_unit_instatepayments_edit
	    @selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		edit_intake_payment(params[:id])
		@path = URI(request.referer).path
		# @client = Client.find(session[:CLIENT_ID])
		# @in_state_payment = InStatePayment.find(params[:id])
		 # @in_state_payment = InStatePayment.get_payments_program_unit(session[:PROGRAM_UNIT_ID])
		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InStatePaymentsController","program_unit_instatepayments_edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing detail payment history."
		redirect_to_back
	end

def program_unit_instatepayments_update
# If the payment cancelled had a mandatory parent, the federal and state time (either TEA or Work pays) should be reduced by 1
# If the payment cancelled had a deferred parent, only the federal time limit should be reduced by 1
# If the program unit had two active adults, payment details and limit counts to both must be adjusted.
@in_state_payment = InStatePayment.find(params[:id])
	if (params_values[:action_type].to_i == 6054 or params_values[:action_type].to_i == 6055)
	instate_payments = InStatePayment.get_payment_from_program_unit_id_and_payment_month(@in_state_payment.program_unit_id,@in_state_payment.payment_month)
	instate_payments.each do |in_st_pymt|
		in_st_pymt.assign_attributes(params_values)
			begin
				ActiveRecord::Base.transaction do
					if in_st_pymt.save!
						# Rails.logger.debug("in_st_pymt = #{in_st_pymt.inspect}")
						time_limit = TimeLimit.get_details_by_client_id(in_st_pymt.client_id)
						# Rails.logger.debug("time_limit = #{time_limit.inspect}")
						if time_limit.present?
							time_limit = time_limit.first
							if (time_limit.federal_count.present? && time_limit.federal_count >= 0)
								time_limit.federal_count = time_limit.federal_count - 1
							end#time_limit.federal_count.present?
							if (in_st_pymt.work_participation_status == 5667 and in_st_pymt.service_program_id == 1)
								if time_limit.tea_state_count.present?
									time_limit.tea_state_count = time_limit.tea_state_count - 1
								end
							elsif in_st_pymt.service_program_id == 4
								if time_limit.work_pays_state_count.present?
									time_limit.work_pays_state_count = time_limit.work_pays_state_count - 1
								end
							end#@in_state_payment.work_participation_status
							time_limit.save!
						end#time_limit..present?
					else
						render :program_unit_instatepayments_edit
					end
				end
				# rescue => err
				# 	error_object = CommonUtil.write_to_attop_error_log_table("InStatePaymentsController","program_unit_instatepayments_update",err,AuditModule.get_current_user.uid)
				# 	lb_saved = false
				# 	ls_msg = "Failed to approve Benefit Amount - for more details refer to Error ID: #{error_object.id}"
			end
		end#instate_payments.each
		ls_msg = "SUCCESS"
		program_unit_object = ProgramUnit.find(@in_state_payment.program_unit_id)
		# if (program_unit_object.service_program_id == 1 || program_unit_object.service_program_id == 4) && (@in_state_payment.action_type.to_i == 6054 || @in_state_payment.action_type.to_i == 6055)
			# step1 : Populate common event management argument structure
			common_action_argument_object = CommonEventManagementArgumentsStruct.new
			common_action_argument_object.event_id = 817 # "InStatePaymentsController - Save"
			common_action_argument_object.program_unit_id = program_unit_object.id
			ls_msg = EventManagementService.process_event(common_action_argument_object)
		# end


	if ls_msg == "SUCCESS"
		redirect_to program_unit_in_state_payments_show_path(@in_state_payment.id), notice: "In state payment information saved."
	else
		flash.now[:alert] = ls_msg
		render :program_unit_instatepayments_edit
	end
		# redirect_to program_unit_in_state_payments_show_path(@in_state_payment.id), notice: "In state payment information saved "
	else
		if @in_state_payment.update(params_values)
			redirect_to program_unit_in_state_payments_show_path(@in_state_payment.id), notice: "In state payment information saved."
		else
			render :program_unit_instatepayments_edit
		end
	end#(params_values[:action_type].to_i == 6054 or params_values[:action_type].to_i == 6055)
# Rails.logger.debug("@in_state_payment = #{@in_state_payment.inspect}")
  rescue => err
	error_object = CommonUtil.write_to_attop_error_log_table("InStatePaymentsController","program_unit_instatepayments_update",err,current_user.uid)
	flash[:alert] = "Error ID: #{error_object.id} - Error when updating detail payment history."
	redirect_to_back
end

private

		def params_values
		  	params.require(:in_state_payment).permit(:action_date,:action_type,:work_participation_status)
		 end


		 def edit_intake_payment(arg_id)
		 	@client = Client.find(session[:CLIENT_ID])
			@in_state_payment = InStatePayment.find(arg_id)
		 end

		 # def update_intake_payment(arg_id)
		 # 	@in_state_payment = InStatePayment.find(params[:id])
			# update_flag = @in_state_payment.update(params_values)
		 # end

		 def show_intake_payment_details(arg_id)
		 	@client = Client.find(session[:CLIENT_ID])
         	@in_state_payment = InStatePayment.find(params[:id])
		 end








end






