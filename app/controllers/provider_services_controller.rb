class ProviderServicesController < AttopAncestorController

#provider_service start
	def provider_service_index
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerservices = @provider.provider_services.order("start_date ASC")
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_index",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid provider"
	      redirect_to_back
	end

	def provider_service_new
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerservice = ProviderService.new
		services_dropdown()
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_new",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error when creating new provider service"
	      redirect_to_back
	end

	def provider_service_create
		services_dropdown()
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerservice = ProviderService.new(provider_service_params_values)
		@providerservice.provider_id = @provider.id
		 if @providerservice.valid?
			ls_msg = ProviderSerService.create_provider_service(@providerservice,params[:notes])
			if ls_msg == "SUCCESS"
				redirect_to provider_services_path, notice: "Provider service details saved"
			else
				flash[:notice] = ls_msg
				render :provider_service_new
			end
		else
			render :provider_service_new
		end
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_create",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error when creating provider service"
	      redirect_to_back
	end

	def provider_service_edit
		services_dropdown()
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerservice = ProviderService.find(params[:id])
		@notes = NotesService.get_notes(6151,@provider.id,6521,@providerservice.id)
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_edit",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid service"
	      redirect_to_back
	end

	def provider_service_update
		services_dropdown()
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerservice = ProviderService.find(params[:id])
		l_params = provider_service_params_values
		@providerservice.service_type = l_params[:service_type]
		@providerservice.service_units = l_params[:service_units]
		@providerservice.start_date = l_params[:start_date]
		@providerservice.end_date = l_params[:end_date]

		if @providerservice.valid?
			message = ProviderService.can_provider_service_be_closed?(@providerservice.id,@providerservice.start_date,@providerservice.end_date)
			if message != "CLOSE"
				# logger.debug("message -cannot close")
				flash.now[:alert] = message
				render :provider_service_edit
			else
				logger.debug("message -can close")
				@providerservice.service_type = provider_service_params_values[:service_type]
				@providerservice.service_units = provider_service_params_values[:service_units]
				@providerservice.start_date = provider_service_params_values[:start_date]
				@providerservice.end_date = provider_service_params_values[:end_date]
				if @providerservice.valid?
					ls_msg = ProviderSerService.update_provider_service(@providerservice,params[:notes])
					if ls_msg == "SUCCESS"
						flash[:notice] = "Provider service details saved"
						redirect_to show_provider_service_path
					else
						flash[:notice] = ls_msg
						render :provider_service_edit
					end
				else
					render :provider_service_edit
				end
			end
		else
			logger.debug("@providerservice.valid = false")
			 render :provider_service_edit
		end
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_update",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error when updating provider service"
	      redirect_to_back
	end

	def provider_service_show
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerservice = ProviderService.find(params[:id])
		@notes = NotesService.get_notes(6151,@provider.id,6521,@providerservice.id)
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_show",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid service"
	      redirect_to_back
	end
#provider_service end


