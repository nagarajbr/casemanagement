class ResourceDetailsController < AttopAncestorController
	# before_action :set_id, only: [:show,:edit,:update,:destroy]
	before_action :create_session_client
	before_action :set_resource_id, only: [:index,:new,:create,:show,:edit,:update,:destroy]
	def index
		# Manoj 11/24/2015 - called from Household member step
	    @menu = nil
	    if params[:menu].present?
	      @menu = params[:menu]
	      if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	       set_hoh_data(@client.id)
	      end
	    end
		# @client = Client.find(session[:CLIENT_ID])
		@resource_details = @resource.resource_details
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceDetailsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid resource record."
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

		# @client = Client.find(session[:CLIENT_ID])
		@resource_detail = @resource.resource_details.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceDetailsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when creating resource detail record."
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
		@resource_detail = @resource.resource_details.new(params_values)

		if @resource_detail.res_ins_face_value.blank?
			#if the res_ins_face_value is left blank it will be defaulted to 0.0 -Kiran
			@resource_detail.res_ins_face_value = 0.00
		end
		if @resource_detail.amount_owned_on_resource.blank?
			#if the amount_owned_on_resource is left blank it will be defaulted to 0.0 -Kiran
			@resource_detail.amount_owned_on_resource = 0.00
		end
		if @resource_detail.valid?
				ls_msg =ResourceDetailService.create_client_resource_detail_and_notes(@resource_detail,session[:CLIENT_ID],params[:notes])
				if ls_msg == "SUCCESS"
					flash[:notice] = "Resource detail saved."
					 if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                  		redirect_to household_member_resource_detail_index_path(@client.id,@resource.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
                	else
						redirect_to resource_resource_details_path(@resource)
					end
				else
					flash[:alert] = ls_msg
					render :new
				end
		else
			    render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceDetailsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving resource details."
		redirect_to_back
	end

	def show
	  @menu = nil
      if params[:menu].present?
        @menu = params[:menu]
        if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
         set_hoh_data(@client.id)
          @resource_detail = ResourceDetail.find(params[:resource_detail_id])
        end
      else
       	@resource_detail = ResourceDetail.find(params[:id])
      end

		# @client = Client.find(session[:CLIENT_ID])
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6511,@resource_detail.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceDetailsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid resource detail record."
		redirect_to_back
	end

	def edit
		@menu = nil
	    if params[:menu].present?
	        @menu = params[:menu]
	        if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	         set_hoh_data(@client.id)
	          @resource_detail = ResourceDetail.find(params[:resource_detail_id])
	        end
	    else
	       	@resource_detail = ResourceDetail.find(params[:id])
	    end
		# @client = Client.find(session[:CLIENT_ID])
		@notes = nil #NotesService.get_notes(6150,session[:CLIENT_ID],6511,@resource_detail.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceDetailsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Error when editing resource details."
		redirect_to_back
	end

	def update
		@menu = nil
	    if params[:menu].present?
	        @menu = params[:menu]
	        if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	         set_hoh_data(@client.id)
	          @resource_detail = ResourceDetail.find(params[:resource_detail_id])
	        end
	    else
	       	@resource_detail = ResourceDetail.find(params[:id])
	    end

		@resource_detail.assign_attributes(params_values)


		if @resource_detail.valid?
				ls_msg =ResourceDetailService.update_resource_detail_and_notes(@resource_detail,session[:CLIENT_ID],params[:notes])
				if ls_msg == "SUCCESS"
					flash[:notice] = "Resource detail saved."
					if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
                		redirect_to household_member_resource_detail_index_path(@client.id,@resource.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
            		else
						redirect_to resource_resource_details_path(@resource)
					end
				else
					flash[:alert] = ls_msg
					render :edit
				end
		else
			    render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceDetailsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating resource detail record."
		redirect_to_back
	end

	def destroy
		@menu = nil
	    if params[:menu].present?
	        @menu = params[:menu]
	        if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
	         set_hoh_data(@client.id)
	          @resource_detail = ResourceDetail.find(params[:resource_detail_id])
	        end
	    else
	       	@resource_detail = ResourceDetail.find(params[:id])
	    end

		ls_msg =ResourceDetailService.delete_client_resource_detail_and_notes(@resource_detail,session[:CLIENT_ID],params[:notes])
		if ls_msg == "SUCCESS"
			flash[:alert] = "Resource detail deleted."
			   if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			        redirect_to household_member_resource_detail_index_path(@client.id,@resource.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
			   else
					redirect_to resource_resource_details_path(@resource)
			   end

		else
			flash[:alert] = ls_msg
			render :show
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourceDetailsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting resource details."
		redirect_to_back
	end

	private

		def params_values
	  		params.require(:resource_detail).permit(:resource_valued_date,:resource_value,:first_of_month_value,
	  		:res_ins_face_value,:amount_owned_on_resource,:amount_owned_as_of_date,:res_value_basis)
		end

		def set_resource_id
		 	@resource = Resource.find(params[:resource_id])
		end

	  	# def set_id
	  	# 	@resource_detail = ResourceDetail.find(params[:id])
	  	# end

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
