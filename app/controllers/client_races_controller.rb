class ClientRacesController < AttopAncestorController

	before_action :get_client

	def new
		# Manoj 11/24/2015 - called from Household member step
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data()
			end
		end

		if @client.ethnicity?
			@edit_race= true
			@notes = nil # NotesService.get_notes(6150,session[:CLIENT_ID],6472,session[:CLIENT_ID])
		else
		 	@edit_race= false
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientRacesController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when creating."
		redirect_to_back
	 end

	def create
		# Manoj 11/24/2015 - called from Household member step
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data()
			end
		end

		if params[:client][:ethnicity].present? && params[:client][:race_ids].count > 1
			if @client.present?
				# msg = "Race information saved"
				@client.ethnicity = params_values[:ethnicity]
				@client.race_ids = params_values[:race_ids]
				ls_msg = ClientRaceService.create_and_update_client_race_and_notes(@client,params[:notes])
				if ls_msg == "SUCCESS"
					flash[:notice] = "Race information saved."
					if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
						redirect_to start_household_member_registration_wizard_path
					else
						if session[:NAVIGATE_FROM].blank?
							redirect_to show_race_url
						else
							navigate_back_to_called_page()
						end
					end

				else
					flash[:notice] = "Can't create race."
					render :new
				end
			end
		else

			if !params[:client][:ethnicity].present? && (params[:client][:race_ids].count > 1)
				@race_error = "Ethnicity is required."
			elsif params[:client][:ethnicity].present? && !(params[:client][:race_ids].count > 1)
				@race_error = "Race is required."
			else
				#@client.race_ids = params[:client][:race_ids]
				@race_error = "Both ethnicity and race are mandatory, selection is not updated."
			end
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientRacesController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving race."
		redirect_to_back
	end

	def show
		@modified_by = nil
		if @client.present?
			@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6472,session[:CLIENT_ID])
		    if @client.ethnicity?
		  	    @races =  @client.races
		  	    if @client.race_ids.present?
		  	    	@selected_races = CommonUtil.get_comma_seperated_string_for_a_structure(@client.race_ids)
		  	    	client_race_object = ClientRace.where("client_id = ? and race_id = ?",@client.id,@client.race_ids.last).first
		  	    	@modified_by = client_race_object.updated_by
		  	    else
		  	    	@selected_races = ""
		  	    end
		    end
		end
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientRacesController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end



	private

	  def params_values
	  	params.require(:client).permit(:ethnicity, race_ids: [])
	  end

	  def get_client
		if session[:CLIENT_ID].present?
		    cl_id = session[:CLIENT_ID]
		    @client = Client.find(cl_id)
		    # Manoj 02/06/2015
		    @client_races_in_db = ClientRace.get_client_races(cl_id)
		    @client_races_in_db_array = []
		    if @client_races_in_db.present?
		    	@client_races_in_db.each do |each_race|
		    		 @client_races_in_db_array << each_race.race_id
		    	end
		    end

		end
	  end


	  # Manoj 11/24/2015
	  	def set_hoh_data()
	  		li_member_id = params[:household_member_id].to_i
			@household_member = HouseholdMember.find(li_member_id)
			@household = Household.find(@household_member.household_id)
			# @head_of_household_name = HouseholdMember.get_hoh_name(@household.id)
		end
end
