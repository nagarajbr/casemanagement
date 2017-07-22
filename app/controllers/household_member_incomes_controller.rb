class HouseholdMemberIncomesController  < AttopAncestorController
	# Author: Manoj Patil
	# 11/19/2015
	# Description : This controller actions are called from Household member finance steps
	# 04/21/2016 - mANOJ pATIL
	# modification : THIS CONTROLLER IS USED TO ADD EARNED INCOMES IN CLIENT DATA MANAGEMENT MENU


	def index
				@menu = "CLIENT"
				@client = Client.find(session[:CLIENT_ID].to_i)
				l_records_per_page = SystemParam.get_pagination_records_per_page
				# @incomes = Income.earned_income_records(@client.id)
		        @incomes = Income.earned_income_records(@client.id).page(params[:page]).per(l_records_per_page).order("effective_beg_date  desc")
				session[:NAVIGATED_FROM] = incomes_path(@menu)

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def new_household_member_income
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
			session[:NAVIGATE_FROM] = incomes_path(@menu)
		else
			@client = Client.find(params[:client_id].to_i)
		end

		@income = @client.incomes.new
		@income.recal_ind = 'Y'
		@employer_list = Employer.all
		@earned_income_types = CodetableItem.get_code_table_values_by_system_params('EARNED_INCOME_TYPES')
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomesController","new_household_member_income",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured in new_household_member_income action."
		redirect_to_back
	end

	def create_household_member_income
		@earned_income_types = CodetableItem.get_code_table_values_by_system_params('EARNED_INCOME_TYPES')
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		l_income_params = income_params_values_with_employment
		@income = @client.incomes.new(l_income_params)
		# save only income
		if 	@income.valid?
			# @income.save
			ls_msg = IncomeService.create_client_income_and_notes(@client.id,@income,params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Income saved."
				if params[:menu].present?
					# called from client maintenance
					redirect_to incomes_path("CLIENT")
				else
					# called from hh registration
					redirect_to start_household_member_registration_wizard_path
				end
			else
				flash[:alert] = ls_msg
				render :new_household_member_income
			end
		else
			render :new_household_member_income
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomesController","create_household_member_income",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving income."
		redirect_to_back
	end


	def show_household_member_income
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		@income = Income.find(params[:income_id])
		@notes = NotesService.get_notes(6150,@client.id,6484,@income.id)
		@client_incomes = ClientIncome.clients_sharing_income(@income.id,@client.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomesController","show_household_member_income",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid income record."
		redirect_to_back
	end

	def edit_household_member_income
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end


		@income = Income.find(params[:income_id])
		# @notes = NotesService.get_notes(6150,@client.id,6484,@income.id)
		@notes = nil
		# @income_types = CodetableItem.get_code_table_values_by_system_params('EARNED_INCOME_TYPES')
		@earned_income_types = CodetableItem.get_code_table_values_by_system_params('EARNED_INCOME_TYPES')
		if	Income.salary_income_type_present?(@income)
			@salary_income_type = 'Y'
		else
			@salary_income_type = 'N'
		end


	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomesController","edit_household_member_income",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured in edit_household_member_income action."
		redirect_to_back
	end

	def update_household_member_income
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		 @notes = nil
		# @income_types = CodetableItem.get_code_table_values_by_system_params('EARNED_INCOME_TYPES')
		@earned_income_types = CodetableItem.get_code_table_values_by_system_params('EARNED_INCOME_TYPES')


		@income = Income.find(params[:income_id])

		  l_params = income_params_values
		  if Income.salary_income_type_present?(@income)
		  	# No changes needed for fields
		  	# @income.incometype
	        #   	@income.source
	        #   	@income.frequency
		  else
		  	@income.incometype = l_params[:incometype]
	      	@income.source = l_params[:source]
	      	@income.frequency = l_params[:frequency]
		  end

	      @income.verified = l_params[:verified]
	      @income.effective_beg_date = l_params[:effective_beg_date]
	      @income.effective_end_date = l_params[:effective_end_date]
	      @income.intended_use_mos = l_params[:intended_use_mos]
	      @income.contract_amt = l_params[:contract_amt]
	      @income.inc_avg_beg_date = l_params[:inc_avg_beg_date]
	      @income.recal_ind = l_params[:recal_ind]

		if @income.valid?
			ls_msg = IncomeService.update_client_income_and_notes(@client.id,@income,params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Income saved."
				if params[:menu].present?
					redirect_to incomes_path("CLIENT")
				else
					redirect_to start_household_member_registration_wizard_path
				end

			else
				flash[:notice] = ls_msg
				render :edit_household_member_income
			end
		else
			render :edit_household_member_income
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomesController","update_household_member_income",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating income details."
		redirect_to_back
	end

	def delete_household_member_income
		if params[:menu].present?
			@menu = params[:menu]
			@client = Client.find(session[:CLIENT_ID].to_i)
		else
			@client = Client.find(params[:client_id].to_i)
		end
		@income = Income.find(params[:income_id])
		IncomeService.trigger_events_for_incomes(@income, @client.id, 435)
		@income.destroy
		if params[:menu].present?
			redirect_to incomes_path(@menu), alert: "Income deleted"
		else
			redirect_to start_household_member_registration_wizard_path, alert: "Income deleted"
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberIncomesController","delete_household_member_income",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when deleting income record."
		redirect_to_back
	end

	private

		def income_params_values
		  	params.require(:income).permit(:incometype,:verified,:frequency,:effective_beg_date,
		  		:effective_end_date,:intended_use_mos,:contract_amt,:inc_avg_beg_date,:recal_ind)
		end

		def income_params_values_with_employment
		  	params.require(:income).permit(:incometype,:source,:effective_beg_date,:verified,:frequency,:employment_effective_begin_date,
		  		:employment_effective_end_date,:intended_use_mos,:contract_amt,:inc_avg_beg_date,:recal_ind,
		  		:employer_id,:effective_begin_date,
                  :effective_end_date,:leave_reason)
		end


end
