 class ClientsController < ApplicationController
 	# Author : Manojkumar PAtil
	# Date : 08/04/2014
	# Description : CRUD for Client Model
	#test svn comments.

	before_action :format_ssn

	def show
		AuditModule.set_current_user=(current_user)
		session[:CLIENT_ASSESSMENT_ID] = nil
		if session[:CLIENT_ID].present?
			 # Client ID will be present in the session
			 li_client_id = session[:CLIENT_ID]
			# Description : If record is found in DB -then show & Edit button
			l_count = Client.where("id=?",li_client_id).count
			if l_count > 0
				@client = Client.find(li_client_id)
			end
		end
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6471,session[:CLIENT_ID])
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end


	def new
		AuditModule.set_current_user=(current_user)
		# create an empty record and navigate to new.html
		@client = Client.new
		# Manoj 11/6/2014 - pre populate client data if it is available in session.
		session[:CLIENT_ID] = nil
		if session[:NEW_CLIENT_SSN].present?
    	 	@client.ssn =  session[:NEW_CLIENT_SSN]
    	end
	   	if session[:NEW_CLIENT_LAST_NAME].present?
    	 	@client.last_name =  session[:NEW_CLIENT_LAST_NAME]
    	end

    	if session[:NEW_CLIENT_FIRST_NAME].present?
    	 	@client.first_name =  session[:NEW_CLIENT_FIRST_NAME]
    	end

    	if session[:NEW_CLIENT_DOB].present?
    	 	@client.dob =  session[:NEW_CLIENT_DOB]
    	end

    	if session[:NEW_CLIENT_GENDER].present?
    	 	@client.gender =  session[:NEW_CLIENT_GENDER]
    	end


    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when searching for new client."
		redirect_to_back

	end

	def create
		AuditModule.set_current_user=(current_user)
		# Save the New record to Database - INSERT
		@client = Client.new(client_params)
		@client.sves_status = 'S'
		if @client.valid?
			return_object = ClientDemographicsService.create_client(@client,params[:notes])
			if return_object.class.name == "String"
				# error
				flash[:alert] = return_object
				render :new
			else
				# success
				session[:CLIENT_ID] = return_object.id
				session[:APPLICATION_ID] = nil
				session[:PROGRAM_UNIT_ID] = nil
				reset_pre_populate_session_variables()
				flash[:notice] = "Client saved"
				redirect_to show_client_path
			end
		else
			render :new
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when creating client."
		redirect_to_back
	end

	def edit
		AuditModule.set_current_user=(current_user)
		# find and show the record to be modified in edit.html
    	li_client_id = session[:CLIENT_ID]
  		@client = Client.find(li_client_id)
  		# self.get_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
  		@notes = nil #NotesService.get_notes(6150,session[:CLIENT_ID],6471,session[:CLIENT_ID])
  	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
 	 end


	def update
		AuditModule.set_current_user=(current_user)
		# Update the modified record from edit.html
	    li_client_id = session[:CLIENT_ID]
	  	@client = Client.find(li_client_id)

	  	@notes = params[:notes]
	  	l_params = client_update_params
	  	unless l_params[:identification_type].to_i == 4599
               l_params[:other_identification_document] = nil
        end

	  	if (strip_spaces_and_downcase(@client.first_name) != strip_spaces_and_downcase(l_params[:first_name]) ||
	  		 strip_spaces_and_downcase(@client.last_name) != strip_spaces_and_downcase(l_params[:last_name]) ||
	  		 @client.dob.to_s != l_params[:dob].to_s ||
	  		 @client.ssn != l_params[:ssn].scan(/\d/).join ||
	  		 @client.gender.to_s != l_params[:gender].to_s)

			 l_params[:ssn_enumeration_type] = 4352
			 l_params[:sves_type] = 4656
		end
		@client.assign_attributes(l_params)

		if @client.valid?
			 return_object = ClientDemographicsService.update_client(@client,params[:notes])
			if return_object.class.name == "String"
				# error
				flash.now[:alert] = return_object
			 	render :edit
			else
				# success
			 	flash[:notice] = "Demographics information saved."
			 	session[:CLIENT_ID] = return_object.id
			 	li_client_id = session[:CLIENT_ID]
			 	@client = Client.find(li_client_id)
			 	if session[:NAVIGATE_FROM].blank?
   					redirect_to show_client_path
   				else
   					# Manoj 09/18/2014 - after correcting data elemnents go back to Application screening if you have come from application screening page.
	  				navigate_back_to_called_page()
   				end
			end
		else
		 	render :edit
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating client."
		redirect_to_back
	end

	def new_search
	  	# Manoj 08/29/2014
	  	#  New search will come to this action
	  	# Rails.logger.debug("client_new_search_first")

	  	clear_session_variables()
	  	session[:CLIENT_ID] = nil
	  	# clear APPLICATION ID & PROGRAM_UNIT_ID in sessions - since focus client is changed. Manoj 10/09/2014
	  	session[:APPLICATION_ID] = nil
	  	session[:PROGRAM_UNIT_ID] = nil
	  	session[:HOUSEHOLD_ID] = nil
	  	session[:NAVIGATE_FROM] = nil
	  	# session[:HOUSEHOLD_MEMBER_ID] = nil
	  	AuditModule.set_current_user=(current_user)

	  	@client = Client.new
	  	# Open empty search page
	  	render 'search'
	rescue => err
	  		error_object = CommonUtil.write_to_attop_error_log_table("ClientsController","new_search",err,current_user.uid)
	  		flash[:alert] = "Error ID: #{error_object.id} - Error when searching for new client."
	  		redirect_to_back
	end

  def search
  		AuditModule.set_current_user=(current_user)
  	if valid_search_parameters_are_entered?
  		 populate_session_from_params(params)
  		if params[:bud_unit].present?
  			# searching by program unit ID
	  		program_units = ProgramUnit.where("id = ?",params[:bud_unit].to_i)
	  		program_unit = program_units.present? ? program_units.first : nil
	  		if program_unit.present?
	  			# primary_beneficiary_collection = ProgramUnitMember.get_primary_beneficiary(program_unit.id)
		  		# session[:CLIENT_ID] = primary_beneficiary_collection.first.client_id
		  		primary_contact = PrimaryContact.get_primary_contact(program_unit.id, 6345)
		  		if primary_contact.present?
		  			session[:CLIENT_ID] = primary_contact.client_id
		  		end
		  		redirect_to program_units_path
		  	else
		  		@show_new_button = true
		  		flash.now[:notice] = "No results found"
		  		render :search_results
	  		end
	  	else
	  		# Manoj 09/01/2014
		  	# Client search from Search service object
		  	#  09/01/2014
		  	l_client_serach_service = SearchModule::ClientSearch.new
		  	# Client search service will return Client result object or Error Message string object
		   	return_obj = l_client_serach_service.search(params)
		  	@show_new_button = true
		  	if return_obj.class.name == "String"
		  		# flash the error message
		  		flash.now[:notice] = "#{return_obj}."
		  		if return_obj == "No results found"
		  			render :search_results
		  		else
		  			render :search
		  		end
		  		# Manoj -09/17/2014
			    # Save SSN in session -so that if user decides to add new client for SSN he did not find - we can prepopulate that SSN.
			    # populate_session_from_params(params)
		  	else
		  		reset_pre_populate_session_variables()
		  		# results found
		  		l_records_per_page = SystemParam.get_pagination_records_per_page
		  		@clients = return_obj.order("last_name asc").page(params[:page]).per(l_records_per_page)
		  	end
	  	end
	else
		flash.now[:notice] = "Please enter only one search criterion, either SSN, name or program unit."
  	end
  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientsController","search",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when searching for client."
		redirect_to_back
  end

  def search_results

  end


