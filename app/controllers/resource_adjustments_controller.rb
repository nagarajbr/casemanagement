class ResourceAdjustmentsController < AttopAncestorController
	before_action :create_session_client

	def index
		@menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end
		@resource_detail = ResourceDetail.find(params[:resource_detail_id])
		@resource= Resource.find(@resource_detail.resource_id)
		@client = Client.find(session[:CLIENT_ID])
		@resource_adjustments = ResourceAdjustment.get_resource_adjustment_for_a_detail(params[:resource_detail_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceAdjustmentsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid resource adjustment."
		redirect_to_back
	end

	def new
		@menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	      end
	    end
		@client = Client.find(session[:CLIENT_ID])
		@resource_detail = ResourceDetail.find(params[:resource_detail_id])
		@resource= Resource.find(@resource_detail.resource_id)
		@resource_adjustment = ResourceAdjustment.new

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceAdjustmentsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to create a new resource adjustment."
		redirect_to_back
	end

	def create
		@menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	       set_hoh_data(@client.id)
	      end
	    end

		@resource_detail = ResourceDetail.find(params[:resource_detail_id])
		@resource= Resource.find(@resource_detail.resource_id)
		@resource_adjustment = ResourceAdjustment.new(params_values)
		@resource_adjustment.resource_detail_id = params[:resource_detail_id]
		if @resource_adjustment.valid?
			ls_msg = ResourceAdjustmentService.save_resource_adjust(@resource_adjustment, session[:CLIENT_ID],@resource_detail)
			if ls_msg == "SUCCESS"
				flash[:notice] = "Resource detail adjustment saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                  	redirect_to household_member_resource_detail_adjustments_index_path(@client.id,@resource_detail.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
                else
                	redirect_to show_resource_adjustment_path(@resource_adjustment.id)
                end
			else
				render :new, notice: "Adjustment cannot be saved."
			end
		else
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceAdjustmentsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -Failed to create a new resource adjustment."
		redirect_to_back
	end

	def show
		@client = Client.find(session[:CLIENT_ID])
		@menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	       set_hoh_data(@client.id)
	        @resource_adjustment = ResourceAdjustment.find(params[:resource_detail_adjustment_id])
			@resource_detail = ResourceDetail.find(@resource_adjustment.resource_detail_id)
			@resource= Resource.find(@resource_detail.resource_id)
	      end
	    else
	    	@resource_adjustment = ResourceAdjustment.find(params[:id])
			@resource_detail = ResourceDetail.find(@resource_adjustment.resource_detail_id)
			@resource= Resource.find(@resource_detail.resource_id)
	    end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceAdjustmentsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed attempt to view resource adjustment."
		redirect_to_back
	end

	def edit
		@client = Client.find(session[:CLIENT_ID])
		@menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	       set_hoh_data(@client.id)
	        @resource_adjustment = ResourceAdjustment.find(params[:resource_detail_adjustment_id])
			@resource_detail = ResourceDetail.find(@resource_adjustment.resource_detail_id)
			@resource= Resource.find(@resource_detail.resource_id)
	      end
	    else
	    	@resource_adjustment = ResourceAdjustment.find(params[:id])
			@resource_detail = ResourceDetail.find(@resource_adjustment.resource_detail_id)
			@resource= Resource.find(@resource_detail.resource_id)
	    end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceAdjustmentsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to edit a resource adjustment."
		redirect_to_back
	end

	def update
		@client = Client.find(session[:CLIENT_ID])
		@menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	        @resource_adjustment = ResourceAdjustment.find(params[:resource_detail_adjustment_id])
			@resource_detail = ResourceDetail.find(@resource_adjustment.resource_detail_id)
			@resource= Resource.find(@resource_detail.resource_id)
	      end
	    else
	    	@resource_adjustment = ResourceAdjustment.find(params[:id])
			@resource_detail = ResourceDetail.find(@resource_adjustment.resource_detail_id)
			@resource= Resource.find(@resource_detail.resource_id)
	    end

		@resource_adjustment.reason_code = params_values[:reason_code]
		@resource_adjustment.resource_adj_amt = params_values[:resource_adj_amt]
		@resource_adjustment.receipt_date = params_values[:receipt_date]
		@resource_adjustment.adj_begin_date = params_values[:adj_begin_date]
		@resource_adjustment.adj_end_date = params_values[:adj_end_date]
		@resource_adjustment.adj_num_of_months = params_values[:adj_num_of_months]
		if @resource_adjustment.valid?
			ls_msg = ResourceAdjustmentService.save_resource_adjust(@resource_adjustment, session[:CLIENT_ID],@resource_detail)
			if ls_msg == "SUCCESS"
				flash[:notice] = "Resource detail adjustment saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                	redirect_to household_member_resource_detail_adjustments_index_path(@client.id,@resource_detail.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
            	else
            		redirect_to show_resource_adjustment_path(@resource_adjustment.id)
            	end

			else
				render :edit, notice: "Adjustment cannot be saved."
			end
		else
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceAdjustmentsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to update a resource adjustment."
		redirect_to_back
	end

	def destroy
		@menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	        set_hoh_data(@client.id)
	        @resource_adjustment = ResourceAdjustment.find(params[:resource_detail_adjustment_id])
			@resource_detail = ResourceDetail.find(@resource_adjustment.resource_detail_id)
			@resource= Resource.find(@resource_detail.resource_id)
	      end
	    else
	    	@resource_adjustment = ResourceAdjustment.find(params[:id])
			@resource_detail = ResourceDetail.find(@resource_adjustment.resource_detail_id)
			@resource= Resource.find(@resource_detail.resource_id)
	    end
		resource_detail_id = @resource_adjustment.resource_detail_id
		@resource_adjustment.destroy
		flash[:alert] = "Adjustment deleted."
		    if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			    redirect_to household_member_resource_detail_adjustments_index_path(@client.id,@resource_detail.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
			else
				redirect_to index_resource_adjustment_path(resource_detail_id)
			end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceAdjustmentsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to delete a resource adjustment."
		redirect_to_back
	end

	private

	  def params_values
	  	params.require(:resource_adjustment).permit(:reason_code,:resource_adj_amt,:receipt_date,:adj_begin_date,:adj_end_date,:adj_num_of_months)
	  end

	   # Manoj 11/24/2015
	    # def set_hoh_data()
	    #   li_member_id = params[:household_member_id].to_i
	    #   @household_member = HouseholdMember.find(li_member_id)
	    #   @household = Household.find(@household_member.household_id)
	    #   @head_of_household_name = HouseholdMember.get_hoh_name(@household.id)
	    # end

	    def create_session_client
    		@client = Client.find(session[:CLIENT_ID])
	    end

end
