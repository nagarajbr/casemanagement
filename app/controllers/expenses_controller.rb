class ExpensesController < AttopAncestorController

	def index
		if @client = Client.find(session[:CLIENT_ID])
			@cl_name = "#{@client.last_name}, #{@client.first_name}"
			l_records_per_page = SystemParam.get_pagination_records_per_page
		    @expense = @client.expenses.page(params[:page]).per(l_records_per_page)
			session[:NAVIGATED_FROM] = expenses_url
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ExpensesController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def new
		@client = Client.find(session[:CLIENT_ID])
		# Rails.logger.debug("@client = #{@client.inspect}")
		@expense = @client.expenses.new
		# Manoj 11/24/2015 - called from Household member step
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data(@client.id)
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ExpensesController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to create an expense for client."
		redirect_to_back
	end

	def create
	  	@client = Client.find(session[:CLIENT_ID])
	  	l_params=params_values
		l_params[:creditor_phone] = l_params[:creditor_phone].scan(/\d/).join
	    @expense = @client.expenses.new(l_params)

	    @menu = nil
	    if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data(@client.id)
			end
		end

		if @expense.valid?
			ls_msg = ExpenseService.create_client_expense_and_notes(@expense,session[:CLIENT_ID],params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Expense created."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					redirect_to start_household_member_registration_wizard_path
				else
					redirect_to expenses_path
				end
			else
				flash[:notice] = ls_msg
				render :new
			end
		else
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ExpensesController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving expense record."
		redirect_to_back
	end

	def show

		@client = Client.find(session[:CLIENT_ID])

		@menu = nil
		if params[:menu].present?

			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				@expense =  Expense.find(params[:expense_id].to_i)
				set_hoh_data(@client.id)
				@client_expenses = ClientExpense.clients_sharing_expense(params[:expense_id],@client.id)
			end
		else

			 @expense =  Expense.find(params[:id])
			 @client_expenses = ClientExpense.clients_sharing_expense(params[:id],session[:CLIENT_ID])
		end
		@notes = NotesService.get_notes(6150,@client.id,6485,@expense.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ExpensesController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid expense record."
		redirect_to_back
	end

	def edit
		@client = Client.find(session[:CLIENT_ID])
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				@expense =  Expense.find(params[:expense_id].to_i)
				set_hoh_data(@client.id)
			end
		else
			 @expense =  Expense.find(params[:id])
		end
		@notes = nil #NotesService.get_notes(6150,session[:CLIENT_ID],6485,@expense.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ExpensesController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit an expense for client."
		redirect_to_back
	end

	def update

		@client = Client.find(session[:CLIENT_ID])
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				@expense =  Expense.find(params[:expense_id].to_i)
				set_hoh_data(@client.id)
			end
		else

			 @expense =  Expense.find(params[:id])
		end
		l_params=params_values
		l_params[:creditor_phone] = l_params[:creditor_phone].scan(/\d/).join
		@expense.expensetype = l_params[:expensetype]
		@expense.frequency = l_params[:frequency]
		@expense.effective_beg_date = l_params[:effective_beg_date]
		@expense.effective_end_date = l_params[:effective_end_date]
		@expense.creditor_name = l_params[:creditor_name]
		@expense.creditor_contact = l_params[:creditor_contact]
		@expense.creditor_phone = l_params[:creditor_phone]
		@expense.creditor_ext = l_params[:creditor_ext]
		@expense.verified = l_params[:verified]
		@expense.exp_calc_months = l_params[:exp_calc_months]
		@expense.budget_recalc_ind = l_params[:budget_recalc_ind]

		if @expense.valid?
			ls_msg = ExpenseService.update_client_expense_and_notes(@expense,session[:CLIENT_ID],params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Expence saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					redirect_to start_household_member_registration_wizard_path
				else
					redirect_to expense_path
				end


			else
				flash[:notice] = ls_msg
				render :edit
			end
		else
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ExpensesController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating expense record."
		redirect_to_back
	end

	def expense_summary
        @client = Client.find(session[:CLIENT_ID])
        @expense_Collection = @client.expenses
        @expense_details_collection =ExpenseDetail.get_expense_details_for_client(session[:CLIENT_ID])
    rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ExpensesController","expense_summary",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid expense summary records."
			redirect_to_back
	end



      def destroy
      	@client = Client.find(session[:CLIENT_ID])
      	@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				@expense =  Expense.find(params[:expense_id].to_i)
				set_hoh_data(@client.id)
			end
		else

			 @expense =  Expense.find(params[:id])
		end

      	@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6485,@expense.id)
		ls_msg = ExpenseService.delete_client_expense_and_notes(@expense,session[:CLIENT_ID],@notes)
		if ls_msg == "SUCCESS"
			flash[:notice] = "Expense deleted."
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					redirect_to start_household_member_registration_wizard_path
			else
				redirect_to expenses_path
			end

		else
			flash[:notice] = ls_msg
			render :show
		end
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ExpensesController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to delete an expense for client."
		redirect_to_back
      end


    private

	    def params_values
			 params.require(:expense).permit(:expensetype, :frequency,:effective_beg_date,:effective_end_date,
		 	                              :creditor_name, :creditor_contact, :creditor_phone,:creditor_ext,
		 	                              :verified,:exp_calc_months,:budget_recalc_ind,:notes)
	    end

	 	# def set_id
			#  @expense =  Expense.find(params[:id])
	 	# end

	 	# Manoj 11/24/2015
	 #  	def set_hoh_data()
	 #  		li_member_id = params[:household_member_id].to_i
		# 	@household_member = HouseholdMember.find(li_member_id)
		# 	@household = Household.find(@household_member.household_id)
		# 	@head_of_household_name = HouseholdMember.get_hoh_name(@household.id)
		# end

end