def set_selected_client_in_session
	clear_session_variables()
	# Rule 1 : Add selected client to session[:CLIENT_ID]
	# Rule 2 : Navigate to Household registration - Demographics step -show

  	session[:CLIENT_ID] = params[:id].to_i
  	# clear APPLICATION ID & PROGRAM_UNIT_ID in sessions - since focus client is changed. Manoj 10/09/2014
  	session[:APPLICATION_ID] = ApplicationMember.get_application_id(session[:CLIENT_ID])
  	session[:PROGRAM_UNIT_ID] = nil
  	session[:HOUSEHOLD_ID] = nil
  	# session[:HOUSEHOLD_MEMBER_ID] = nil

  	# set household_id set in session.
  	 # Rule: from client ID get household ID.
  	if  params[:household_id].to_i == 0
  		household_member_collection = HouseholdMember.where("client_id = ? ",session[:CLIENT_ID].to_i)
  	else
  		household_member_collection = HouseholdMember.where("client_id = ? and household_id = ?",params[:id].to_i,params[:household_id].to_i)
  	end

  	if household_member_collection.present?
  	 	household_member_object = household_member_collection.first
  	 	session[:HOUSEHOLD_ID] = household_member_object.household_id
  	 	# session[:HOUSEHOLD_MEMBER_ID] = household_member_object.id
  	end

  	 # Manoj 10/09/2014 - end
  	if session[:NAVIGATE_FROM].blank?
  	 	# fail
  	 	# if household member present for that client - then set the hh member and
  	 	if session[:HOUSEHOLD_ID].blank?
  	 		# Navigate to household registration demographics step - show page
  	 		session[:HOUSEHOLD_ID] = 0
  	 		# session[:NEW_HOUSEHOLD_ID] = session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = session[:NEW_HOUSEHOLD_MEMBER_ID] = nil
  	 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = session[:NEW_HOUSEHOLD_MEMBER_ID] = nil
  	 		redirect_to start_household_member_registration_wizard_path()
  	 	else
  	 		# session[:NEW_HOUSEHOLD_ID] = session[:HOUSEHOLD_ID]
  	 		# session[:NEW_HOUSEHOLD_MEMBER_ID] = session[:HOUSEHOLD_MEMBER_ID]
  	 		redirect_to household_index_path()
  	 		# redirect_to start_household_member_registration_wizard_path()
  	 	end
  	else
  	 	# fail
  	 	navigate_back_to_called_page()
  	end
 rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientsController","set_selected_client_in_session",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when selecting the client."
		redirect_to_back
