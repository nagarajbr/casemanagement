class OutOfStatePaymentsController < AttopAncestorController
	def index
		@client = Client.find(session[:CLIENT_ID])
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@out_of_state_payments = OutOfStatePayment.get_payments_for_the_client(session[:CLIENT_ID]).page(params[:page]).per(l_records_per_page)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("OutOfStatePaymentsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def edit
		@client = Client.find(session[:CLIENT_ID])
		@out_of_state_payments = OutOfStatePayment.new
		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("OutOfStatePaymentsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing out of state payment details."
		redirect_to_back
	end

	def create
		@client = Client.find(session[:CLIENT_ID])
		@out_of_state_payments = OutOfStatePayment.new
	    @out_of_state_payments.state = params[:out_of_state_payment][:state]
	    @out_of_state_payments.from = params[:from]
	    @out_of_state_payments.to = params[:to]
	    if @out_of_state_payments.validate_data
	    	if params[:from].present? and params[:to].present?
		    	from_date = params[:from].to_date
				to_date = params[:to].to_date
				from_date = Date.civil(from_date.year,from_date.month,1)
				to_date = Date.civil(to_date.year,to_date.month,1)

				ls_msg = OutofstatePaymentService.create_outofstate_payments(session[:CLIENT_ID],from_date,to_date,params[:out_of_state_payment][:state])
				if ls_msg == "SUCCESS"
					if session[:NAVIGATE_FROM].blank?
   						redirect_to out_of_state_payments_url,notice: "Out of state payments saved."
	   				else
	   					navigate_back_to_called_page()
	   				end
				else
					@out_of_state_payments.errors[:base] << ls_msg
					render :edit
				end
			else
				@out_of_state_payments.from = params[:out_of_state_payment][:from]
			@out_of_state_payments.to = params[:out_of_state_payment][:to]
			render :edit
			end
		else
			@out_of_state_payments.from = params[:out_of_state_payment][:from]
			@out_of_state_payments.to = params[:out_of_state_payment][:to]
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("OutOfStatePaymentsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving out of state payment details."
		redirect_to_back
	end


	def destroy
		@out_of_state_payments = OutOfStatePayment.find(params[:id])
		ls_msg = OutofstatePaymentService.delete_outofstate_payments(@out_of_state_payments,session[:CLIENT_ID])
		if ls_msg == "SUCCESS"
			flash[:alert] = "Out of state payment information deleted."
		else
			flash[:alert] = ls_msg
		end
		redirect_to out_of_state_payments_url
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("OutOfStatePaymentsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting out of state payment details."
		redirect_to_back
	end
end