#provider_service_area start
	def provider_service_area_index
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerservice = ProviderService.find(params[:service_id])
		@provider_service_areas_collection = ProviderServiceArea.get_service_areas_for_provider_service_id(params[:service_id].to_i).order("local_office_id asc")
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_area_index",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid service area"
	      redirect_to_back
	end

	def provider_service_area_new
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerservice = ProviderService.find(params[:service_id])
		@provider_service_area = ProviderServiceArea.new
		selected_local_offices = ProviderServiceArea.get_local_offices_already_used(params[:service_id])
		@available_local_offices =  CodetableItem.items_to_exclude(2,selected_local_offices,"Local Offices")
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_area_new",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid service area"
	      redirect_to_back
	end

	def provider_service_area_create
		@provider = Provider.find(session[:PROVIDER_ID])
		@providerservice = ProviderService.find(params[:service_id])
		@provider_service_area = ProviderServiceArea.new(provider_service_areas_params_values)
		@provider_service_area.provider_service_id = @providerservice.id
		if @provider_service_area.save
			redirect_to provider_service_areas_path, notice: "Provider service area created"
		else
			selected_local_offices = ProviderServiceArea.get_local_offices_already_used(params[:service_id])
			@available_local_offices =  CodetableItem.items_to_exclude(2,selected_local_offices,"Local Offices")
			render :provider_service_area_new
		end
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_area_create",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error when creating service area"
	      redirect_to_back
	end



	def provider_service_area_destroy
		@provider_service_area = ProviderServiceArea.find(params[:id])
		provider_service = ProviderService.find(@provider_service_area.provider_service_id)
		this_provider_area_found_in_approved_agreement = ProviderAgreementArea.find_if_this_area_in_approved_agreement(provider_service.provider_id,@provider_service_area.provider_service_id,@provider_service_area.local_office_id )
		if this_provider_area_found_in_approved_agreement == false
			@provider_service_area.destroy
			flash[:alert] = "Provider Service Area Deleted Successfully"
			redirect_to provider_service_areas_path(@provider_service_area.provider_service_id)

		else
			flash[:alert] = "Delete Operation Not allowed,because this Provider Service Area is associated with Approved Provider Agreement"
			redirect_to provider_service_areas_path(@provider_service_area.provider_service_id)
		end

		# rescue => err
	 #      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_area_destroy",err,current_user.uid)
	 #      flash[:alert] = "Error ID: #{error_object.id} - Error when deleting service area"
	 #      redirect_to_back
	end

#provider_service_area end

