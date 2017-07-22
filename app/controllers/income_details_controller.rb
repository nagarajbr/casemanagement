class IncomeDetailsController < AttopAncestorController
	before_action :create_session_client
	before_action :set_menu
	before_action :set_id, only: [:show,:edit,:update,:destroy]
	before_action :set_income_id, only: [:index,:new,:create,:show,:edit,:update,:destroy]

	def index
		if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end

		l_records_per_page = SystemParam.get_pagination_records_per_page
		@income_details = @income.income_details.page(params[:page]).per(l_records_per_page)

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid income master record."
		redirect_to_back
	end

	def new

		@income_detail = @income.income_details.new
		@income_detail.cnt_for_convert_ind = 'Y'
		if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end
		# @income_detail.check_type = 4385
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid income master record."
		redirect_to_back
	end

	def create
		if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end

		@income_detail = @income.income_details.new(params_values)
		@income_detail.net_amt = params[:income_detail][:gross_amt].to_i - params[:income_detail][:adjusted_total].to_i

		if  @income_detail.gross_amt.blank?
			#if the gross amount is left blank it will be defaulted to 0.0 -Kiran
			@income_detail.gross_amt = 0
			@income_detail.net_amt = 0
		end
		#defaulting adjusted_total and net_amt to 0.0 -kiran
		@income_detail.adjusted_total = 0
		if @income_detail.valid?
			ls_msg = IncomeDetailService.create_client_income_detail_and_notes(@income_detail,session[:CLIENT_ID],params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Income details saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                	redirect_to household_member_unearned_income_detail_index_path(@client.id,@income.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
				else
					redirect_to unearned_income_income_details_path(@menu,@income.id)
				end
			else

				flash[:notice] = ls_msg
				render :new
			end
		else
			render :new
		end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailsController","create",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Error when saving income check details."
	 	redirect_to_back
	end

	def show

			@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6503,@income_detail.id)
			l_records_per_page = SystemParam.get_pagination_records_per_page
			@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
			if params[:menu].present?
		      @menu = params[:menu]
		      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
		        set_hoh_data(@client.id)
		      end
		    end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid income check detail record."
		redirect_to_back
	end

	def edit

		@notes = nil # NotesService.get_notes(6150,session[:CLIENT_ID],6503,@income_detail.id)
		if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit invalid income check detail record."
		redirect_to_back
	end

	def update
		if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end

		adjusted_total = IncomeDetailAdjustReason.get_adjusted_total(@income_detail)
		@income_detail.adjusted_total = adjusted_total
		@income_detail.net_amt = params[:income_detail][:gross_amt].to_i - adjusted_total

		@income_detail.date_received = params_values[:date_received]
		@income_detail.check_type = params_values[:check_type]
		@income_detail.gross_amt = params_values[:gross_amt]
		@income_detail.cnt_for_convert_ind = params_values[:cnt_for_convert_ind]
		@income_detail.net_amt = params_values[:net_amt]
		@income_detail.adjusted_total = params_values[:adjusted_total]
		@notes = params[:notes]

		if @income_detail.valid?
			ls_msg = IncomeDetailService.update_client_income_detail_and_notes(@income_detail,session[:CLIENT_ID],params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Income details saved."
				if session[:NAVIGATE_FROM].present?

					@incomes = IncomeDetail.salary_income_type_income_record(@client.id)
					@ui_incomes = IncomeDetail.latest_client_income_detail_records(@client.id,2847)
					@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
					session[:NAVIGATE_FROM] = nil
					render '/data_validation_static/wage_ui_match'
					# redirect_to session[:NAVIGATE_FROM]
				else
					if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                		redirect_to household_member_unearned_income_detail_index_path(@client.id,@income.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
                	else
                		redirect_to unearned_income_income_details_path(@menu,@income.id)
                	end

				end


			else

				flash[:notice] = ls_msg
				render :edit
			end
		else
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating income check detail."
		redirect_to_back
	end

	def destroy
		if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end

		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6503,@income_detail.id)
		ls_msg = IncomeDetailService.delete_client_income_detail_and_notes(@income_detail,session[:CLIENT_ID],@notes)
		if ls_msg == "SUCCESS"
			flash[:notice] = "Income detail deleted."
			 if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			 	redirect_to household_member_unearned_income_detail_index_path(@client.id,@income.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
			 else
				redirect_to unearned_income_income_details_path(@menu,@income.id)
			 end
		else
			flash[:notice] = ls_msg
			render :show
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting income check detail."
		redirect_to_back

	end

	private

	  def params_values
	  	params.require(:income_detail).permit(:date_received,:check_type,:gross_amt,:cnt_for_convert_ind, :net_amt, :adjusted_total)
	  end

	  def set_income_id
		 @income = Income.find(params[:income_id])
	  end

	  def set_id
	  	@income_detail = IncomeDetail.find(params[:id])
	  end

	   def set_menu
	  	@menu = params[:menu]
	  end

	   # Manoj 11/24/2015
	    # def set_hoh_data()
	    #   li_member_id = params[:household_member_id].to_i
	    #   @household_member = HouseholdMember.find(li_member_id)
	    #   @household = Household.find(@household_member.household_id)
	    # end

	    def create_session_client
    		@client = Client.find(session[:CLIENT_ID])
	    end
end
