class SuplRetroBnsPaymentsController < AttopAncestorController

	before_action :set_id, only: [:edit,:update,:show,:destroy]
	before_action :set_client_id, except: [:destroy]
	before_action :set_current_date, only: [:new, :edit]

	def index
		@supplement_payments = SuplRetroBnsPayment.get_payments_details_from_program_unit_id(session[:PROGRAM_UNIT_ID])
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("SuplRetroBnsPaymentsController","index",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
			redirect_to_back
	end

	def new
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		@supplement_payment = SuplRetroBnsPayment.new
		set_payment_type_options
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("SuplRetroBnsPaymentsController","index",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when attempting to add payment information."
			redirect_to_back
	end

	def create
			@supplement_payment = SuplRetroBnsPayment.new(params_values)
			@supplement_payment.program_unit_id = session[:PROGRAM_UNIT_ID]
			@supplement_payment.payment_status = 6191
			@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
			if @supplement_payment.valid?
			 	msg = SuplRetroBnsPayment.create_or_update_supplement_payment(@supplement_payment)
			 	if msg == "SUCCESS"
				 	redirect_to supl_retro_bns_payments_path,notice: "#{CodetableItem.get_short_description(@supplement_payment.payment_type)} Payment created successfully!"
				else
					flash.now[:notice] = "Can't create supplement payment #{msg}"
					set_payment_type_options
					render :new
				end
			else
				# flash.now[:notice] = "Can't create #{CodetableItem.get_short_description(@supplement_payment.payment_type)} Payment!"
				set_payment_type_options
				render :new
			end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("SuplRetroBnsPaymentsController","create",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when saving payment information."
			redirect_to_back
	end

	def edit
		@payment_types = CodetableItem.where("id = ?", @supplement_payment.payment_type)
		# @payment_amount = get_payment_amount_from_bonus_type(@supplement_payment.payment_type)
		if @supplement_payment.payment_status != 6193 # if payment is not reimbursed then only provide cancelled option
			@payment_status = CodetableItem.where("id in (6196)")
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("SuplRetroBnsPaymentsController","edit",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when editing payment information."
			redirect_to_back
	end

	def update
		@supplement_payment.payment_type = params[:supl_retro_bns_payment][:payment_type]
		@supplement_payment.payment_month = params[:supl_retro_bns_payment][:payment_month]
		@supplement_payment.payment_amount = params[:supl_retro_bns_payment][:payment_amount]
		@supplement_payment.reason = params[:supl_retro_bns_payment][:reason]
		@supplement_payment.payment_status = params[:supl_retro_bns_payment][:payment_status].present? ? params[:supl_retro_bns_payment][:payment_status] : @supplement_payment.payment_status
		if @supplement_payment.valid?
		 	msg = SuplRetroBnsPayment.create_or_update_supplement_payment(@supplement_payment)
		 	if msg == "SUCCESS"
			 	redirect_to supl_retro_bns_payment_path(@supplement_payment.id), notice: "#{CodetableItem.get_short_description(@supplement_payment.payment_type)} Payment updated successfully"
			else
				flash.now[:notice] = "Can't update #{CodetableItem.get_short_description(@supplement_payment.payment_type)} Payment #{msg}"
				@payment_types = CodetableItem.where("id = ?", @supplement_payment.payment_type)
				# @payment_amount = get_payment_amount_from_bonus_type(@supplement_payment.payment_type)
				render :edit
			end
		else
			flash.now[:notice] = "Can't create #{CodetableItem.get_short_description(@supplement_payment.payment_type)} Payment!"
			@payment_types = CodetableItem.where("id = ?", @supplement_payment.payment_type)
			# @payment_amount = get_payment_amount_from_bonus_type(@supplement_payment.payment_type)
			render :edit
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("SuplRetroBnsPaymentsController","update",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when updating payment information."
			redirect_to_back
	end

	def show
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("SuplRetroBnsPaymentsController","show",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when showing payment information."
			redirect_to_back
	end

	def destroy
		@supplement_payment.destroy
		redirect_to supl_retro_bns_payments_path, alert: "Payment information has been deleted."

	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("SuplRetroBnsPaymentsController","destroy",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when deleting payment information."
			redirect_to_back
	end

	private

		def params_values
		  	params.require(:supl_retro_bns_payment).permit(:program_unit_id,:payment_type,:payment_month,:payment_amount,:reason)
		end

		# def params_update_values
		#   	params.require(:supl_retro_bns_payment).permit(:program_unit_id,:payment_type,:payment_month,:payment_amount,:reason,:payment_status)
		# end

		def set_id
			@supplement_payment =  SuplRetroBnsPayment.find(params[:id])
	  	end

	  	def set_client_id
			@client = Client.find(session[:CLIENT_ID])
	  	end

	  	def set_current_date
	  		@current_date = Date.today
	  	end

	  	def set_payment_type_options
	  		# bonus is
	  		@payment_types = SuplRetroBnsPayment.get_payment_types_for_tea_or_work_pays_service_program
		# service_program_id = ProgramUnit.get_service_program_id(session[:PROGRAM_UNIT_ID])
		# case service_program_id
		# when 1
		# 	#(6228,6229)
		# 	@payment_types = SuplRetroBnsPayment.get_payment_types_for_tea_service_program
		# when 4
		# 	@payment_types = SuplRetroBnsPayment.get_payment_types_for_work_pays_service_program(session[:PROGRAM_UNIT_ID])
		# 	participation_statuses = ProgramUnitParticipation.get_participation_status(session[:PROGRAM_UNIT_ID])
		# 	if ProgramUnitParticipation.is_program_unit_participation_status_closed(session[:PROGRAM_UNIT_ID]) == true
		# 		if SuplRetroBnsPayment.exit_bonus_is_issued(session[:PROGRAM_UNIT_ID]) #If an exit bonus is issued and if it's status is not cancelled then don't provide any options for payment type
		# 			@payment_types =  @payment_types.where("id in(6229,6228)") # Just to populate an empty collection
		# 		else
		# 			@payment_types = @payment_types.where("id in(6233,6229,6228) ")
		# 		end
		# 	elsif previous_month_bonus_is_reimbursed
		# 		@payment_types = @payment_types.limit(3)
		# 	else
		# 		@payment_types = @payment_types.limit(3)
		# 	end
		# 	if @payment_types.present?
		# 		bonus_type = @payment_types.where("id in (6230, 6231, 6232,6233,6229,6228)")
		# 		if bonus_type.present?
		# 			bonus_type = bonus_type.first.id
		# 			@payment_amount = get_payment_amount_from_bonus_type(bonus_type)
		# 		end
		# 	end
		# end
	end

	# def get_payment_amount_from_bonus_type(bonus_type)

	# 	case bonus_type
	# 		when 6230
	# 			return SystemParam.get_key_value(15,"WORK PAYS First Bonus Amount","WORK PAYS First Bonus Amount")
	# 		when 6231
	# 			return SystemParam.get_key_value(15,"WORK PAYS Second Bonus Amount", "WORK PAYS Second Bonus Amount")
	# 		when 6232
	# 			return SystemParam.get_key_value(15,"WORK PAYS Third Bonus Amount", "WORK PAYS Third Bonus Amount")
	# 		when 6233
	# 			return SystemParam.get_key_value(15,"WORK PAYS EXIT Bonus Amount", "WORK PAYS Third Bonus Amount")
	# 	end

	# end

	# def previous_month_bonus_is_reimbursed
	# 	result = false
	# 	bonus_type = @payment_types.where("id in (6230, 6231, 6232, 6233,6229)")
	# 	if bonus_type.present?
	# 		bonus_type = bonus_type.first.id
	# 		case bonus_type
	# 		when 6230
	# 			result = true
	# 		when 6231
	# 			result = SuplRetroBnsPayment.is_previous_month_bonus_reimbursed(session[:PROGRAM_UNIT_ID], 6230)
	# 		when 6232
	# 			result = SuplRetroBnsPayment.is_previous_month_bonus_reimbursed(session[:PROGRAM_UNIT_ID], 6231)
	# 		when 6233
	# 			result = SuplRetroBnsPayment.is_previous_month_bonus_reimbursed(session[:PROGRAM_UNIT_ID], 6232)
	# 		end
	# 	end
	# 	return result
	# end

end
