class ResourcesController < AttopAncestorController

	before_action :create_session_client
	# before_action :set_id, only: [:show,:edit,:update,:destroy]

    def index
    	if @client.present?
    		l_records_per_page = SystemParam.get_pagination_records_per_page
		   @resources = @client.shared_resources.order("date_assert_acquired  desc").page(params[:page]).per(l_records_per_page)
    		# session[:NAVIGATED_FROM] = resources_url
    	end
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourcesController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back

    end

	def new
		@resource = Resource.new
		# Manoj 11/24/2015 - called from Household member step
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data(@client.id)
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourcesController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when creating a new resource details."
		redirect_to_back
	end

	def create
		l_params = params_values
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data(@client.id)
			end
		end

		@resource = Resource.new(l_params)
		if @resource.valid?
				ls_msg =ResourceService.save_client_resource(@client.id,l_params,params[:notes])
				if ls_msg == "SUCCESS"
					flash[:notice] = "Resource information saved."
					if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
						redirect_to start_household_member_registration_wizard_path
					else
						redirect_to resources_path
					end

				else
					flash[:notice] = ls_msg
					render :new
				end
		else
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourcesController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving resource details."
		redirect_to_back
	end

	def show
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				@resource =  Resource.find(params[:resource_id].to_i)
				set_hoh_data(@client.id)
				@client_resources = ClientResource.clients_sharing_resource(params[:resource_id],@client.id)
			end
		else
			@resource = Resource.find(params[:id])
			@client_resources = ClientResource.clients_sharing_resource(params[:id],session[:CLIENT_ID])
		end

		# self.get_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6486,@resource.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourcesController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid resource record."
		redirect_to_back
	end

	def edit
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				@resource =  Resource.find(params[:resource_id].to_i)
				set_hoh_data(@client.id)
				@client_resources = ClientResource.clients_sharing_resource(params[:resource_id],@client.id)
			end
		else
			@resource = Resource.find(params[:id])
			@client_resources = ClientResource.clients_sharing_resource(params[:id],session[:CLIENT_ID])
		end
		@notes = nil # NotesService.get_notes(6150,session[:CLIENT_ID],6486,@resource.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourcesController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing a resource details."
		redirect_to_back
	end

	def update
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				@resource =  Resource.find(params[:resource_id].to_i)
				set_hoh_data(@client.id)
				@client_resources = ClientResource.clients_sharing_resource(params[:resource_id],@client.id)
			end
		else
			@resource = Resource.find(params[:id])
			@client_resources = ClientResource.clients_sharing_resource(params[:id],session[:CLIENT_ID])
		end
		@resource.resource_type = params_values[:resource_type]
		@resource.account_number = params_values[:account_number]
		@resource.description = params_values[:description]
		@resource.date_assert_acquired = params_values[:date_assert_acquired]
		@resource.date_assert_disposed = params_values[:date_assert_disposed]
		@resource.number_of_owners = params_values[:number_of_owners]
		@resource.net_value = params_values[:net_value]
		@resource.date_value_determined = params_values[:date_value_determined]
		@resource.verified = params_values[:verified]
		@resource.use_code = params_values[:use_code]
		@resource.year = params_values[:year]
		@resource.make = params_values[:make]
		@resource.model = params_values[:model]
		@resource.license_number = params_values[:license_number]
		if @resource.valid?
				ls_msg =ResourceService.update_client_resource(@client.id,@resource,params[:notes])
				if ls_msg == "SUCCESS"
					flash[:notice] =  "Resource information saved."
					if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
						redirect_to start_household_member_registration_wizard_path
					else
						redirect_to resource_path
					end
				else
					flash[:notice] = ls_msg
					render :edit
				end
		else
			    render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourcesController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating resource details."
		redirect_to_back
	end

	def destroy
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				@resource =  Resource.find(params[:resource_id].to_i)
				set_hoh_data(@client.id)
				@client_resources = ClientResource.clients_sharing_resource(params[:resource_id],@client.id)
			end
		else
			@resource = Resource.find(params[:id])
			@client_resources = ClientResource.clients_sharing_resource(params[:id],session[:CLIENT_ID])
		end
		ls_msg =ResourceService.destroy_resource(@resource,@client.id,params[:notes])
		if ls_msg == "SUCCESS"
			flash[:alert] = "Resource information deleted."
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				redirect_to start_household_member_registration_wizard_path
			else
				redirect_to resource_path
			end
		else
			flash[:notice] = ls_msg
			render :show
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourcesController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting a resource detail."
		redirect_to_back
	end

	def resource_summary
		@client = Client.find(session[:CLIENT_ID])
		@resource_collection = Resource.get_resources_for_client(@client.id)
		@resource_details_collection =ResourceDetail.get_resource_details_for_client(session[:CLIENT_ID])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ResourcesController","resource_summary",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed attempt to view resource details."
		redirect_to_back
	end

	private

	  def params_values
	  	params.require(:resource).permit(:resource_type,:account_number,:description,:date_assert_acquired,
	  		:date_assert_disposed,:number_of_owners,:net_value,:date_value_determined,:verified,:use_code,:year,:make,:model,:license_number)
	  end

	  # def set_id
		 # @resource = Resource.find(params[:id])
	  # end

	  def create_session_client
    		@client = Client.find(session[:CLIENT_ID])
	  end

	  # Manoj 11/24/2015
	 #  	def set_hoh_data()
	 #  		li_member_id = params[:household_member_id].to_i
		# 	@household_member = HouseholdMember.find(li_member_id)
		# 	@household = Household.find(@household_member.household_id)
		# 	@head_of_household_name = HouseholdMember.get_hoh_name(@household.id)
		# end
end