end

# def head_of_household_question
# 	# Begin Intake calls this method.
# end






	private

		def client_params
			params.require(:client).permit(:first_name, :middle_name,:last_name,:suffix,:ssn,:ssn_not_found,:dob,:gender,:marital_status,:primary_language,:ssn_enumeration_type,:identification_type,:veteran_flag,:other_identification_document,:felon_flag,:rcvd_tea_out_of_state_flag,:register_to_vote_flag)
	  	end

	  	def client_update_params
			params.require(:client).permit(:first_name, :middle_name,:last_name,:suffix,:ssn,:ssn_not_found,:dob,:gender,:marital_status,:primary_language,:death_date,:ssn_enumeration_type,:identification_type,:veteran_flag,:other_identification_document,:felon_flag,:rcvd_tea_out_of_state_flag,:register_to_vote_flag)
	  	end

	  	def reset_pre_populate_session_variables()
	  	 	if session[:NEW_CLIENT_SSN].present?
	  			session[:NEW_CLIENT_SSN] = nil
	  		end

	  		if session[:NEW_CLIENT_LAST_NAME].present?
	  			session[:NEW_CLIENT_LAST_NAME] = nil
	  		end

	  		if session[:NEW_CLIENT_FIRST_NAME].present?
	  			session[:NEW_CLIENT_FIRST_NAME] = nil
	  		end

	  		if session[:NEW_CLIENT_DOB].present?
	  			session[:NEW_CLIENT_DOB] = nil
	  		end
	  		if session[:NEW_CLIENT_GENDER].present?
	  			session[:NEW_CLIENT_GENDER] = nil
	  		end
	  	end

	  	def populate_session_from_params(arg_param)
	  	 	if arg_param[:ssn].present?
		    	session[:NEW_CLIENT_SSN] =  arg_param[:ssn]
		    end

		    if arg_param[:last_name].present?
		    	session[:NEW_CLIENT_LAST_NAME] =  arg_param[:last_name]
		    end

		    if arg_param[:first_name].present?
		    	session[:NEW_CLIENT_FIRST_NAME] =  arg_param[:first_name]
		    end

		    if arg_param[:dob].present?
		    	session[:NEW_CLIENT_DOB] =  arg_param[:dob]
		    end

		    if arg_param[:gender].present?
		    	session[:NEW_CLIENT_GENDER] =  arg_param[:gender]
		    end
	  	end

	  	def format_ssn
		  	if params[:ssn].present?
		  		params[:ssn] = params[:ssn].scan(/\d/).join
		  	end
		end

		def strip_spaces_and_downcase(arg_string)
			return arg_string.strip.downcase
		end

		def valid_search_parameters_are_entered?
			count = 0
			if params[:ssn].present?
				count = count + 1
			end
			if params[:last_name].present? || params[:first_name].present? || params[:dob].present? || params[:gender].present?
				count = count + 1
			end
			if params[:bud_unit].present?
				count = count + 1
			end
			if count == 1
				return true
			else
				return false
			end

		end

end


