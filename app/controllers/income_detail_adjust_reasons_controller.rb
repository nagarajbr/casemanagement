class IncomeDetailAdjustReasonsController < AttopAncestorController
	before_action :create_session_client
	before_action :set_menu
	before_action :set_id, only: [:show,:edit,:update,:destroy]
	before_action :income_detail_id, only: [:index,:new,:create,:show,:edit,:update,:destroy]

	def index

		@income = Income.find(@income_detail.income_id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@adjust_reasons = @income_detail.income_detail_adjust_reasons.page(params[:page]).per(l_records_per_page)

		if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailAdjustReasonsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid income check detail record."
		redirect_to_back
	end

	def new
		@income = Income.find(@income_detail.income_id)
		@adjust_reason = @income_detail.income_detail_adjust_reasons.new
		if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailAdjustReasonsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid income check detail record."
		redirect_to_back
	end

	def create
		if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end

		@income = Income.find(@income_detail.income_id)
		@adjust_reason = @income_detail.income_detail_adjust_reasons.new(params_values)
		if @adjust_reason.valid?
			ls_msg = IncomeDetailAdjustReason.save_income_detail_adjust_reason(@adjust_reason,@income_detail,session[:CLIENT_ID])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Adjustment saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                	redirect_to household_member_unearned_income_detail_adjust_reasons_index_path(@client.id,@income_detail.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
				else
					redirect_to unearned_income_detail_income_detail_adjust_reasons_path(@menu,@income_detail.id)
				end
			else
				flash[:alert] = ls_msg
				render :new
			end
		else
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailAdjustReasonsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving income adjustment details record."
		redirect_to_back
	end

	def show

		if params[:menu].present?
		      @menu = params[:menu]
		      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
		        set_hoh_data(@client.id)
		      end
		end
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailAdjustReasonsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid income detail adjustment record."
		redirect_to_back
	end

	def edit

		@income = Income.find(@income_detail.income_id)
		@adjust_reasons = @income_detail.income_detail_adjust_reasons
		if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailAdjustReasonsController","edit",err,current_user.uid)
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
		@income = Income.find(@income_detail.income_id)
		l_params = params_values
		@adjust_reason.adjusted_amount = l_params[:adjusted_amount]
		@adjust_reason.adjusted_reason = l_params[:adjusted_reason]
		if @adjust_reason.valid?
			ls_msg = IncomeDetailAdjustReason.save_income_detail_adjust_reason(@adjust_reason,@income_detail,session[:CLIENT_ID])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Adjustment saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                	redirect_to household_member_unearned_income_detail_adjust_reasons_index_path(@client.id,@income_detail.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
				else
					redirect_to unearned_income_detail_income_detail_adjust_reasons_path(@menu,@income_detail.id)
				end
			else
				flash[:alert] = ls_msg
				render :edit
			end
		else
			@show_delete = true
		   render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailAdjustReasonsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating income detail adjustment record."
		redirect_to_back
	end

	def destroy
		if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end

		@adjust_reason.destroy
		populate_income_detail
		if @income_detail.save
			flash[:alert] = "Adjustment deleted."
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                redirect_to household_member_unearned_income_detail_adjust_reasons_index_path(@client.id,@income_detail.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
			else
		   		redirect_to unearned_income_detail_income_detail_adjust_reasons_path(@menu,@income_detail.id)
			end
		else
		  @adjust_reason.destroy#roll back needed for destroy
		  render :new, alert: "Adjustment cannot be deleted."
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailAdjustReasonsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting income detail adjustment record."
		redirect_to_back
	end

	private

	  def params_values
	  	params.require(:income_detail_adjust_reason).permit(:adjusted_amount,:adjusted_reason)
	  end

	  def income_detail_id
		 @income_detail = IncomeDetail.find(params[:income_detail_id])
		 @income = Income.find(@income_detail.income_id)
	  end

	  def set_id
	  	@adjust_reason = IncomeDetailAdjustReason.find(params[:id])
	  end

	  def populate_income_detail
	  	# When ever CRUD operations are performed across adjustments, income_detail (parent)
	  	#record needs to be updated this method is used to do the same. -Kiran
	  	adjusted_total = IncomeDetailAdjustReason.get_adjusted_total(@income_detail)
	  	@income_detail.adjusted_total = adjusted_total
		@income_detail.net_amt = (@income_detail.gross_amt - adjusted_total)
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