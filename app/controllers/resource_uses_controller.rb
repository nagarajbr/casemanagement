class ResourceUsesController < AttopAncestorController
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
		@resource = Resource.find(@resource_detail.resource_id)
		@client = Client.find(session[:CLIENT_ID])
		@resource_uses = ResourceUse.get_resource_uses_for_resource_detail(params[:resource_detail_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceUsesController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid resource uses."
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
		@resource = Resource.find(@resource_detail.resource_id)
		@resource_use = ResourceUse.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceUsesController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to create a new resource use."
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
		@resource = Resource.find(@resource_detail.resource_id)
		@resource_use = ResourceUse.new(params_values)
		@resource_use.resource_details_id = params[:resource_detail_id]
		if @resource_use.valid?
			ls_msg = ResourceUsesService.save_resource_uses(@resource_use,session[:CLIENT_ID],@resource_detail)
			if ls_msg == "SUCCESS"
				flash[:notice] = "Resource use saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                  	redirect_to household_member_resource_detail_uses_index_path(@client.id,@resource_detail.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
                else
                	redirect_to show_resource_uses_path(@resource_use.id)
                end
			else
				render :new, notice: "Resource use cannot be saved."
			end
		else
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceUsesController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to create a new resource use."
		redirect_to_back
	end

	def show
		@client = Client.find(session[:CLIENT_ID])
		@menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	         set_hoh_data(@client.id)
	        @resource_use = ResourceUse.find(params[:resource_detail_use_id])
			@resource_detail = ResourceDetail.find(@resource_use.resource_details_id)
			@resource = Resource.find(@resource_detail.resource_id)
	      end
	    else
	    	@resource_use = ResourceUse.find(params[:id])
			@resource_detail = ResourceDetail.find(@resource_use.resource_details_id)
			@resource = Resource.find(@resource_detail.resource_id)
	    end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceUsesController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed attempt to view resource use."
		redirect_to_back
	end

	def edit
		@client = Client.find(session[:CLIENT_ID])
		@menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	         set_hoh_data(@client.id)
	        @resource_use = ResourceUse.find(params[:resource_detail_use_id])
			@resource_detail = ResourceDetail.find(@resource_use.resource_details_id)
			@resource = Resource.find(@resource_detail.resource_id)
	      end
	    else
	    	@resource_use = ResourceUse.find(params[:id])
			@resource_detail = ResourceDetail.find(@resource_use.resource_details_id)
			@resource = Resource.find(@resource_detail.resource_id)
	    end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceUsesController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit a resource use."
		redirect_to_back
	end

	def update
		@client = Client.find(session[:CLIENT_ID])
		@menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	         set_hoh_data(@client.id)
	        @resource_use = ResourceUse.find(params[:resource_detail_use_id])
			@resource_detail = ResourceDetail.find(@resource_use.resource_details_id)
			@resource = Resource.find(@resource_detail.resource_id)
	      end
	    else
	    	@resource_use = ResourceUse.find(params[:id])
			@resource_detail = ResourceDetail.find(@resource_use.resource_details_id)
			@resource = Resource.find(@resource_detail.resource_id)
	    end



		@resource_use.usage_code = params_values[:usage_code]
		if @resource_use.valid?
			ls_msg = ResourceUsesService.save_resource_uses(@resource_use,session[:CLIENT_ID],@resource_detail)
			if ls_msg == "SUCCESS"
				flash[:notice] = "Resource use saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                	redirect_to household_member_resource_detail_uses_index_path(@client.id,@resource_detail.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
            	else
            		redirect_to show_resource_uses_path(@resource_use.id)
            	end
			else
				render :edit
			end
		else
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceUsesController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to update a resource use."
		redirect_to_back
	end

	def destroy
		@menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	         set_hoh_data(@client.id)
	        @resource_use = ResourceUse.find(params[:resource_detail_use_id])
			@resource_detail = ResourceDetail.find(@resource_use.resource_details_id)
			@resource = Resource.find(@resource_detail.resource_id)
	      end
	    else
	    	@resource_use = ResourceUse.find(params[:id])
			@resource_detail = ResourceDetail.find(@resource_use.resource_details_id)
			@resource = Resource.find(@resource_detail.resource_id)
	    end
		resource_detail_id = @resource_use.resource_details_id
		@resource_use.destroy
		 flash[:alert] = "Resource use deleted."
		 if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
		 	redirect_to household_member_resource_detail_adjustments_index_path(@client.id,@resource_detail.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
		 else
			redirect_to index_resource_uses_path(resource_detail_id)
		 end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceUsesController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to delete a resource use."
		redirect_to_back
	end

	private

	def params_values
		params.require(:resource_use).permit(:usage_code)
	end

	# def set_hoh_data()
	#       li_member_id = params[:household_member_id].to_i
	#       @household_member = HouseholdMember.find(li_member_id)
	#       @household = Household.find(@household_member.household_id)
	#       @head_of_household_name = HouseholdMember.get_hoh_name(@household.id)
	# end

	def create_session_client
    		@client = Client.find(session[:CLIENT_ID])
	end
end
