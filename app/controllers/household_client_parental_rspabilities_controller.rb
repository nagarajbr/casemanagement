class HouseholdClientParentalRspabilitiesController < AttopAncestorController
# Manoj PAtil ABsent parent for the household.
# Note: session[:CLIENT_ID] contains ABSENT PARENT (new or selected from search result)
	def index
		# get parent responsibility list for the focus household ID
		if session[:HOUSEHOLD_ID].present? && session[:HOUSEHOLD_ID] != 0
			@household = Household.find(session[:HOUSEHOLD_ID].to_i)
			@absent_parent_resp_list = ClientParentalRspability.get_absent_parenatl_responsibility_list_for_household(session[:HOUSEHOLD_ID].to_i)
			session[:SELECTED_AP_RESPONSIBILITY_ID_FROM_CHANGE_AP] = nil
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdClientParentalRspabilitiesController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid household."
		redirect_to_back
	end

	def show
		# show for selected responsibility record.
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@absent_parent_rspability =  ClientParentalRspability.find(params[:id])
		@absent_parent_relationship = ClientParentalRspability.get_relationship_record_for_absent_parent(@absent_parent_rspability.id)
		# Rails.logger.debug("@absent_parent_relationship = #{@absent_parent_relationship.inspect}")
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6490,@absent_parent_rspability.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdClientParentalRspabilitiesController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid absent parent responsibility record."
		redirect_to_back
	end

	def edit
		# Edit responsibility record.
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@absent_parent_rspability =  ClientParentalRspability.find(params[:id])
		@absent_parent_relationship = ClientParentalRspability.get_relationship_record_for_absent_parent(@absent_parent_rspability.id)
		@absent_parent = Client.find(@absent_parent_relationship.to_client_id)
		@notes = nil
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientParentalRspabilitiesController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing absent parent responsibility record."
		redirect_to_back
	end

	def update
		# fail
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@absent_parent_rspability =  ClientParentalRspability.find(params[:id])
		@absent_parent_relationship = ClientParentalRspability.get_relationship_record_for_absent_parent(@absent_parent_rspability.id)
		@absent_parent_rspability.deprivation_code = parent_params[:deprivation_code]
		@absent_parent_rspability.good_cause = parent_params[:good_cause]
		@absent_parent_rspability.child_support_referral = parent_params[:child_support_referral]
		@absent_parent_rspability.married_at_birth = parent_params[:married_at_birth]
		@absent_parent_rspability.paternity_established = parent_params[:paternity_established]
		@absent_parent_rspability.court_order_number = parent_params[:court_order_number]
		@absent_parent_rspability.court_ordered_amount = parent_params[:court_ordered_amount]
		@absent_parent_rspability.amount_collected = parent_params[:amount_collected]

		if @absent_parent_rspability.valid?
			ls_msg = ParentalResponsibilityService.update_client_parental_responsibility(@absent_parent_rspability,@absent_parent_relationship.from_client_id,params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Absent parenat responsibility information saved"
				redirect_to household_absent_parents_index_path
			else
				flash[:alert] = ls_msg
				render :edit
			end
		else
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientParentalRspabilitiesController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when Updating Absent parenat responsibility record"
		redirect_to_back
	end


	def new_household_absent_parents_wizard_initialize
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		session[:ABSENT_PARENT_STEP]  = session[:CLIENT_ID] = session[:BACK_BUTTON_FROM_ADDRESS] = nil
		redirect_to new_household_absent_parent_search_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdClientParentalRspabilitiesController","new_household_absent_parents_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error occured when creating new absent parent information, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end

	def change_absent_parent_wizard_initialize
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		session[:SELECTED_AP_RESPONSIBILITY_ID_FROM_CHANGE_AP] = params[:ab_parent_responsibility_id]
		session[:ABSENT_PARENT_STEP]  = session[:CLIENT_ID] = session[:BACK_BUTTON_FROM_ADDRESS] = session[:BACK_BUTTON_FROM_ADDRESS] = nil
		# redirect_to start_household_absent_parents_wizard_path
		# redirect to search absent parent
		redirect_to new_household_absent_parent_search_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdClientParentalRspabilitiesController","new_household_absent_parents_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error occured when changing absent parent information, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end


	def start_household_absent_parents_wizard
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		if session[:ABSENT_PARENT_STEP].blank?
      	 	session[:ABSENT_PARENT_STEP] = nil
      	end
      	# if session[:ABSENT_PARENT_RESPONSIBILITY_ID].present?
      	# 	@absent_parent_responsibility = ClientParentalRspability.find(session[:ABSENT_PARENT_RESPONSIBILITY_ID].to_i)
      	# else
      		@absent_parent_responsibility = ClientParentalRspability.new
      	# end

      	if session[:CLIENT_ID].present?
      		@absent_parent = Client.find(session[:CLIENT_ID].to_i)
      	end

      	if session[:ABSENT_PARENT_STEP] == "household_absent_parent_address_step" && @absent_parent.present?
			session[:CALLED_FROM_ABSENT_PARENT_REGISTRATION_PAGE] = "Y"
			@addresses = Address.get_entity_addresses(@absent_parent.id,6150)
			if @addresses.blank?
				# Rails.logger.debug("session[:BACK_BUTTON_FROM_ADDRESS] = #{session[:BACK_BUTTON_FROM_ADDRESS]}")
				# fail
				if session[:BACK_BUTTON_FROM_ADDRESS].present? && session[:BACK_BUTTON_FROM_ADDRESS] == 'Y'
					# session[:BACK_BUTTON_FROM_ADDRESS] = nil
					# fail
					# Normal show page - since user clicked on back button.
				else
					# fail
					redirect_to new_household_absent_parent_address_path(@absent_parent.id)
				end
			else
				set_phone_numbers
				@client_email = ClientEmail.get_email_address(@absent_parent.id)
				worker = ClientEmail.get_last_modified_user_id(@absent_parent.id)
				@modified_by = worker.present? ? worker.updated_by : nil
			end
		elsif session[:ABSENT_PARENT_STEP] == "household_children_with_no_absent_parent_data_step" && @absent_parent.present?


			if session[:SELECTED_AP_RESPONSIBILITY_ID_FROM_CHANGE_AP].present?
				# fail
				# coming from CHANGE ABSENT PARENT BUTTON - IF BY MISTAKE THEY SELECTED WRONG PARENT
				@children_with_absent_parent_collection = ClientParentalRspability.change_absent_parent_for_selected_client(@absent_parent.id,session[:SELECTED_AP_RESPONSIBILITY_ID_FROM_CHANGE_AP].to_i,@household.id)
			else
				# fail
				@children_with_absent_parent_collection = ClientParentalRspability.get_children_of_absent_parent_for_household(@absent_parent.id,@household.id)
			end




			# Rails.logger.debug("@children_with_absent_parent_collection = #{@children_with_absent_parent_collection.inspect}")
		elsif session[:ABSENT_PARENT_STEP] == "household_absent_parent_responsibility_step" && @absent_parent.present?
			# fail
			@children_with_absent_parent_collection = ClientParentalRspability.get_children_of_absent_parent_for_household(@absent_parent.id,@household.id)
			@children_with_absent_parent_object = @children_with_absent_parent_collection.first
			if session[:SELECTED_AP_RESPONSIBILITY_ID_FROM_CHANGE_AP].present?
				redirect_to new_absent_parent_responsibility_information_path(@absent_parent.id)
			else
				@ap_responsibility_data = ClientParentalRspability.get_parental_responsibility_data_for_absent_parent(@absent_parent.id,@children_with_absent_parent_object.id)
			end

		end


      	# last line
      	@absent_parent_responsibility.current_step = session[:ABSENT_PARENT_STEP]
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdClientParentalRspabilitiesController","new_household_absent_parents_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error occured when creating new absent parent information, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end

	def process_household_absent_parents_wizard
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		# if session[:ABSENT_PARENT_RESPONSIBILITY_ID].present?
  #     		@absent_parent_responsibility = ClientParentalRspability.find(session[:ABSENT_PARENT_RESPONSIBILITY_ID].to_i)
  #     	else
      		@absent_parent_responsibility = ClientParentalRspability.new
      	# end
		@absent_parent_responsibility.current_step = session[:ABSENT_PARENT_STEP]
		 # manage steps -start
      	if params[:back_button].present?
      		@absent_parent_responsibility.previous_step
      	elsif @absent_parent_responsibility.last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
           @absent_parent_responsibility.next_step
        end
       session[:ABSENT_PARENT_STEP] = @absent_parent_responsibility.current_step
       # manage steps -end


       if @absent_parent_responsibility.get_process_object == "household_absent_parent_information_step" && params[:next_button].present?
       	if session[:CLIENT_ID].present?
      		@absent_parent = Client.find(session[:CLIENT_ID].to_i)
      		redirect_to start_household_absent_parents_wizard_path
      	else
      		@absent_parent_responsibility.previous_step
		 	session[:ABSENT_PARENT_STEP] = @absent_parent_responsibility.current_step
		 	@absent_parent_responsibility.errors[:base] << "Absent parent is required to proceed to next step."
			render :start_household_absent_parents_wizard
      	end

       elsif @absent_parent_responsibility.get_process_object == "household_absent_parent_address_step" && params[:next_button].present?
       		@absent_parent = Client.find(session[:CLIENT_ID].to_i)
       		session[:CALLED_FROM_ABSENT_PARENT_REGISTRATION_PAGE] = "Y"
			@addresses = Address.get_entity_addresses(@absent_parent.id,6150)
			if @addresses.present?
				# Rule if Absent parent's address is same as household's address then he is not absent parent of this household.
	       		if ClientParentalRspability.is_absent_parents_address_same_as_focus_household_address(session[:CLIENT_ID].to_i,session[:HOUSEHOLD_ID].to_i) == 'Y'
	       			# Error condition - End the
	       			@absent_parent_responsibility.previous_step
			 		session[:ABSENT_PARENT_STEP] = @absent_parent_responsibility.current_step
			 		@absent_parent_responsibility.errors[:base] << "Absent parent's address cannot be same as household's(children's) address."
					render :start_household_absent_parents_wizard
	       		else
	       			# fail
	       			redirect_to start_household_absent_parents_wizard_path
	       		end
			else
				# go back to previous step and show flash message as error message
				@absent_parent_responsibility.previous_step
				session[:ABSENT_PARENT_STEP] = @absent_parent_responsibility.current_step
				@absent_parent_responsibility.errors[:base] << "Absent parent's address is required to proceed to next step"
				render :start_household_absent_parents_wizard
			end

       elsif @absent_parent_responsibility.get_process_object == "household_children_with_no_absent_parent_data_step" && params[:next_button].present?
	         @absent_parent = Client.find(session[:CLIENT_ID].to_i)
	       	 @children_with_absent_parent_collection = ClientParentalRspability.get_children_of_absent_parent_for_household(@absent_parent.id,@household.id)
	       	 if @children_with_absent_parent_collection.present?
	       		redirect_to start_household_absent_parents_wizard_path
	       	 else
	       	 	@absent_parent_responsibility.previous_step
				session[:ABSENT_PARENT_STEP] = @absent_parent_responsibility.current_step
				@absent_parent_responsibility.errors[:base] << "selection of children's of absent parent is required to proceed to next step"
				render :start_household_absent_parents_wizard
	       	 end
       elsif @absent_parent_responsibility.current_step == "household_absent_parent_responsibility_step" && params[:last_step_button].present?
       		@absent_parent = Client.find(session[:CLIENT_ID].to_i)
       		ls_message = ClientParentalRspability.absent_parent_responsibility_data_populated_for_absent_parent_for_household(@absent_parent.id,@household.id)
       		if ls_message == "SUCCESS"
       			redirect_to household_absent_parents_index_path
       		else
       			@absent_parent_responsibility.errors[:base] << "Absent parent responsibility data is required finish the absent parent registration process."
				render :start_household_absent_parents_wizard
       		end
       else
		# previous button is clicked.
			session[:BACK_BUTTON_FROM_ADDRESS] = nil
		   redirect_to start_household_absent_parents_wizard_path
		end

	end


	# absent parent SEARCH ****************************START
#6.

	def new_household_absent_parent_search
		# fail
		#  Rule : Register absent parent - has to force user to first search if the client is already in the system. If he is not found then he can add new client.
		#         New member means = new client + same client_id added in hh_members against hh ID and set to out of household.


		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@show_add_button = false
		@client = Client.new
 		# open custom search and Add member page - uses partials/search service methods.
 		render 'search_and_add_household_absent_parent'
	 rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdClientParentalRspabilitiesController","new_household_absent_parent_search",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - error when searching for absent parent."
	 	redirect_to_back
	end


#7.
	def household_absent_parent_search_results
		#  new_household_absent_parent_search - method will call this action.
		# Call search service to search client.
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		l_client_serach_service = SearchModule::ClientSearch.new
		# return_obj = l_client_serach_service.search(params)
		return_obj = l_client_serach_service.search(params)
	    if return_obj.class.name == "String"
	    	   # Manoj -09/17/2014
			    # Save SSN in session -so that if user decides to add new client for SSN he did not find - we can prepopulate that SSN.
			populate_session_from_params(params)
			    # show result or error message.
	    	if return_obj == "No results found"
	    		@show_add_button = true
	    		@clients = nil
	    		render 'no_absent_parent_data_found_search_results'
	    	else
	    		# flash.now[:notice] = return_obj
	    		@household.errors[:base] = return_obj
	    		render 'search_and_add_household_absent_parent'
	    	end
	    else
	    	 # results found
	    	reset_pre_populate_session_variables()
	        @clients = return_obj
	        @show_add_button = false
	       # show result or error message.
	    	render 'search_and_add_household_absent_parent'
	    end

	 rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdClientParentalRspabilitiesController","household_absent_parent_search_results",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - error when searching client."
	 	redirect_to_back
	end

	def add_searched_absent_parent_into_current_household
		# as a placeholder store this selected parent id in session
		# This will be used to add to relation later.
		session[:CLIENT_ID] = params[:client_id]
		session[:ABSENT_PARENT_STEP] = 'household_absent_parent_address_step'
		flash[:notice] = "Absent parent selected."
		reset_pre_populate_session_variables()

		# #  if the selected client does not belong to current household - then make him Out of household -
		# if HouseholdMember.does_this_client_present_in_the_household?(session[:CLIENT_ID].to_i,session[:HOUSEHOLD_ID].to_i)
		# else
		# 	@household_member_object = HouseholdMember.set_household_member_data(session[:HOUSEHOLD_ID].to_i,session[:CLIENT_ID].to_i)
		# 	@household_member_object.member_status = 6644 # out of HOUSEHOLD STATUS
		# 	@household_member_object.save
		# end

		# 2.


		redirect_to start_household_absent_parents_wizard_path
	end

	def new_household_absent_parent
		session[:BACK_BUTTON_FROM_ADDRESS] = nil
		# open new new_member page so that user will create new client
    	@client = Client.new
    	@client.ssn_not_found = 'N'
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
    	session[:ABSENT_PARENT_STEP] = 'household_absent_parent_registration_step'
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdClientParentalRspabilitiesController","new_household_absent_parent",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - error when adding absent parent."
		redirect_to_back
	end

	def create_new_household_absent_parent

		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@client = Client.new(client_params)
		@client.sves_status = 'S'
		if @client.valid?
			begin
		    	ActiveRecord::Base.transaction do
	    		# 1.
	    		# @client.save!
		    		@client = ClientDemographicsService.create_client(@client,params[:notes])
		    		# fail
		    		# 2.
		    		# @household_member_object = HouseholdMember.set_household_member_data(session[:HOUSEHOLD_ID].to_i,@client.id)
		    		# Rails.logger.debug("@household_member_object = #{@household_member_object.inspect}")
		    		# fail
		    		# @household_member_object.member_status = 6644 # out of HOUSEHOLD STATUS
		    		# @household_member_object.save!
		    		# fail
		    	end
		    	session[:ABSENT_PARENT_STEP] = 'household_absent_parent_address_step'
		    	session[:CLIENT_ID] = @client.id
			  	flash[:notice] = "Absent parent created successfully."
			  	reset_pre_populate_session_variables()
			  	ls_msg = "SUCCESS"
			rescue => err
				error_object = CommonUtil.write_to_attop_error_log_table("Household controller","new_household_member",err,current_user.uid)
				ls_msg = "Failed to create absent parent - for more details refer to error ID: #{error_object.id}."
			end
			if ls_msg != "SUCCESS"
				flash[:alert] = ls_msg
			end

			redirect_to start_household_absent_parents_wizard_path

		else
			render :new_household_absent_parent
		end
	end

	def edit_household_absent_parent
    	@client = Client.find(params[:client_id])
  		@notes =  nil
  	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","edit_household_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def update_household_absent_parent
    	@client = Client.find(params[:client_id].to_i)
	  	@notes =  nil
	  	l_params = client_update_params
	  	if l_params[:identification_type].to_i != 4599
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
				flash.now[:alert] = return_object
			 	render :edit_household_member
			else
			 	flash[:notice] = "Demographics information saved."
			 	li_client_id = return_object.id
			 	@client = Client.find(li_client_id)
			 	session[:ABSENT_PARENT_STEP] = 'household_absent_parent_registration_step'
		  		redirect_to start_household_absent_parents_wizard_path
			end
		else
		 	render :edit_household_absent_parent
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","update_household_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - error occured when updating household member."
		redirect_to_back
	end


	# Manoj 03/19/2016
	# step 3 - 'household_children_with_no_absent_parent_data_step'  actions  start
	def new_absent_parent_child_relation
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@absent_parent = Client.find(params[:absent_parent_client_id].to_i)
		@children_with_absent_parent_collection = ClientParentalRspability.get_children_of_absent_parent_for_household(@absent_parent.id,@household.id)
		@available_children = ClientParentalRspability.children_dropdown_with_no_absent_parent(@household.id,@absent_parent.id)
		@ap_relation_object = ClientRelationship.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdClientParentalRspabilitiesController","new_absent_parent_child_relation",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when creating absent parent relation."
		redirect_to_back
	end

	def create_absent_parent_child_relation

		l_params = add_child_params
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@absent_parent = Client.find(params[:absent_parent_client_id].to_i)
		@children_with_absent_parent_collection = ClientParentalRspability.get_children_of_absent_parent_for_household(@absent_parent.id,@household.id)
		@available_children = ClientParentalRspability.children_dropdown_with_no_absent_parent(@household.id,@absent_parent.id)
		@ap_relation_object = ClientRelationship.new

		if l_params[:from_client_id].present?
			# fail
			ls_msg = ClientRelationship.save_absent_parent_relationships(l_params[:from_client_id].to_i,@absent_parent.id)
			if ls_msg == "SUCCESS"
				 # fail
				if params[:save_and_exit].present?
					redirect_to start_household_absent_parents_wizard_path
				elsif params[:save_and_add].present?
					redirect_to new_absent_parent_child_relation_path(@absent_parent.id)
				end
			else
				error_object = CommonUtil.write_to_attop_error_log_table_without_trace_details("HouseholdClientParentalRspabilitiesController","create_absent_parent_child_relation","#{ls_msg}","#{ls_msg}",current_user.uid)
				flash[:alert] = "Error ID: #{error_object.id} - Error occurred when creating absent parent relation."
				render :new_absent_parent_child_relation
			end
		else
			@ap_relation_object.errors[:base] << "Selecting Child is mandatory"
			render :new_absent_parent_child_relation
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdClientParentalRspabilitiesController","create_absent_parent_child_relation",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when adding relation between child and absent parent."
		redirect_to_back

	end

	def deselect_absent_parent_child_relation
		# fail
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@absent_parent = Client.find(params[:absent_parent_client_id].to_i)
		@children_with_absent_parent_collection = ClientParentalRspability.get_children_of_absent_parent_for_household(@absent_parent.id,@household.id)
		ClientRelationship.delete_absent_parent_relationship_with_child(params[:child_client_id].to_i,@absent_parent.id)
		redirect_to start_household_absent_parents_wizard_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdClientParentalRspabilitiesController","HouseholdClientParentalRspabilitiesController",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when deselecting client from absent parent."
		redirect_to_back
	end

	# step 3 - 'household_children_with_no_absent_parent_data_step'  actions  end

	# step 4 - household_absent_parent_responsibility_step actions start
	def new_absent_parent_responsibility_information
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@absent_parent = Client.find(params[:absent_parent_client_id])
		@parent_rspability = ClientParentalRspability.new
		@notes = nil
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientParentalRspabilitiesController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when creating new parent responsibility record."
		redirect_to_back
	end

	def create_absent_parent_responsibility_information

		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@absent_parent = Client.find(params[:absent_parent_client_id])
		l_params = parent_params
		@parent_rspability = ClientParentalRspability.new

		# list of children for this absent parent
		@children_with_absent_parent_collection = ClientParentalRspability.get_children_of_absent_parent_for_household(@absent_parent.id,@household.id)
		# Rails.logger.debug("@children_with_absent_parent_collection = #{@children_with_absent_parent_collection.inspect}")

		manadatory_validations_error_found = false
		if l_params[:deprivation_code].blank?
			manadatory_validations_error_found = true
			@parent_rspability.errors[:base] << "Deprivation code is mandatory."
		end

		if l_params[:good_cause].blank?
			manadatory_validations_error_found = true
			@parent_rspability.errors[:base] << "Good cause is mandatory."
		end

		if manadatory_validations_error_found == true
			# fail
			@parent_rspability.deprivation_code = l_params[:deprivation_code] if l_params[:deprivation_code].present?
			@parent_rspability.good_cause = l_params[:good_cause] if l_params[:good_cause].present?
			render :new_absent_parent_responsibility_information
		else
			# fail
			# proceed
			ls_msg = ParentalResponsibilityService.create_absent_parent_responsibility_data(@absent_parent,@children_with_absent_parent_collection,l_params,params[:notes],@household.id)
			if ls_msg == "SUCCESS"
				flash[:notice] = "Absent parenat responsibility information saved"
				session[:SELECTED_AP_RESPONSIBILITY_ID_FROM_CHANGE_AP] = nil
				redirect_to household_absent_parents_index_path
			else
				flash[:alert] = ls_msg
				render :new_absent_parent_responsibility_information
			end
		end


	end

	# step 4 - household_absent_parent_responsibility_step actions end


	def absent_parent_return_to_household
		household_object = Household.find(params[:household_id].to_i)
		absent_parent_client_object = Client.find(params[:absent_parent_client_id].to_i)
		absent_parent_responsibility_object = ClientParentalRspability.find(params[:absent_parent_responsibility_id].to_i)
		ls_msg = ClientParentalRspability.absent_parent_rejoins_the_household_process(household_object,absent_parent_client_object,absent_parent_responsibility_object)


		# 1.change deprivation code to 'Not deprived' and parent status 'Present'
		# 2. make the current address as prior address
		# 3. make this absent parent client id -part of household's residential address
		# 4. make the household member status 'Inhousehold'
		# 5. if pending application present - add this client as application member
		# else add new application & add this absent parent client id as application member
		if ls_msg == "SUCCESS"
			flash[:notice] = "Absent Parent returned the household"
			redirect_to household_index_path
		else
			flash[:alert] = ls_msg
			redirect_to household_absent_parents_index_path
		end

	end




private

	def parent_params
		params.require(:client_parental_rspability).permit(:deprivation_code,:good_cause,
			                                               :child_support_referral,:married_at_birth,
			                                               :paternity_established,:court_order_number,
			                                               :court_ordered_amount,:amount_collected,:parent_status
										  				  )
	end

 	def add_child_params
 	 	params.require(:client_relationship).permit(:from_client_id)
 	end

	def client_params
			params.require(:client).permit(:first_name, :middle_name,:last_name,:suffix,:ssn,:ssn_not_found,:dob,:gender,:marital_status,:primary_language,:ssn_enumeration_type,:identification_type,:veteran_flag,:other_identification_document,:felon_flag,:rcvd_tea_out_of_state_flag,:register_to_vote_flag)
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

	def set_phone_numbers
			if session[:CLIENT_ID].present?
				phones = Phone.get_entity_contact_list(session[:CLIENT_ID], 6150)
				primary_phone = phones.where("phone_type = 4661")
				secondary_phone = phones.where("phone_type = 4662")
				other_phone = phones.where("phone_type = 4663")

					@email = @absent_parent.client_email
					@primary_phone = primary_phone.first if primary_phone.present?
					@secondary_phone = secondary_phone.first if secondary_phone.present?
					@other_phone = other_phone.first if other_phone.present?
					# find the last updated by record for client.
					phone_collection = EntityPhone.where("entity_type = 6150 and entity_id = ?", @absent_parent.id).order("updated_at DESC")
					@modified_by = nil
					if phone_collection.present?
						latest_phone_object = phone_collection.first
						@modified_by = latest_phone_object.updated_by
					end

			end
	end







end
