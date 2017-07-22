class HouseholdMemberIncomeDetailsController < AttopAncestorController
	# Author: Manoj Patil
	# 11/19/2015
	# Description : This controller actions are called from Household member finance steps
	def household_member_income_detail_index
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end

		@income = Income.find(params[:income_id])
		@income_details = @income.income_details
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailsController","household_member_income_detail_index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when showing income details."
		redirect_to_back
	end

	# 2.
	def new_household_member_income_detail
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		@income = Income.find(params[:income_id])
		@income_detail = @income.income_details.new
		@income_detail.cnt_for_convert_ind = 'Y'
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailsController","new_household_member_income_detail",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured in new action."
		redirect_to_back
	end

	# 3.
	def create_household_member_income_detail
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end

		@income = Income.find(params[:income_id])
		@income_detail = @income.income_details.new(income_detail_params_values)
		@income_detail.net_amt = params[:income_detail][:gross_amt].to_i - params[:income_detail][:adjusted_total].to_i
		if @income_detail.gross_amt.blank?
			@income_detail.gross_amt = 0
			@income_detail.net_amt = 0
		end
		@income_detail.adjusted_total = 0
		if @income_detail.valid?
			ls_msg = IncomeDetailService.create_client_income_detail_and_notes(@income_detail,@client.id,params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Income details saved."
				if params[:menu].present?
					# called from client maintenance
					redirect_to income_income_details_path("CLIENT",@income.id)
				else
					redirect_to household_member_income_detail_index_path(@client.id,@income.id)
				end

			else
				flash[:notice] = ls_msg
				render :new_household_member_income_detail
			end
		else
			render :new_household_member_income_detail
		end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailsController","create_household_member_income_detail",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Error occured when saving income check details."
	 	redirect_to_back
	end

	# 4.
	def show_household_member_income_detail
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		@income = Income.find(params[:income_id])
		@income_detail = IncomeDetail.find(params[:income_detail_id])
		@notes = NotesService.get_notes(6150,@client.id,6503,@income_detail.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailsController","show_household_member_income_detail",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when showing income check detail record."
		redirect_to_back
	end

	# 5.
	def edit_household_member_income_detail
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		@income = Income.find(params[:income_id])
		@income_detail = IncomeDetail.find(params[:income_detail_id])
		@notes = nil # NotesService.get_notes(6150,@client.id,6503,@income_detail.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailsController","edit_household_member_income_detail",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit invalid income check detail record."
		redirect_to_back
	end

	# 6.
	def update_household_member_income_detail
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		@income = Income.find(params[:income_id])
		@income_detail = IncomeDetail.find(params[:income_detail_id])

		adjusted_total = IncomeDetailAdjustReason.get_adjusted_total(@income_detail)
		@income_detail.adjusted_total = adjusted_total
		@income_detail.net_amt = params[:income_detail][:gross_amt].to_i - adjusted_total

		l_params = income_detail_params_values
		@income_detail.date_received = l_params[:date_received]
		@income_detail.check_type = l_params[:check_type]
		@income_detail.gross_amt = l_params[:gross_amt]
		@income_detail.cnt_for_convert_ind = l_params[:cnt_for_convert_ind]
		@income_detail.net_amt = l_params[:net_amt]
		@income_detail.adjusted_total = l_params[:adjusted_total]
		@notes = params[:notes]

		if @income_detail.valid?
			ls_msg = IncomeDetailService.update_client_income_detail_and_notes(@income_detail,session[:CLIENT_ID],params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Income details saved."
				if params[:menu].present?
					redirect_to income_income_details_path('CLIENT',@income.id)
				else
					redirect_to household_member_income_detail_index_path(@client.id,@income.id)
				end
			else
				flash[:notice] = ls_msg
				render :edit_household_member_income_detail
			end
		else
			render :edit_household_member_income_detail
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailsController","update_household_member_income_detail",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating income check detail."
		redirect_to_back
	end

	# 7.
	def delete_household_member_income_detail
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end

		@income = Income.find(params[:income_id])
		@income_detail = IncomeDetail.find(params[:income_detail_id])

		@notes = NotesService.get_notes(6150,@client.id,6503,@income_detail.id)
		ls_msg = IncomeDetailService.delete_client_income_detail_and_notes(@income_detail,@client.id,@notes)
		if ls_msg == "SUCCESS"
			flash[:notice] = "Income detail deleted."
			if params[:menu].present?
				redirect_to income_income_details_path('CLIENT',@income.id)
			else
				redirect_to household_member_income_detail_index_path(@client.id,@income.id)
			end
		else
			flash[:notice] = ls_msg
			render :show_household_member_income_detail
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomeDetailsController","delete_household_member_income_detail",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting income check detail."
		redirect_to_back
	end

	private

		def income_detail_params_values
			params.require(:income_detail).permit(:date_received,:check_type,:gross_amt,:cnt_for_convert_ind, :net_amt, :adjusted_total)
		end

end
