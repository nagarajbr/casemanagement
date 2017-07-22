class HouseholdMemberIncomeDetailAdjustmentsController < AttopAncestorController
	# Author: Manoj Patil
	# 11/19/2015
	# Description : This controller actions are called from Household member finance steps
	# 1.
	def household_member_income_detail_adjustments_index
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		@income_detail = IncomeDetail.find(params[:income_detail_id])
		@income = Income.find(@income_detail.income_id)
		@adjust_reasons = @income_detail.income_detail_adjust_reasons
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailAdjustmentsController","household_member_income_detail_adjustments_index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid income check detail record."
		redirect_to_back
	end

	# 2.
	def new_household_member_income_detail_adjustment
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		@income_detail = IncomeDetail.find(params[:income_detail_id])
		@income = Income.find(@income_detail.income_id)
		@adjust_reason = @income_detail.income_detail_adjust_reasons.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailAdjustmentsController","new_household_member_income_detail_adjustment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid income check detail record."
		redirect_to_back
	end

	# 3.
	def create_household_member_income_detail_adjustment
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		@income_detail = IncomeDetail.find(params[:income_detail_id])
		@income = Income.find(@income_detail.income_id)
		@adjust_reason = @income_detail.income_detail_adjust_reasons.new(income_detail_adjustment_params_values)
		if @adjust_reason.valid?
			ls_msg = IncomeDetailAdjustReason.save_income_detail_adjust_reason(@adjust_reason,@income_detail,session[:CLIENT_ID])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Adjustment saved"
				if @menu == 'CLIENT'
					redirect_to income_detail_income_detail_adjust_reasons_path(@menu,@income_detail.id)
				else
					redirect_to household_member_income_detail_adjustments_index_path(@client.id,@income_detail.id)
				end
			else
				flash[:alert] = ls_msg
				render :new_household_member_income_detail_adjustment
			end
		else
			render :new_household_member_income_detail_adjustment
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailAdjustmentsController","create_household_member_income_detail_adjustment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving income adjustment details record."
		redirect_to_back
	end

	# 4.
	def edit_household_member_income_detail_adjustment
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		@income_detail = IncomeDetail.find(params[:income_detail_id])
		@income = Income.find(@income_detail.income_id)
		@adjust_reason = IncomeDetailAdjustReason.find(params[:income_detail_adjustment_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailAdjustmentsController","edit_household_member_income_detail_adjustment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving income adjustment details record."
		redirect_to_back
	end

	# 5.
	def update_household_member_income_detail_adjustment
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end

		@income_detail = IncomeDetail.find(params[:income_detail_id])
		@income = Income.find(@income_detail.income_id)
		@adjust_reason = IncomeDetailAdjustReason.find(params[:income_detail_adjustment_id])

		l_params = income_detail_adjustment_params_values
		@adjust_reason.adjusted_amount = l_params[:adjusted_amount]
		@adjust_reason.adjusted_reason = l_params[:adjusted_reason]
		if @adjust_reason.valid?
			ls_msg = IncomeDetailAdjustReason.save_income_detail_adjust_reason(@adjust_reason,@income_detail,@client.id)
			if ls_msg == "SUCCESS"
				flash[:notice] = "Adjustment saved"
				if @menu == 'CLIENT'
					redirect_to income_detail_income_detail_adjust_reasons_path(@menu,@income_detail.id)
				else
					redirect_to household_member_income_detail_adjustments_index_path(@client.id,@income_detail.id)
				end
			else
				flash[:alert] = ls_msg
				render :edit_household_member_income_detail_adjustment
			end
		else
			@show_delete = true
		   render :edit_household_member_income_detail_adjustment
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailAdjustmentsController","update_household_member_income_detail_adjustment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when updating income detail adjustment record."
		redirect_to_back
	end

	# 6.
	def delete_household_member_income_detail_adjustment
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end

		@income_detail = IncomeDetail.find(params[:income_detail_id])
		@income = Income.find(@income_detail.income_id)
		@adjust_reason = IncomeDetailAdjustReason.find(params[:income_detail_adjustment_id])

		@adjust_reason.destroy
		ld_adjusted_total = IncomeDetailAdjustReason.get_adjusted_total(@income_detail.id)
	  	@income_detail.adjusted_total = ld_adjusted_total
		@income_detail.net_amt = (@income_detail.gross_amt - ld_adjusted_total)
		@income_detail.save
		if @menu == 'CLIENT'
			redirect_to income_detail_income_detail_adjust_reasons_path(@menu,@income_detail.id)
		else
			redirect_to household_member_income_detail_adjustments_index_path(@client.id,@income_detail.id), notice: "Adjustment deleted"
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailAdjustmentsController","delete_household_member_income_detail_adjustment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when deleting income detail adjustment record."
		redirect_to_back
	end

	# 7.
	def show_household_member_income_detail_adjustment
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end

		@income_detail = IncomeDetail.find(params[:income_detail_id])
		@income = Income.find(@income_detail.income_id)
		@adjust_reason = IncomeDetailAdjustReason.find(params[:income_detail_adjustment_id])
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailAdjustmentsController","show_household_member_income_detail_adjustment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid income detail adjustment record."
		redirect_to_back
	end

	private

		def income_detail_adjustment_params_values
			params.require(:income_detail_adjust_reason).permit(:adjusted_amount,:adjusted_reason)
		end

end
