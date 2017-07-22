class HouseholdAddressChangesController < AttopAncestorController
	# Manoj 03/23/2016
	def index
		# Action to show household members with their physical address
		if session[:HOUSEHOLD_ID].present? && session[:HOUSEHOLD_ID] != 0
			@household = Household.find(session[:HOUSEHOLD_ID].to_i)
			@household_members = HouseholdMember.get_all_members_of_household(@household.id)
			# Household Physical address
			# get first client with 'Inhousehold' status and put that in the session.
			@in_household_status_members = HouseholdMember.get_all_members_in_the_household(@household.id)
			if @in_household_status_members.present?
				household_member_object = @in_household_status_members.first
				session[:CLIENT_ID] = household_member_object.client_id
				# get the physical address for this client - that will be the physical address of household since
				# Physical address is shared by members of same household.
				physical_address_collection = Address.get_client_residential_addresses(household_member_object.client_id).order("addresses.id ASC")
				if physical_address_collection.present?
					@physical_address_object = physical_address_collection.first
				else
					@physical_address_object = nil
				end
			end
		end
	end


# ==========================================WIZARD FUNCTIONALITY START ========================================================

	def initialize_change_household_address_wizard
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		session[:CHANGE_HOUSEHOLD_ADDRESS_STEP]  = nil
		# 1. delete any orphan address records in change_household_address_processes table
		ChangeHouseholdAddressProcess.initialize_change_household_address_processes(@household.id,params[:current_address_id].to_i)
		# session[:OLD_PHYSICAL_ADDRESS_ID] = params[:current_address_id]
		redirect_to new_household_address_path(@household.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangeController","initialize_change_household_address_wizard",err,current_user.uid)
		flash[:alert] = "Error occured when changing household address information, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end

	def start_change_household_address_wizard
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		if session[:CHANGE_HOUSEHOLD_ADDRESS_STEP].blank?
      	 	session[:CHANGE_HOUSEHOLD_ADDRESS_STEP] = nil
      	end
      	@change_address_step_object = ChangeHouseholdAddressProcess.new
      	@new_household_address = Address.find(params[:new_household_address_id].to_i)

	   	if session[:CHANGE_HOUSEHOLD_ADDRESS_STEP] == "household_new_address_step"
	   	elsif session[:CHANGE_HOUSEHOLD_ADDRESS_STEP] == "household_members_moving_to_new_address_step"
	   		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
			@members_moved_to_new_address_collection = EntityAddress.get_clients_living_in_this_address(@new_household_address.id)
	   	end

	   	# last line
      	@change_address_step_object.current_step = session[:CHANGE_HOUSEHOLD_ADDRESS_STEP]
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangeController","start_change_household_address_wizard",err,current_user.uid)
		flash[:alert] = "Error occured when changing household address information, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end

	def process_change_household_address_wizard
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@new_household_address = Address.find(params[:new_household_address_id].to_i)

   		@change_address_step_object = ChangeHouseholdAddressProcess.new
		@change_address_step_object.current_step = session[:CHANGE_HOUSEHOLD_ADDRESS_STEP]
		 # manage steps -start
      	if params[:back_button].present?
      		@change_address_step_object.previous_step
      	elsif @change_address_step_object.last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
           @change_address_step_object.next_step
        end
       session[:CHANGE_HOUSEHOLD_ADDRESS_STEP] = @change_address_step_object.current_step
       # manage steps -end

        if @change_address_step_object.get_process_object == "household_new_address_step" && params[:next_button].present?
      		redirect_to start_change_household_address_wizard_path(@new_household_address.id)
	    elsif @change_address_step_object.current_step == "household_members_moving_to_new_address_step" && params[:last_step_button].present?
	    	# any records added ?
	    	if EntityAddress.get_clients_living_in_this_address(@new_household_address.id).present?
		    	if EntityAddress.all_household_members_moved_to_new_address?(@household.id,@new_household_address.id)
					# save current address as prior address
					current_address_object = ChangeHouseholdAddressProcess.get_current_address_object_for_household(@household.id)
					current_address_object.effective_end_date = (@new_household_address.effective_begin_date - 1)
					current_address_object.address_type = 5769 # prior physical
					current_address_object.save
					# 2.
					ChangeHouseholdAddressProcess.clear_process_records_for_household(@household.id)
					flash[:notice] = "Household address change successful."
		       		redirect_to household_address_change_index_path
				else
					# check if any household present in this new address - if few members of one household moving to another household.
					@address_search_results_collection = Address.search_any_household_in_this_address(@new_household_address.id)
		       		if @address_search_results_collection.present?
		       			redirect_to household_with_same_address_search_results_path(@new_household_address.id,@household.id)
		       		else
		       			current_address_object = ChangeHouseholdAddressProcess.get_current_address_object_for_household(@household.id)
		       			ls_msg = Household.new_household_id_for_members_moved_out_of_old_household(@household,current_address_object,@new_household_address)
		       			if ls_msg == 'SUCCESS'
		       				flash[:notice] = "Household address change successful."
		       				redirect_to household_address_change_index_path
		       			else
		       				flash[:alert] = "Failed to change household address"
		       				redirect_to start_change_household_address_wizard_path(@new_household_address.id)
		       			end
		       		end
				end
			else
				# Error condition - No clients added cannot proceed.
		 		session[:CHANGE_HOUSEHOLD_ADDRESS_STEP] = "household_members_moving_to_new_address_step"
		 		@change_address_step_object.errors[:base] << "Selecting household member is mandatory"
				render :start_change_household_address_wizard
			end
       else
		   # previous button is clicked.
		   redirect_to start_change_household_address_wizard_path
	   end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangeController","process_change_household_address_wizard",err,current_user.uid)
		flash[:alert] = "Error occured in address change process for household, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end


	def exit_change_household_address_wizard
		ChangeHouseholdAddressProcess.clear_orphan_address_records(params[:household_id].to_i)
		redirect_to household_address_change_index_path
	rescue => err
	  	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","exit_change_household_address_wizard",err,current_user.uid)
	  	flash[:alert] = "Error occured when exiting the address change wizard, for more details refer to error ID: #{error_object.id}."
	  	redirect_to_back
	end

# ==========================================WIZARD FUNCTIONALITY END ========================================================

	# ==============================================================================================================
	# ADDRESS CREATION/VALIDATION/EDIT START -step1  -CRUD

	def new_household_address
		@household = Household.find(params[:household_id].to_i)
		@household_physical_address = Address.new
		@household_physical_address.state = 5793
	rescue => err
	  	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","new_household_address",err,current_user.uid)
	  	flash[:alert] = "Error occured when creating new address information, for more details refer to error ID: #{error_object.id}."
	  	redirect_to_back
	end




	def validate_household_address
		@household = Household.find(params[:household_id].to_i)
		address_params = params_values
		@household_physical_address = Address.new(address_params)
		@household_physical_address.address_type = 4664
		if @household_physical_address.valid?
			@usps_address = Address.new
			@usps_address = AddressService.initialize_with_verified_address(address_params, @usps_address)
			if  AddressService.compare_address_with_usps_address(@household_physical_address, @usps_address)
				# both are same - entered address is verified - proceed to save
				create_new_address_for_step1()
			else
				# entered address is different from USPS address - show screen with entered/usps address
				render 'confirm_household_contact_information'
			end
		else
			render :new_household_address
		end
	rescue => err
	  	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","validate_household_address",err,current_user.uid)
	  	flash[:alert] = "Error occured when validating address information, for more details refer to error ID: #{error_object.id}."
	  	redirect_to_back
	end

	def create_household_address
		@household = Household.find(params[:household_id].to_i)
		create_new_address_for_step1()
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","create_household_address",err,current_user.uid)
		flash[:alert] = "Error occured when creating address information, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end


	def edit_household_address
		@household = Household.find(params[:household_id].to_i)
		@household_physical_address = Address.find(params[:household_address_id].to_i)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","edit_household_address",err,current_user.uid)
		flash[:alert] = "Error occured when editing address information, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end

	def validate_household_address_for_edit
		@household = Household.find(params[:household_id].to_i)
		address_params = params_values
		@household_physical_address = Address.new(address_params)
		@household_physical_address.address_type = 4664
		if @household_physical_address.valid?
			@usps_address = Address.new
			@usps_address = AddressService.initialize_with_verified_address(address_params, @usps_address)
			# Rails.logger.debug("@usps_address = #{@usps_address.inspect}")
			if  AddressService.compare_address_with_usps_address(@household_physical_address, @usps_address)
				update_address_for_step1(params[:household_address_id].to_i)
			else
				@household_physical_address.id = params[:household_address_id].to_i
				render 'confirm_household_contact_information_for_edit'
			end
		else
			render :new_household_address
		end
	rescue => err
	  	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","new_household_address",err,current_user.uid)
	  	flash[:alert] = "Error occured when validating address information, for more details refer to error ID: #{error_object.id}."
	  	redirect_to_back
	end


	def update_household_address
		@household = Household.find(params[:household_id].to_i)
		update_address_for_step1(params[:household_address_id].to_i)
	rescue => err
	  	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","update_household_address",err,current_user.uid)
	  	flash[:alert] = "Error occured when updating address information, for more details refer to error ID: #{error_object.id}."
	  	redirect_to_back
	end




	# ADDRESS CREATION/VALIDATION/EDIT -step1  -CRUD - end
# ==============================================================================================================



# =============================================WHO ARE MOVING TO NEW ADDRESS CRUD OPERATION START=====================================================================
	# step 2 - who all are moving to the new address start
	def new_member_to_new_household_address
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@new_address = Address.find(params[:new_household_address_id].to_i)
		@members_moved_to_new_address_collection = EntityAddress.get_clients_living_in_this_address(@new_address.id)
		@available_members = EntityAddress.members_dropdown_not_moved_to_new_address(@household.id,@new_address.id)
		@client_entity_address_object = EntityAddress.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","new_member_to_new_household_address",err,current_user.uid)
		flash[:alert] = "Error occurred when adding household members to new address, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end


	def create_member_to_new_household_address
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@new_address = Address.find(params[:new_household_address_id].to_i)
		l_params = add_member_params
		@members_moved_to_new_address_collection = EntityAddress.get_clients_living_in_this_address(@new_address.id)
		@available_members = EntityAddress.members_dropdown_not_moved_to_new_address(@household.id,@new_address.id)
		@client_entity_address_object = EntityAddress.new
		if l_params[:entity_id].present?
			# client_id selected - then proceed
			ls_msg = EntityAddress.save_client_entity_address(@new_address.id,l_params[:entity_id].to_i)
			if ls_msg == "SUCCESS"
				if params[:save_and_exit].present?
					redirect_to start_change_household_address_wizard_path(@new_address.id)
				elsif params[:save_and_add].present?
					redirect_to add_member_to_new_household_address_path(@new_address.id)
				end
			else
				error_object = CommonUtil.write_to_attop_error_log_table_without_trace_details("HouseholdAddressChangesController","create_member_to_new_household_address","#{ls_msg}","#{ls_msg}",current_user.uid)
				flash[:alert] = "Error ID: #{error_object.id} - Error occurred when adding household member to new address."
				render :new_member_to_new_household_address
			end
		else
			# client id is not selected - error
			@client_entity_address_object.errors[:base] << "Selecting household member is mandatory"
			render :new_member_to_new_household_address
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","create_absent_parent_child_relation",err,current_user.uid)
		flash[:alert] = "Error occurred when saving household members to new address, for more details refer to error ID: #{error_object.id}."
		redirect_to_back

	end

	def deselect_member_from_moving_to_new_address
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@new_household_address = Address.find(params[:new_household_address_id].to_i)
		EntityAddress.remove_client_from_address(params[:member_client_id].to_i,@new_household_address.id)
		redirect_to start_change_household_address_wizard_path(@new_household_address.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","deselect_member_from_moving_to_new_address",err,current_user.uid)
		flash[:alert] = "Error occurred when deselecting client from new address, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end

# =============================================WHO ARE MOVING TO NEW ADDRESS CRUD OPERATION END=====================================================================

# =====================================AFTER CLICKING FINISH TASKS START =============================================================

	def household_with_same_address_search_results
		@new_household_address = Address.find(params[:new_household_address_id].to_i)
		@household = Household.find(params[:current_household_id].to_i)
		@address_search_results = Address.search_any_household_in_this_address(params[:new_household_address_id].to_i)
		# Rails.logger.debug("@address_search_results = #{@address_search_results.inspect}")
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","household_with_same_address_search_results",err,current_user.uid)
		flash[:alert] = "Error occurred when showing households residing in same address, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end



	def add_members_to_selected_household_address
		# this is called from 'join this household' link from other household's residing in the same address
		current_household_object = Household.find(session[:HOUSEHOLD_ID].to_i)
		new_address_object = Address.find(params[:new_household_address_id].to_i)

		selected_household_object = Household.find(params[:selected_household_id].to_i)
		selected_address_object = Address.find(params[:selected_address_id].to_i)
		ls_msg = Household.members_moving_from_one_household_to_another_process(current_household_object,new_address_object,selected_household_object,selected_address_object)
		if ls_msg == "SUCCESS"
			redirect_to household_address_change_index_path
		else
			flash[:alert] = ls_msg
			redirect_to household_with_same_address_search_results_path(new_address_object.id,current_household_object.id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","add_members_to_selected_household_address",err,current_user.uid)
		flash[:alert] = "Error occurred when adding members to selected household , for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end


	def create_new_household_after_address_search_from_change_address
		current_household_object = Household.find(session[:HOUSEHOLD_ID].to_i)
		new_address_object = Address.find(params[:new_household_address_id].to_i)
		current_address_object = ChangeHouseholdAddressProcess.get_current_address_object_for_household(current_household_object.id)
		ls_msg = Household.new_household_id_for_members_moved_out_of_old_household(current_household_object,current_address_object,new_address_object)
		if ls_msg == "SUCCESS"
			flash[:notice] = "Change of address process successful"
			redirect_to household_address_change_index_path
		else
			flash[:alert] = ls_msg
			redirect_to household_with_same_address_search_results_path(new_address_object.id,current_household_object.id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdAddressChangesController","create_new_household_after_address_search_from_change_address",err,current_user.uid)
		flash[:alert] = "Error occurred when creating new household, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end



# =====================================AFTER CLICKING FINISH TASKS END =============================================================




	private

		def params_values
		  	params.require(:address).permit(:in_care_of,:address_line1,:address_line2,:city,:state,:zip,:zip_suffix,:effective_begin_date,:living_arrangement,:overwrite_household_address)
		end


		def create_new_address_for_step1()
				overwrite_address_params_with_verified_address_if_required()
				l_params = params[:address]
				l_params = params_values
				@household_physical_address = Address.new(l_params)
				@household_physical_address.address_type = 4664 # Physical
				@household_physical_address.effective_begin_date = Date.today	if  l_params[:effective_begin_date].blank?
				if l_params[:overwrite_household_address].to_s == 'N'
					@household_physical_address.verified = 'N'
				else
					@household_physical_address.verified = 'Y'
				end
				if @household_physical_address.save
					session[:CHANGE_HOUSEHOLD_ADDRESS_STEP] = "household_members_moving_to_new_address_step"
					ChangeHouseholdAddressProcess.update_new_address_id_for_household(@household.id,@household_physical_address.id)
					flash[:notice] = "New address created"
					redirect_to start_change_household_address_wizard_path(@household_physical_address.id)
				else
					render :new_household_address
				end
		end

		def update_address_for_step1(arg_address_id)
				overwrite_address_params_with_verified_address_if_required()
				l_params = params[:address]
				l_params = params_values
				@household_physical_address = Address.find(arg_address_id)
				@household_physical_address.address_type = 4664 # Physical
				@household_physical_address.effective_begin_date = Date.today	if  l_params[:effective_begin_date].blank?
				@household_physical_address.address_line1 =l_params[:address_line1]
				@household_physical_address.address_line2 = l_params[:address_line2]
				@household_physical_address.city = l_params[:city]
				@household_physical_address.state = l_params[:state]
				@household_physical_address.zip = l_params[:zip]
				@household_physical_address.zip_suffix = l_params[:zip_suffix] if l_params[:zip_suffix].present?
				@household_physical_address.in_care_of = l_params[:in_care_of] if l_params[:in_care_of].present?
				@household_physical_address.living_arrangement = l_params[:living_arrangement] if l_params[:living_arrangement].present?
				if l_params[:overwrite_household_address].to_s == 'N'
					@household_physical_address.verified = 'N'
				else
					@household_physical_address.verified = 'Y'
				end
				if @household_physical_address.save
					session[:CHANGE_HOUSEHOLD_ADDRESS_STEP] = "household_members_moving_to_new_address_step"
					# Rails.logger.debug("session[:CHANGE_HOUSEHOLD_ADDRESS_STEP] in create_new_address_for_step1 = #{session[:CHANGE_HOUSEHOLD_ADDRESS_STEP].inspect}")
					redirect_to start_change_household_address_wizard_path(@household_physical_address.id)
				else
					render :edit_household_address
				end
		end


		def overwrite_address_params_with_verified_address_if_required()
			if params[:address][:overwrite_household_address].present? && params[:address][:overwrite_household_address] == "Y"
				verified_address = AddressService.get_verified_address(params[:address])
				# Rails.logger.debug("verified_address = #{verified_address.inspect}")
				if verified_address.present? && verified_address.class.name != "String"
					city_and_state_hash = AddressService.get_city_and_state_code_table_item_ids(verified_address)
					params[:address][:address_line1] = verified_address["Address2"]
					params[:address][:address_line2] = verified_address["Address1"].present? ? verified_address["Address1"] : ""
					params[:address][:city] = verified_address["City"].split.map(&:capitalize).join(' ') # Code table equivalent
					params[:address][:state] = city_and_state_hash[:state] # Code table equivalent
					params[:address][:zip] = verified_address["Zip_code"]
					params[:address][:zip_suffix] = verified_address["Zip_suffix"]
				end
			end
		end

		def add_member_params
			params.require(:entity_address).permit(:entity_id)
		end



end
