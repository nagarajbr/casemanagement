class IncomesController < AttopAncestorController

	# Manoj 04/21/2016
	# Description : INCOME CONTROLLER IS USED FOR UNEARNED INCOMES ONLY *****************
	before_action :set_client_id
	before_action :set_menu
	before_action :set_id, only: [:show,:edit,:update,:destroy]

	def index
		# if @menu == "CLIENT"
		# 	session["FOCUS_MENU"] = "CLIENT"
		# end
		# if @menu == "ASSESSMENT"
		# 	session["FOCUS_MENU"] = "ASSESSMENT"
		# end
		if session[:CLIENT_ID].present?
				l_records_per_page = SystemParam.get_pagination_records_per_page
				# @unearned_incomes = Income.unearned_income_records(@client.id)
		        @incomes = Income.unearned_income_records(@client.id).page(params[:page]).per(l_records_per_page).order("effective_beg_date  desc")
				session[:NAVIGATED_FROM] = unearned_incomes_path(@menu)
				# if @menu == "ASSESSMENT"
				# 	if session[:CLIENT_ASSESSMENT_ID].present?
				# 		@assessment_id = session[:CLIENT_ASSESSMENT_ID].to_i
				# 		@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				# 		@client_assessment.current_step = "/ASSESSMENT/incomes"
				# 		session["CURRENT_MENU_SELECTED"] = @client_assessment.current_step

				# 	end
				# end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def new
		if session[:CLIENT_ID].present?
		    @income = @client.incomes.new
		    @income.recal_ind = 'Y'

		    # Manoj 01/27/2016 - called from Household member step

			if params[:menu].present?
				@menu = params[:menu]
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					set_hoh_data_and_unearned_income_types_data()
				end
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to create a new income for client."
		redirect_to_back
	end

	def create


		l_params = params_values
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data_and_unearned_income_types_data()
			end
		end

		@income = @client.incomes.new(l_params)
		if @income.valid?
			ls_msg = IncomeService.create_client_income_and_notes(@client.id,@income,params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Income saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					redirect_to start_household_member_registration_wizard_path
				else
					redirect_to unearned_incomes_path(@menu)
				end

			else
				flash[:notice] = ls_msg
				render :new
			end
		else
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving income details."
		redirect_to_back
	end

	def show

		# if @menu.blank?
		# 	if session["FOCUS_MENU"].present?
		# 		@menu = session["FOCUS_MENU"]
		# 	else
		# 		@menu = "CLIENT"
		# 	end
		# end

		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data_and_unearned_income_types_data()
			end
		end

		# self.get_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6484,@income.id)
		@client_incomes = ClientIncome.clients_sharing_income(params[:id],session[:CLIENT_ID])
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid income record."
		redirect_to_back
	end

	def edit
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data_and_unearned_income_types_data()
			end
		end
		@notes = nil # NotesService.get_notes(6150,session[:CLIENT_ID],6484,@income.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit income for client."
		redirect_to_back
	end

	def update
		@notes = nil

		l_params = params_values
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data_and_unearned_income_types_data()
			end
		end
		 @income.incometype = l_params[:incometype]
	      @income.source = l_params[:source]
	      @income.verified = l_params[:verified]
	      @income.frequency = l_params[:frequency]
	      @income.effective_beg_date = l_params[:effective_beg_date]
	      @income.effective_end_date = l_params[:effective_end_date]
	      @income.intended_use_mos = l_params[:intended_use_mos]
	      @income.contract_amt = l_params[:contract_amt]
	      @income.inc_avg_beg_date = l_params[:inc_avg_beg_date]
	      @income.recal_ind = l_params[:recal_ind]
	      # @notes = params[:notes]
		if @income.valid?
			ls_msg = IncomeService.update_client_income_and_notes(@client.id,@income,params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Income saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					redirect_to start_household_member_registration_wizard_path
				else
					redirect_to unearned_incomes_path(@menu)
				end

			else
				flash[:notice] = ls_msg
				render :edit
			end
		else
			render :edit
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating income details."
		redirect_to_back
	end

	def destroy
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data_and_unearned_income_types_data()
			end
		end

		IncomeService.trigger_events_for_incomes(@income, session[:CLIENT_ID], 435)

		@income.destroy
		flash[:alert] = "Income deleted."

		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			redirect_to start_household_member_registration_wizard_path
		else
			redirect_to unearned_incomes_path(@menu)
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to delete income for client."
		redirect_to_back
	end

	def income_summary

		@income_Collection = @client.incomes
		@income_details_collection =IncomeDetail.get_income_details_for_client(session[:CLIENT_ID])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","income_summary",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to view income summary for client."
		redirect_to_back
	end

	private

	  def params_values
	  	params.require(:income).permit(:incometype,:source,:verified,:frequency,:effective_beg_date,
	  		:effective_end_date,:intended_use_mos,:contract_amt,:inc_avg_beg_date,:recal_ind)
	  end

	  def set_menu
	  	@menu = params[:menu]
	  end

	  def set_id
		 @income = Income.find(params[:id])
	  end

	  def set_client_id
	  	# @income_types = CodetableItem.item_list(36,"Income Type")
	  	@income_types = CodetableItem.where("code_table_id = 36 and id not in (6729,2811,2854,2825,2790,2796,2829)").order("short_description asc")
	  	@client = Client.find(session[:CLIENT_ID])
	  	@menu = "CLIENT"
	  	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","set_client_id",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Failed to find a client."
			redirect_to client_search_path
	  end

	# Manoj 01/27/2016
	  	def set_hoh_data_and_unearned_income_types_data()
	  		set_hoh_data(session[:CLIENT_ID].to_i)
			# unearned income types.
			@income_types = CodetableItem.where("code_table_id = 36 and id not in (6729,2811,2854,2825,2790,2796,2829)").order("short_description asc")
		end


end