#provider_service_area_availability start
	def provider_service_area_availability_index
		@provider = Provider.find(session[:PROVIDER_ID])
		@provider_service_area = ProviderServiceArea.find(params[:service_area_id])
		@provider_service = ProviderService.find(@provider_service_area.provider_service_id)
		@provider_service_area_availability_collection = ProviderServiceAreaAvailability.where("provider_service_area_id = ?",params[:service_area_id]).order("day_of_the_week ASC")
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_area_availability_index",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid service availability"
	      redirect_to_back
	end

	def provider_service_area_availability_new

		@provider = Provider.find(session[:PROVIDER_ID])
		@provider_service_area = ProviderServiceArea.find(params[:service_area_id])
		@provider_service = ProviderService.find(@provider_service_area.provider_service_id)
		@provider_service_area_availability_collection = ProviderServiceAreaAvailability.where("provider_service_area_id = ?",params[:service_area_id]).order(" day_of_the_week ASC")
		@days_dropdown =  CodetableItem.item_list_order_by_id(153,"Week days")
        day = []
        @provider_service_area_availability_collection.each do |d|
            day << d.day_of_the_week
        end
        @day = @days_dropdown.reject { |u| day.include?(u.id) }
        filtered_dropdown = []
        @day.each do |d|
            filtered_dropdown << d.id
        end
        @blank_drop_down = filtered_dropdown == [6143, 6144, 6145, 6146, 6147] || filtered_dropdown == [6142, 6143, 6144, 6145, 6146, 6147, 6148]
        @blank_drop_down ||= filtered_dropdown == [6142, 6143, 6144, 6145, 6146, 6147] || filtered_dropdown == [6143, 6144, 6145, 6146, 6147, 6148]
        @provider_service_area_availability = ProviderServiceAreaAvailability.new
	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_area_availability_new",err,current_user.uid)
	     	flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid service availability"
	     	redirect_to_back
	end

	def provider_service_area_availability_create
		@provider = Provider.find(session[:PROVIDER_ID])
		@provider_service_area = ProviderServiceArea.find(params[:service_area_id])
		@provider_service = ProviderService.find(@provider_service_area.provider_service_id)
		l_params = provider_service_areas_availability_params_values
		l_start_time = l_params["start_time(5i)"]
		l_end_time = l_params["end_time(5i)"]

        if  l_params[:day_of_the_week].blank?
            li_day_code = [6143,6144,6145,6146,6147]
            li = 0
			5.times do
				@provider_service_area_availability = ProviderServiceAreaAvailability.new
				@provider_service_area_availability.start_time = l_start_time
				@provider_service_area_availability.end_time = l_end_time
				@provider_service_area_availability.day_of_the_week = li_day_code[li]
				@provider_service_area_availability.provider_service_area_id = params[:service_area_id]
				@provider_service_area_availability.save
				li = li + 1 #increment day by code by 1
			end
		else

			@provider_service_area_availability = ProviderServiceAreaAvailability.new
			@provider_service_area_availability.start_time = l_start_time
			@provider_service_area_availability.end_time = l_end_time
			@provider_service_area_availability.day_of_the_week = l_params[:day_of_the_week]
			@provider_service_area_availability.provider_service_area_id = params[:service_area_id]
			@provider_service_area_availability.save
		end


		#if @provider_service_area_availability.save

			if params[:save_and_add].present?
     		   redirect_to new_provider_service_area_availability_path, notice: "Service area availability information saved"
     		end

     		if params[:save_and_exit].present?
     		   redirect_to provider_service_areas_availability_path, notice: "Service area availability information saved"
     		end

		#else
		 	#render :provider_service_area_availability_new
		#end
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_area_availability_create",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error when creating service availability"
	      redirect_to_back
	end
	def provider_service_area_availability_edit
		@provider = Provider.find(session[:PROVIDER_ID])
		@provider_service_area_availability = ProviderServiceAreaAvailability.find(params[:id])
		@provider_service_area = ProviderServiceArea.find(@provider_service_area_availability.provider_service_area_id)
		@provider_service = ProviderService.find(@provider_service_area.provider_service_id)
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_area_availability_edit",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid service availability"
	      redirect_to_back
	end

	def provider_service_area_availability_update
		@provider = Provider.find(session[:PROVIDER_ID])
		@provider_service_area_availability = ProviderServiceAreaAvailability.find(params[:id])
		@provider_service_area = ProviderServiceArea.find(@provider_service_area_availability.provider_service_area_id)
		@provider_service = ProviderService.find(@provider_service_area.provider_service_id)
		l_params = provider_service_areas_availability_params_values
		l_start_time = l_params["start_time(5i)"]
		l_end_time = l_params["end_time(5i)"]
		@provider_service_area_availability.start_time = l_start_time
		@provider_service_area_availability.end_time = l_end_time
		@provider_service_area_availability.day_of_the_week = l_params[:day_of_the_week]
		if @provider_service_area_availability.save
			redirect_to provider_service_areas_availability_path(@provider_service_area.id), notice: "Service area availability saved"
		else
			render :provider_service_area_availability_edit
		end
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_area_availability_update",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error when updating service availability"
	      redirect_to_back
	end

	def provider_service_area_availability_show
		@provider = Provider.find(session[:PROVIDER_ID])
		@provider_service_area_availability = ProviderServiceAreaAvailability.find(params[:id])
		@provider_service_area = ProviderServiceArea.find(@provider_service_area_availability.provider_service_area_id)
		@provider_service = ProviderService.find(@provider_service_area.provider_service_id)
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_area_availability_show",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid service availability"
	      redirect_to_back
	end


	def provider_service_area_availability_destroy

		@provider = Provider.find(session[:PROVIDER_ID])
		@provider_service_area_availability = ProviderServiceAreaAvailability.find(params[:id])
		@provider_service_area = ProviderServiceArea.find(@provider_service_area_availability.provider_service_area_id)
		@provider_service = ProviderService.find(@provider_service_area.provider_service_id)
		@provider_service_area_availability.destroy
		flash[:alert] = "Selected Hours of Operation Deleted Successfully"
		redirect_to provider_service_areas_availability_path(@provider_service_area.id)
	rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderServicesController","provider_service_area_destroy",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Error when deleting service area"
	      redirect_to_back
	end





#provider_service_area_availability end


private

	  def provider_service_params_values
	  	params.require(:provider_service).permit(:service_type,:service_units,:start_date,:end_date)
	  end

	  def provider_service_areas_params_values
	  	params.require(:provider_service_area).permit(:local_office_id)
	  end

	  def provider_service_areas_availability_params_values
	  	params.require(:provider_service_area_availability).permit(:day_of_the_week,:start_time,:end_time)
	  end

	  def services_dropdown()
	  	supportive_services_collection = CodetableItem.item_list(168,"Supportive service")
	  	services_collection = CodetableItem.item_list(182,"services")
	  	@services_drop_down = supportive_services_collection + services_collection


	  end

end
