# Author: Manoj Patil
# Description: Capture Household members demographic/relation/finance details in loop for all members of household
# Date: 12/02/2015
class HouseholdsController < AttopAncestorController

# 1.
	def index
		# This is Household composition Index Page.
		# WHEN Intake management menu is selected this will be called.
		# Rule : If Household is there then only show the Index Page - else let the user go to Search page create new client/or find the household and come back.
		if session[:HOUSEHOLD_ID].present? && session[:HOUSEHOLD_ID] != 0
				@household = Household.find(session[:HOUSEHOLD_ID].to_i)
				@household_members = HouseholdMember.get_all_members_of_household(@household.id)
				all_in_household_members = HouseholdMember.get_all_members_in_the_household(@household.id)
				if all_in_household_members.present?
					if session[:CLIENT_ID].blank?
						session[:CLIENT_ID] = all_in_household_members.first.client_id
					end
				end
				# session[:NEW_HOUSEHOLD_ID] = session[:HOUSEHOLD_ID]
				# Rule : Household cannot exist without any members.
				# Household and first member is created in one transaction
				# if session[:HOUSEHOLD_MEMBER_ID].blank?
				# 	hh_member_object = @household_members.first
				# 	session[:HOUSEHOLD_MEMBER_ID] = hh_member_object.id
				# end
				# session[:NEW_HOUSEHOLD_MEMBER_ID] = session[:HOUSEHOLD_MEMBER_ID]
				session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_demographics_step'

				# @all_household_members_steps_completed = HouseholdMemberStepStatus.all_steps_for_household_complete?(@household.id)
				# @is_this_households_first_application = false
				# hh_client_application_collection = ClientApplication.where("household_id = ? and application_disposition_status is null",@household.id).order("id ASC")
				# if hh_client_application_collection.present?
				# 	if hh_client_application_collection.size == 1
				# 		@is_this_households_first_application = true
				# 	end
				# end

				#  Logic to show New Application button to add application other than initial application-
				# Household'd first application should be disposed as accepted/rejected.
				# @can_add_second_application_to_this_household = false
				# disposed_application_collection = ClientApplication.where("household_id = ? and application_disposition_status in (6017,6018)",@household.id)
				# if disposed_application_collection.present?
				# 	@can_add_second_application_to_this_household = true
				# end

		else
			redirect_to root_path
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","index",err,current_user.uid)
		flash[:alert] = "Error occured when showing list of household members, for more details refer to error ID: #{error_object.id}."
		# redirect_to_back
		redirect_to root_path
	end

	def bread_crumbs_selected
		# fail
	   session[:BACK_BUTTON_FROM_ASSESSMENT] = nil
	   session[:BACK_BUTTON_FROM_CITIZENSHIP] = nil
	   session[:BACK_BUTTON_FROM_RELATIONSHIP] = nil
	   session[:BACK_BUTTON_FROM_ADDRESS] = nil
	   session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = params[:step]

	   #if session[:HOUSEHOLD_ID].present? && session[:HOUSEHOLD_ID] != 0
	   		redirect_to start_household_member_registration_wizard_path
	   	#else
	   		# navigate to search page to search page so that household is created.
	   		#redirect_to root_path
	   	#end
   	end


#2.
	# BEGIN iNTAKE link will call this action.
	def new_household_wizard_initialize
		# session[:HOUSE_HOLD_REGISTRATION_COMPLETE] = 'N'
		session[:HOUSEHOLD_ID] = nil
		# session[:HOUSEHOLD_MEMBER_ID] = nil
		# session[:NEW_HOUSEHOLD_ID] = session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = session[:NEW_HOUSEHOLD_MEMBER_ID] = nil
		# session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = session[:NEW_HOUSEHOLD_MEMBER_ID] = nil
		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP]  = nil
		# take it to new client/household/household member creation page
		redirect_to new_household_member_path(0)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","new_household_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error occured when creating new household, for more details refer to error ID: #{error_object.id}."
		redirect_to root_path
	end

#3.
	def edit_household_wizard_initialize
		# fail
		# session[:HOUSE_HOLD_REGISTRATION_COMPLETE] = 'N'
		# called from Edit household member from composition Index page
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@client = Client.find(params[:client_id].to_i)
		@household_member = nil
		hh_member_collection = HouseholdMember.get_household_member_collection(@household.id,@client.id)
		if hh_member_collection.present?
			@household_member = hh_member_collection.first
		end

		session[:HOUSEHOLD_ID] = @household.id
		session[:CLIENT_ID] = @client.id
		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = "household_member_demographics_step"
		redirect_to start_household_member_registration_wizard_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","edit_household_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error occured when showing household member, for more details refer to error ID: #{error_object.id}."
		# redirect_to_back
		redirect_to start_household_member_registration_wizard_path
	end




#4.
	def start_household_member_registration_wizard
		# fail
		# start of wizard of Household Composition
		session[:CLIENT_ASSESSMENT_ID] = nil
		if session[:CLIENT_ID].present?
				@client = Client.find(session[:CLIENT_ID].to_i)
		        @client_email = ClientEmail.where("client_id = ?",@client.id).first
				if session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP].blank?
		      	 	session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = "household_member_demographics_step"
		      	end

		      	if session[:HOUSEHOLD_ID].to_i == 0
		      		@household_member = nil
		      		@edit_address = true
		      		# Rule - Only with Client without household - you can do demographic step,address step and address search results step
		      		# when household is not created
		      		# start from first step
		      		@household = Household.new

		     #  		if session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_demographics_step"
							# @notes = NotesService.get_notes(6150,@client.id,6471,@client.id)
					if session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_address_step"
						session[:CALLED_FROM_HOUSEHOLD_REGISTRATION_PAGE] = "Y"
						@addresses = Address.get_entity_addresses(@client.id,6150)#@client.addresses.where("address_type in (4665,4664)").order(address_type: :desc)
						# set_phone_numbers
						if @addresses.blank?
							Rails.logger.debug("session[:BACK_BUTTON_FROM_ADDRESS] = #{session[:BACK_BUTTON_FROM_ADDRESS]}")
							# fail
							if session[:BACK_BUTTON_FROM_ADDRESS].present? && session[:BACK_BUTTON_FROM_ADDRESS] == 'Y'
								# session[:BACK_BUTTON_FROM_ADDRESS] = nil
								# fail
								# Normal show page - since user clicked on back button.
							else
								# fail
								redirect_to new_household_member_address_path(@client.id)
							end
						else
							set_phone_numbers
							@client_email = ClientEmail.get_email_address(session[:CLIENT_ID])
							worker = ClientEmail.get_last_modified_user_id(session[:CLIENT_ID])
							@modified_by = worker.present? ? worker.updated_by : nil

						end
					elsif session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_address_search_results_step" && session[:HOUSEHOLD_ID].to_i == 0
							# address search results step
							residential_address_collection = Address.get_client_residential_addresses(@client.id)
		       			 	res_addr_object = residential_address_collection.first
		       			 	@address_search_results = Address.search_any_household_in_this_address(res_addr_object.id)
					end
					@household.id = 0
					start_household_member_registration_wizard_common_steps_with_or_without_household_id()
		      	else
		      		# when household is present then address search result is not there.
		      		@edit_address = false
		      		# fail
			      		# normal processing
			      		# if session[:NEW_HOUSEHOLD_ID].present? && session[:NEW_HOUSEHOLD_MEMBER_ID].present?
			      		if session[:HOUSEHOLD_ID].present? && session[:CLIENT_ID].present?
							@household = Household.find(session[:HOUSEHOLD_ID].to_i)
							@household_id = session[:HOUSEHOLD_ID].to_i
							# @household_member = HouseholdMember.find(session[:NEW_HOUSEHOLD_MEMBER_ID].to_i)
							@household_member = nil
							hh_member_collection = HouseholdMember.get_household_member_collection(@household.id,@client.id)
							if hh_member_collection.present?
								@household_member = hh_member_collection.first
							end

							if session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_address_step"
								@addresses = Address.get_entity_addresses(@client.id,6150)
								if @addresses.blank?
									# populate second member address with first member's address - any way all members of the household reside in same address.
									first_hh_member = HouseholdMember.where("household_id = ?",session[:HOUSEHOLD_ID].to_i).order("id ASC").first
									hh_client_id = first_hh_member.client_id
									HouseholdMember.populate_member_address_with_hoh_address(hh_client_id,@client.id)
									@addresses = Address.get_entity_addresses(@client.id,6150)

								end
								set_phone_numbers
								@client_email = ClientEmail.get_email_address(session[:CLIENT_ID])
								worker = ClientEmail.get_last_modified_user_id(session[:CLIENT_ID])
								@modified_by = worker.present? ? worker.updated_by : nil
							end
							start_household_member_registration_wizard_common_steps_with_or_without_household_id()
						end # end of session[:HOUSEHOLD_ID].present? && session[:NEW_HOUSEHOLD_MEMBER_ID].present?
		      	end # session[:HOUSEHOLD_ID].to_i == 0

				# Last Line in start_household_member_registration_wizard
				# Rails.logger.debug(" session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] in start registration method =  #{session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP]}")
				@household.current_step = session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP]
				l_records_per_page = SystemParam.get_pagination_records_per_page
				@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?

				# breadcrumbs management start
				@label_list = Household.new.step_headings
		        @step_list = Household.new.steps

		        # Manoj 02/08/2016 - Residential address should be present in breadcrumbs.
		        @label_list = @label_list.reject! {|item| item == "Residential address"}  #if session[:HOUSEHOLD_ID].present? && session[:HOUSEHOLD_ID].to_i != 0 && !(session[:OTHER_HOUSEHOLDS_WITH_SAME_ADDRESS_FOUND].present? && session[:OTHER_HOUSEHOLDS_WITH_SAME_ADDRESS_FOUND] == 'Y')
		        @step_list = @step_list.reject! {|item| item == "household_member_address_search_results_step"} #if session[:HOUSEHOLD_ID].present? && session[:HOUSEHOLD_ID].to_i != 0 && !(session[:OTHER_HOUSEHOLDS_WITH_SAME_ADDRESS_FOUND].present? && session[:OTHER_HOUSEHOLDS_WITH_SAME_ADDRESS_FOUND] == 'Y')

				client = Client.find(session[:CLIENT_ID]) if session[:CLIENT_ID].present?

		        @label_list = @label_list.reject! {|item| item == "Education"} if session[:CLIENT_ID].present? && (Client.is_adult(session[:CLIENT_ID]) == true)
		        @step_list = @step_list.reject! {|item| item == "household_member_education_step"} if session[:CLIENT_ID].present? && (Client.is_adult(session[:CLIENT_ID]) == true)

		        @label_list = @label_list.reject! {|item| item == "Employment assessment"} if session[:CLIENT_ID].present? && Client.is_child(session[:CLIENT_ID])
		        @step_list = @step_list.reject! {|item| item == "household_member_assessment_employment_step"} if session[:CLIENT_ID].present? && Client.is_child(session[:CLIENT_ID])


		        @label_list = @label_list.reject! {|item| item == "Employment"} if session[:CLIENT_ID].present? && Client.is_child(session[:CLIENT_ID]) && Employment.is_client_having_employment?(session[:CLIENT_ID].to_i) == false
		        @step_list = @step_list.reject! {|item| item == "household_member_employments_step"} if session[:CLIENT_ID].present? && Client.is_child(session[:CLIENT_ID])  && Employment.is_client_having_employment?(session[:CLIENT_ID].to_i) == false

        # breadcrumbs management end
        # Rails.logger.debug(" session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] in start registration last line =  #{session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP]}")
		end
	  rescue => err
	  	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","start_household_member_registration_wizard",err,current_user.uid)
	  	flash[:alert] = "Error ID: #{error_object.id} - Error occured in household composition step."
	  	# redirect_to_back
	  	redirect_to root_path

	end


#5.

	def process_household_member_registration_wizard
		# fail
		# Multi step form create - wizard --> start_household_member_registration_wizard's Next/Back button will come here
		#  Rule1 - Processing takes place only when "NEXT" button is clicked.
		#  Rule2 - When "BACK" button is clicked just navigate to previous step - NO PROCESSING needed.

		# Instantiate household objects
		if session[:CLIENT_ID].present?
				@client = Client.find(session[:CLIENT_ID].to_i)
				@client_email = ClientEmail.where("client_id = ?",@client.id).first
				if session[:HOUSEHOLD_ID].to_i == 0
					# fail
					@household = Household.new
				else
					# fail
					@household = Household.find(session[:HOUSEHOLD_ID].to_i)
					# @household_member = HouseholdMember.find(session[:NEW_HOUSEHOLD_MEMBER_ID].to_i)
					# @head_of_household_name = HouseholdMember.get_hoh_name(@household.id)
					hh_member_collection = HouseholdMember.get_household_member_collection(@household.id,@client.id)
					if hh_member_collection.present?
						@household_member = hh_member_collection.first
					end
				end
				@household.current_step = session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP]
				 # manage steps -start
		      	if params[:back_button].present?
		      		 @household.previous_step
		      	elsif @household.last_step?
		      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
		      	else
		           @household.next_step
		        end
		       session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
		       # manage steps -end


		       # breadcrumbs management start
				@label_list = Household.new.step_headings
		        @step_list = Household.new.steps

		        # Manoj 02/08/2016 - Residential address should be present in breadcrumbs.
		        @label_list = @label_list.reject! {|item| item == "Residential address"}  #if session[:HOUSEHOLD_ID].present? && session[:HOUSEHOLD_ID].to_i != 0 && !(session[:OTHER_HOUSEHOLDS_WITH_SAME_ADDRESS_FOUND].present? && session[:OTHER_HOUSEHOLDS_WITH_SAME_ADDRESS_FOUND] == 'Y')
		        @step_list = @step_list.reject! {|item| item == "household_member_address_search_results_step"} #if session[:HOUSEHOLD_ID].present? && session[:HOUSEHOLD_ID].to_i != 0 && !(session[:OTHER_HOUSEHOLDS_WITH_SAME_ADDRESS_FOUND].present? && session[:OTHER_HOUSEHOLDS_WITH_SAME_ADDRESS_FOUND] == 'Y')

				client = Client.find(session[:CLIENT_ID]) if session[:CLIENT_ID].present?

		        @label_list = @label_list.reject! {|item| item == "Education"} if session[:CLIENT_ID].present? && (Client.is_adult(session[:CLIENT_ID]) || client.dob.blank?)
		        @step_list = @step_list.reject! {|item| item == "household_member_education_step"} if session[:CLIENT_ID].present? && (Client.is_adult(session[:CLIENT_ID]) || client.dob.blank?)

		        @label_list = @label_list.reject! {|item| item == "Employment assessment"} if session[:CLIENT_ID].present? && Client.is_child(session[:CLIENT_ID])
		        @step_list = @step_list.reject! {|item| item == "household_member_assessment_employment_step"} if session[:CLIENT_ID].present? && Client.is_child(session[:CLIENT_ID])


		        @label_list = @label_list.reject! {|item| item == "Employment"} if session[:CLIENT_ID].present? && Client.is_child(session[:CLIENT_ID]) && Employment.is_client_having_employment?(session[:CLIENT_ID].to_i) == false
		        @step_list = @step_list.reject! {|item| item == "household_member_employments_step"} if session[:CLIENT_ID].present? && Client.is_child(session[:CLIENT_ID])  && Employment.is_client_having_employment?(session[:CLIENT_ID].to_i) == false


		        # breadcrumbs management end

		       # what step to process?
		       # Demographics step
		        if @household.get_process_object == "household_member_demographics_step" && params[:next_button].present?
		       	# fail
		       		# redirect_to start_household_member_registration_wizard_path
		       	# Address step
		       	elsif @household.get_process_object == "household_member_address_step" && params[:next_button].present?
		       		session[:BACK_BUTTON_FROM_CITIZENSHIP] = nil
		        	ls_message = "SUCCESS"
		       		if Address.get_entity_addresses(@client.id,6150).present?
		       			# Manoj 01/14/2016 - step completed logic start
		       			#  update second step as completed.
			  			# HouseholdMemberStepStatus.update_one_step_for_client(@client.id,2,'Y')
			  			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_address_step','Y')
			  			# Manoj 01/14/2016 - step completed logic end

		       			# RULE : IF SESSION[:HOUSEHOLD_ID] == 0 THEN ONLY ADDRESS SEARCH RESULTS WILL SHOW.
		       			#        MEANING THIS CLIENT IS NOT IN ANY HOUSEHOLD YET.
		       			#        IF CLIENT IS IN HOUSEHOLD - SEARCH RESULT WILL SHOW IT.
		       			#        IF YOU WANT TO ADD MEMBER TO HOUSEHOLD - SESSION[:HOUSEHOLD_ID] WILL BE THERE - AND HE ADDING MEMBER TO THE HOUSEHOLD MEANS SAME ADDRESS
		       			# Rule : IF CLIENT IS ALREADY IN HOUSEHOLD PROCEED TO CITIZENSHIP STEP.
		       			#        IF CLIENT IS NOT YET IN THE HOUSEHOLD THEN SHOW ADDRESS SEARCH RESULTS WITH OTHER HOUSEHOLDS, SO THAT HE CAN JOIN THAT HOUSEHOLD.
		       			#        gOAL :CREATING HOUSEHOLD FOR CLIENT
		       			# Address is saved.
		       			# Manoj 01/05/2016
		       			# Rules
		       			if session[:HOUSEHOLD_ID].to_i == 0
			       			 #  get residential address
			       			 residential_address_collection = Address.get_client_residential_addresses(@client.id)
			       			 if residential_address_collection.present?
			       			 	# fail
			       			 	res_addr_object = residential_address_collection.first
			       			 	@address_search_results_collection = Address.search_any_household_in_this_address(res_addr_object.id)
			       			 	if @address_search_results_collection.blank?
			       			 		# fail
			       			 		ls_message = create_household_and_initial_application(session[:CLIENT_ID].to_i)
			       			 		if ls_message == 'SUCCESS'
			       			 			session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_citizenship_step'
			       			 		else
			       			 			session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_address_step'
			       			 		end
			       			 		# session[:OTHER_HOUSEHOLDS_WITH_SAME_ADDRESS_FOUND] = nil
			       			 	else
			       			 		# OTHER HOUSEHOLDS WITH SAME ADDRESS FOUND - just take him to this step

			       			 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_address_search_results_step'

			       			 		# session[:OTHER_HOUSEHOLDS_WITH_SAME_ADDRESS_FOUND] = 'Y'
			       			 	end
			       			 else
			       			 	session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_citizenship_step'
			       			 # Bug commented by Manoj 03/03/2016
			       			 #  Household can be created only if residence address.
			       			 	# Homeless living arrangement scenario - where residential address is not there.
			       			 	# proceed with creating household & household member

			       			 	# ls_message = create_household_and_initial_application(@client.id)
			       			 	# if ls_message == 'SUCCESS'
			       			 	# 	session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_citizenship_step'
			       			 	# else
			       			 	# 	session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_address_step'
			       			 	# end
			       			 end
			       			 session[:CALLED_FROM_HOUSEHOLD_REGISTRATION_PAGE] = nil
			       		else
			       			# Add Household member scenario
			       			# household ID is there - just proceed to citizenship step
			       			session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_citizenship_step'
			       		end # end of session[:HOUSEHOLD_ID] == 0
		       			if ls_message != "SUCCESS"
		       			 	flash[:alert] = ls_message
		       			end
		       			# redirect_to start_household_member_registration_wizard_path
		       		else
		       			# go back to previous step and show flash message as error message
				 		@household.previous_step
				 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
				 		@household.errors[:base] << "Address is required to proceed to next step."
				 		render :start_household_member_registration_wizard
		       		end
		       	# citizenship step
		        elsif @household.get_process_object == "household_member_citizenship_step" && params[:next_button].present?
		       		if  @client.citizenship?
		       			# Manoj 01/14/2016 - step completed logic start
		       			#  update second step as completed.

			  			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_citizenship_step','Y')
			  			# Manoj 01/14/2016 - step completed logic end

		       			# Rule : Education step for child only
		       			# Logic to check education step for children (age < 18) only - if adult go back to Index Page.

		       			if @client.dob? && Client.is_adult(@client.id)
		       				# Manoj 01/14/2016 - step completed logic start
			       			#  update second step as completed.
				  			# HouseholdMemberStepStatus.update_one_step_for_client(@client.id,4,'Y')
				  			# HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_citizenship_step','Y')
				  			# Manoj 01/14/2016 - step completed logic end
				  			# Navigate to  Income step
				  			session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_employments_step'
		       			end
		       			# redirect_to start_household_member_registration_wizard_path
		       		else
		       			# go back to previous step and show flash message as error message
							@household.previous_step
							session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
							@household.errors[:base] << "Citizenship information is needed to proceed to next step."
							render :start_household_member_registration_wizard
					end

		       	elsif @household.get_process_object == "household_member_education_step" && params[:next_button].present?

		       		education_collection = Education.where("client_id = ?",@client.id)
		       		if  education_collection.present?
		       			# Manoj 01/14/2016 - step completed logic start
		       			#  update second step as completed.

			  			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_education_step','Y')
			  			# Manoj 01/14/2016 - step completed logic end
		       			# index with data
		       			if @household.member_education_add_flag != 'Y'
		       				@household.member_education_add_flag = 'Y'
			       			save_member_education_add_flag()
		       			end

		       			if @client.dob? && Client.is_child(@client.id)
		       				# child
		       				if Employment.is_client_having_employment?(session[:CLIENT_ID].to_i) == false
		       					session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_incomes_step'
		       				end
		       			end
		       			# redirect_to start_household_member_registration_wizard_path
		       			# redirect_to household_index_path
		       		else
		       			# index with no data
		       			if params[:household].present?
		       				# No questions answered
		       				if params[:household][:member_education_add_flag].present?
		       					ls_education_answer = params[:household][:member_education_add_flag]
			       				@household.member_education_add_flag = ls_education_answer
			       				save_member_education_add_flag()
			       				if ls_education_answer == 'Y'
			       					if education_collection.present?
			       						# Manoj 01/14/2016 - step completed logic start
						       			#  update second step as completed.

							  			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_education_step','Y')
							  			# Manoj 01/14/2016 - step completed logic end
							 			# redirect_to start_household_member_registration_wizard_path
							 			# redirect_to household_index_path
							 			if @client.dob? && Client.is_child(@client.id)
						       				# child
						       				if Employment.is_client_having_employment?(session[:CLIENT_ID].to_i) == false
						       					session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_incomes_step'
						       				end
						       			end
								 	else
								 		# go back to previous step and show flash message as error message
								 		@household.previous_step
								 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
								 		@household.errors[:base] << "Education information is needed to proceed to next step."
								 		render :start_household_member_registration_wizard
								 	end
			       				elsif ls_education_answer == 'N'
			       					# if ls_education_answer == 'N'
			       						# Manoj 01/14/2016 - step completed logic start
						       			#  update second step as completed.

							  			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_education_step','Y')
							  			# Manoj 01/14/2016 - step completed logic end
			       					# end
			       					# redirect_to start_household_member_registration_wizard_path
			       					 # redirect_to household_index_path
			       					if @client.dob? && Client.is_child(@client.id)
					       				# child
					       				if Employment.is_client_having_employment?(session[:CLIENT_ID].to_i) == false
					       					session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_incomes_step'
					       				end
					       			end
			       				elsif ls_education_answer == 'S'

			       					HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_education_step','S')
			       					# redirect_to start_household_member_registration_wizard_path
			       					if @client.dob? && Client.is_child(@client.id)
					       				# child
					       				if Employment.is_client_having_employment?(session[:CLIENT_ID].to_i) == false
					       					session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_incomes_step'
					       				end
					       			end
			       				end
		       				end
		       			else
		       				# go back to previous step and show flash message as error message
					 		@household.previous_step
					 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
					 		@household.errors[:base] << "Education question needs to be answered to proceed to next step."
					 		render :start_household_member_registration_wizard
		       			end
		       		end

		        elsif @household.get_process_object == "household_member_employments_step" && params[:next_button].present?
		        	 session[:BACK_BUTTON_FROM_ASSESSMENT] = nil
		        	@employments = Employment.employment_records_for_client(@client.id)
		        	if @employments.present?

		        		# employment_object = @employments.first
		        		# if employment_object.effective_begin_date.present?
		        		# 	if employment_object.effective_begin_date >= Date.today
		        		# 		# future employment yes/No
		        		# 		@client.job_offer_flag = 'Y'
		        		# 		@client.currently_working_flag = nil
		       			# 		@client.save
		        		# 	else
		        		# 		# current employment Yes/No
		        		# 		@client.currently_working_flag = 'Y'
		       			# 		@client.save
		        		# 	end
		        		# end
		        		# check_for_assessment_step_for_adult()
		       			# fail
		       			# earned_income_step_data_entry_checks()
		       			employment_step_data_entry_checks()
		        	else
		        		# Data is not there then he must have clicked radio button and clicked Next button
		        		if params[:household].present?
		        			# fail
		      				# questions answered
		       					ls_currently_working_answer = params[:household][:member_currently_working_flag]
		       					ls_job_offer_answer = params[:household][:member_job_offer_flag]
			       				@household.member_currently_working_flag = ls_currently_working_answer
			       				@household.member_job_offer_flag = ls_job_offer_answer

			       				if ls_currently_working_answer == 'N' && ls_job_offer_answer == 'N'
			       					# fail
			       					# save_member_income_add_flag()
			       					save_member_employment_question_flags()
			       					check_for_assessment_step_for_adult()

			       					# redirect_to start_household_member_registration_wizard_path

					       			if @client.dob? && Client.is_child(@client.id)
					       				# child
					       				if Employment.is_client_having_employment?(@client.id) == false
					       					session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_incomes_step'
					       				end
					       				redirect_to start_household_member_registration_wizard_path
					       			else
					       				redirect_to start_household_member_registration_wizard_path
					       			end
			       				else
			       					# fail
								 		# go back to previous step and show flash message as error message
								 		@household.previous_step
								 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
								 		@household.errors[:base] << "Employment information is needed to proceed to next step."
								 		render :start_household_member_registration_wizard
			       				end # end of ls_earned_income_answer == 'N'
		        		else
		        			# fail
		       				# No questions answered
		       				# go back to previous step and show flash message as error message
					 		@household.previous_step
					 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
					 		@household.errors[:base] << "Employment question needs to be answered to proceed to next step."
					 		render :start_household_member_registration_wizard
		        		end

		        	end

		        elsif @household.get_process_object == "household_member_incomes_step" && params[:next_button].present?
		        	# fail
		        	session[:MEMBER_FINANCE_STEP_PROCESS] = 'Y'
		        	# @client_income_collection = ClientIncome.where("client_id = ?",@client.id)
		        	@incomes = Income.earned_income_records(@client.id)
		       		if  @incomes.present?
		       			# fail
		       			@client.earned_income_flag = 'Y'
		       			@client.save

		       			# fail

		       			# if income type is salary/wages - then proceed to employment step else proceed to expenses step.
		       			# income_step_data_entry_checks()
		       			# check_for_assessment_step_for_adult()
		       			# fail
		       			earned_income_step_data_entry_checks()
		       			# redirect_to start_household_member_registration_wizard_path
		      #  			# Manoj 01/14/2016 - step completed logic start
		      #  			#  update second step as completed.

			  			# HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_incomes_step','Y')
			  			# # Manoj 01/14/2016 - step completed logic end
		       		else
		       			# fail
		       			# index with no data
		       			if params[:household].present?
		       				# fail
		      				# questions answered
		       					ls_earned_income_answer = params[:household][:member_earned_income_flag]
		       					# ls_job_offer_answer = params[:household][:member_job_offer_flag]
			       				@household.member_earned_income_flag = ls_earned_income_answer
			       				# @household.member_job_offer_flag = ls_job_offer_answer

			       				if ls_earned_income_answer == 'N' #&& ls_job_offer_answer == 'N'
			       					# fail
			       					save_member_income_add_flag()
			       					# check_for_assessment_step_for_adult()
			       					redirect_to start_household_member_registration_wizard_path
			       				else
			       					# fail
								 		# go back to previous step and show flash message as error message
								 		@household.previous_step
								 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
								 		@household.errors[:base] << "Income information is needed to proceed to next step."
								 		render :start_household_member_registration_wizard
			       				end # end of ls_earned_income_answer == 'N'
		       			else
		       				# fail
		       				# No questions answered
		       				# go back to previous step and show flash message as error message
					 		@household.previous_step
					 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
					 		@household.errors[:base] << "Income question needs to be answered to proceed to next step."
					 		render :start_household_member_registration_wizard
		       			end
		       		end
		       	elsif @household.get_process_object == "household_member_unearned_incomes_step" && params[:next_button].present?
		       		session[:MEMBER_FINANCE_STEP_PROCESS] = 'Y'
		       		lb_income_detail_record_found = nil
		       		ls_detail_msg = ' '
		       		@unearned_incomes = Income.unearned_income_records(@client.id)
		       		if @unearned_incomes.present?
		       			if @client.unearned_income_flag.present?
		       				if @client.unearned_income_flag != 'Y'
		       					@client.unearned_income_flag = 'Y'
		       		 			@client.save
		       				end
		       			else
		       				@client.unearned_income_flag = 'Y'
		       		 		@client.save
		       			end

		       			@household.member_unearned_income_flag = @client.unearned_income_flag

		       		 	lb_income_detail_record_found = true
		       		 	@unearned_incomes.each do |each_income_object|
		       		 		# check income detail record found for this income?
		       		 		if each_income_object.effective_beg_date.to_date <= Date.today
			       		 		income_details_collection = IncomeDetail.where("income_id = ?",each_income_object.id)
			       		 		if income_details_collection.blank?
			       		 			lb_income_detail_record_found = false
			       		 			ls_income_type = CodetableItem.get_short_description (each_income_object.incometype)
			       		 			ls_begin_date = each_income_object.effective_beg_date.strftime("%m/%d/%Y")
			       		 			ls_detail_msg = "Unearned income type: #{ls_income_type} with begin date: #{ls_begin_date.to_s}."
			       		 			break
			       		 		end
			       		 	end
		       		 	end
		       		 	if lb_income_detail_record_found == true
		       		 		# Both Income & Income detail records are there proceed to next step
		       		 		HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_unearned_incomes_step','Y')
		       		 		# redirect_to start_household_member_registration_wizard_path
		       		 	else
		       		 		@household.previous_step
							session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
							@household.errors[:base] << "Unearned income details information is not found for the unearned income record: #{ls_detail_msg}, unearned income details record is needed to proceed to next step."
							render :start_household_member_registration_wizard
							# redirect_to start_household_member_registration_wizard_path
		       		 	end
		       		else
		       		 	# did user answered any question when he clicked next button
		       		 	if params[:household].present?
		       		 		ls_unearned_income_answer = params[:household][:member_unearned_income_flag]
		       		 		@client.unearned_income_flag = ls_unearned_income_answer
		       		 		@client.save
		       		 		@household.member_unearned_income_flag = @client.unearned_income_flag

		       		 		if ls_unearned_income_answer == 'N'
		       		 			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_unearned_incomes_step','Y')
								# redirect_to start_household_member_registration_wizard_path
		       		 		else
		       		 			# Yes.
		       		 			@household.previous_step
								session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
								@household.errors[:base] << "Unearned income information is needed to proceed to next step."
								render :start_household_member_registration_wizard
		       		 		end
		       		 	else
		       		 		# question must be answered to proceed to next step
		       		 		@household.previous_step
						 	session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
						 	@household.errors[:base] << "Unearned income question needs to be answered to proceed to next step."
					 		render :start_household_member_registration_wizard
		       		 	end
		       		end

		       	elsif @household.get_process_object == "household_member_assessment_employment_step" && params[:next_button].present?
		       		# Rule :other than currently working Yes/No other assessment questions should be answered.
		       		client_assessment_object = ClientAssessment.where("client_id = ?",@client.id).first

		       		# step1 = ClientAssessmentAnswer.joins(" INNER JOIN assessment_questions
		       		# 	                                ON (client_assessment_answers.assessment_question_id = assessment_questions.id
		   						# 							and assessment_questions.assessment_sub_section_id = 2
		   						# 							)
		       		#                                     ")
		       		# step2 = step1.where("client_assessment_answers.client_assessment_id = ?
									  #    and assessment_questions.id not in (2,3,4)",client_assessment_object.id)
		       		# assessment_answer_collection = step2
		       		if ClientAssessmentAnswer.did_user_answer_any_employment_assessment_questions?(@client.id) == true
		       			# Manoj 01/14/2016 - step completed logic start
		       			#  update second step as completed.

			  			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_assessment_employment_step','Y')
			  			# Manoj 01/14/2016 - step completed logic end
		       			# fail
		       			# redirect_to start_household_member_registration_wizard_path
		       		else
		       			# fail
		       			li_sub_section_id = 2 #  working subsection
						@assessment_questions = AssessmentQuestion.get_questions_collection(li_sub_section_id) #
						@client_assessment_object = ClientAssessment.get_client_assessments(@client.id).first
		      			@client_assessment_answers = ClientAssessmentAnswer.get_answers_collection_for_assessment(@client_assessment_object.id)
		       			# go back to previous step and show flash message as error message
					 	@household.previous_step
					 	session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
					 	@household.errors[:base] << "Answer employment assessment questions to proceed to next step."
					 	render :start_household_member_registration_wizard
		       		end

		       	elsif @household.get_process_object == "household_member_expenses_step" && params[:next_button].present?
		       		session[:MEMBER_FINANCE_STEP_PROCESS] = 'Y'
		       		@expenses = @client.expenses
		       		if @expenses.present?
		       			session[:MEMBER_FINANCE_STEP_PROCESS] = 'Y'
		       			# Manoj 01/14/2016 - step completed logic start
		       			#  update second step as completed.

			  			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_expenses_step','Y')
			  			# Manoj 01/14/2016 - step completed logic end
		       			# index with data
		       			if @client.expense_add_flag.present?
		       				if @client.expense_add_flag != 'Y'
		       					@client.expense_add_flag = 'Y'
		       		 			@client.save
		       				end
		       			else
		       				@client.expense_add_flag = 'Y'
		       		 		@client.save
		       			end

		       			@household.member_expense_add_flag = 'Y'
		       			expense_step_data_entry_checks()
		       		else
		       			# index with no data
		       			if params[:household].present?
		       				# No questions answered
		       				# if params[:household][:member_expense_add_flag].present?
		       					ls_expense_answer = params[:household][:member_expense_add_flag]
			       				@household.member_expense_add_flag = ls_expense_answer


			       				@client.expense_add_flag = ls_expense_answer
			       				@client.save
			       				if ls_expense_answer == 'Y'
			       # 				if @expenses.present?
							 		# 	# redirect_to start_household_member_registration_wizard_path
							 		# 	expense_step_data_entry_checks()
								 	# else
								 		# go back to previous step and show flash message as error message
								 		@household.previous_step
								 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
								 		@household.errors[:base] << "Expense information is needed to proceed to next step."
								 		render :start_household_member_registration_wizard
								 	# end
			       				elsif ls_expense_answer == 'N'
			       					# if ls_expense_answer == 'N'
			       						# Manoj 01/14/2016 - step completed logic start
						       			#  update second step as completed.

							  			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_expenses_step','Y')
							  			# Manoj 01/14/2016 - step completed logic end
			       					# end
			       					# redirect_to start_household_member_registration_wizard_path
			       				elsif ls_expense_answer == 'S'

			       					HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_expenses_step','S')
			       					# redirect_to start_household_member_registration_wizard_path
			       				end
		       				# end
		       			else
		       				# go back to previous step and show flash message as error message
					 		@household.previous_step
					 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
					 		@household.errors[:base] << "Expense question needs to be answered to proceed to next step."
					 		render :start_household_member_registration_wizard
		       			end
		       		end

		       	elsif @household.get_process_object == "household_member_resources_step" && params[:next_button].present?
		       		session[:BACK_BUTTON_FROM_RELATIONSHIP] = nil
		       		session[:MEMBER_FINANCE_STEP_PROCESS] = 'Y'
		       		@resources = @client.shared_resources
		       		if @resources.present?
		       			# Manoj 01/14/2016 - step completed logic start
		       			#  update second step as completed.


			  			# Manoj 01/14/2016 - step completed logic end
		       			# index with data

		       			if @client.resource_add_flag.present?
		       				if @client.resource_add_flag != 'Y'
		       					@client.resource_add_flag = 'Y'
		       		 			@client.save
		       				end
		       			else
		       				@client.resource_add_flag = 'Y'
		       		 		@client.save
		       			end


		       			@household.member_resource_add_flag  = @client.resource_add_flag
		       			resource_step_data_entry_checks()
		       		else
		       			# fail
		       			# index with no data
		       			if params[:household].present?

		       				# No questions answered
		       				if params[:household][:member_resource_add_flag].present?

		       					ls_resource_answer = params[:household][:member_resource_add_flag]

			       				@household.member_resource_add_flag = ls_resource_answer
			       				@client.resource_add_flag = ls_resource_answer
			       				@client.save

			       				if ls_resource_answer == 'Y'
			       					# fail
			       # 					if  @resources.present?
							 		# 	# redirect_to start_household_member_registration_wizard_path
							 		# 	resource_step_data_entry_checks()
								 	# else
								 		# go back to previous step and show flash message as error message
								 		@household.previous_step
								 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
								 		@household.errors[:base] << "Resource information is needed to proceed to next step."
								 		render :start_household_member_registration_wizard
								 	# end
			       				elsif ls_resource_answer == 'N'
			       					# if ls_resource_answer == 'N'
				       					# Manoj 01/14/2016 - step completed logic start
						       			#  update second step as completed.

							  			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_resources_step','Y')
							  			# Manoj 01/14/2016 - step completed logic end
							  			# redirect_to start_household_member_registration_wizard_path
							  		# end

			       				elsif ls_resource_answer == 'S'

			       					HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_resources_step','S')
			       					# redirect_to start_household_member_registration_wizard_path
			       				end
		       				end
		       			else

		       				# go back to previous step and show flash message as error message
					 		@household.previous_step
					 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
					 		@household.errors[:base] << "Resource question needs to be answered to proceed to next step."
					 		render :start_household_member_registration_wizard
		       			end
		       		end
		        elsif @household.current_step == "household_member_relations_step" && params[:last_step_button].present?
		        	@client_relations = ClientRelationship.get_household_member_relationships(@household.id)
					household_members = HouseholdMember.where("household_id = ? and member_status = 6643",@household.id)
					if household_members.present?
						@household_members_count = household_members.size
					else
						@household_members_count = 0
					end
					if @household_members_count > 1
						# check if relations are added?
						l_members_count = household_members.size
						l_expected_relationship_count = l_members_count * (l_members_count - 1)
						l_db_relationship_count = @client_relations.size
						if  l_expected_relationship_count == l_db_relationship_count
							# update client steps - Manoj 01/14/2016 - start
							HouseholdMemberStepStatus.update_relationship_step_for_all_clients_in_household(@household.id)
							# update client steps - Manoj 01/14/2016 - end
							if session[:ADD_CLIENT_FROM_CLIENT_APPLICATION].present? &&  session[:ADD_CLIENT_FROM_CLIENT_APPLICATION] == "Y"
								session[:APPLICATION_PROCESSING_STEP] = 'application_processing_second'
								session[:ADD_CLIENT_FROM_CLIENT_APPLICATION] = "N"
								redirect_to start_application_processing_wizard_path
							else
								redirect_to household_index_path
							end
						else
							# go back to previous step and show flash message as error message
					 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_relations_step'
					 		@household.errors[:base] << "Relationship is not established between all members."
					 		render :start_household_member_registration_wizard
						end
					else
						redirect_to household_index_path
					end
		        else
		        	# fail
				# previous button is clicked.
				   session[:BACK_BUTTON_FROM_ASSESSMENT] = nil
			   	   session[:BACK_BUTTON_FROM_CITIZENSHIP] = nil
			   	   session[:BACK_BUTTON_FROM_RELATIONSHIP] = nil
			       session[:BACK_BUTTON_FROM_ADDRESS] = nil

				# fail
				# Rule - previous button from Citizenship should take to address step - not address search results step.
					# if @household.current_step == "household_member_address_search_results_step"
					if session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_address_search_results_step"
						session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_address_step'
					end

					#  Rule : education step only for kids - if previous button is clicked on employment - take adult to citizenship
					#         child to education step
					# if @household.current_step == "household_member_incomes_step"

					# fail
					if session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_education_step"
						# fail
						if @client.dob?
			       			if Client.is_adult(@client.id) == true
				       			# adult
						  		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_citizenship_step'
				       		end
		       			end
		       		end
		       		# fail
		       		#  Rule : Assessment step only for adults - if previous button is clicked on earned income  - take adult to Assessment step
					#         child to employment step
					# if @household.current_step == "household_member_unearned_incomes_step"
					if session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_assessment_employment_step"
						if @client.dob? && Client.is_child(@client.id)
		       				# child
		       				if Employment.is_client_having_employment?(session[:CLIENT_ID].to_i) == true
		       					# if child has employment
		       					session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_employments_step'
		       				else
		       					#  child no employment - take him to education
		       					session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_education_step'
		       				end
					    end
			       	end
					# redirect_to start_household_member_registration_wizard_path
			    end
			    unless performed?
			    	if session[:NAVIGATE_FROM].blank?
						redirect_to start_household_member_registration_wizard_path
					else
						navigate_back_to_called_page()
					end
			    end
		else
			redirect_to start_household_member_registration_wizard_path
		end
	  rescue => err
	  	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","process_household_member_registration_wizard",err,current_user.uid)
	  	flash[:alert] = "Error ID: #{error_object.id} - error occured when processing household composition."
	  	# redirect_to_back
	  	redirect_to start_household_member_registration_wizard_path
	end




# HOUSEHOLD MEMBER SEARCH ****************************START
#6.

	def new_household_member_search
		# fail
		#  Rule : Add Member - has to force user to first search if the member is already in the system. If he is not found then he can add new member.
		#         New member means = new client + same client_id added in hh_members against hh ID.
		# Rule : params[:household_id] = 0 means -HOH else members
		session[:HOUSEHOLD_ID] =  params[:household_id]

		@show_add_button = false
		@client = Client.new
 		# open custom search and Add member page - uses partials/search service methods.
 		if session[:HOUSEHOLD_ID].to_i == 0
 			@household = Household.new
 		else
 			@household = Household.find(session[:HOUSEHOLD_ID].to_i)
 		end

		render 'search_and_add_household_member'
	 rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","new_household_member_search",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - error when searching for household member."
	 	redirect_to_back
	end


#7.
	def household_member_search_results
		# fail
		#  new_member_search - method will call this action.
		# Call search service to search client.
		if session[:HOUSEHOLD_ID].to_i == 0
 			@household = Household.new
 		else
 			@household = Household.find(session[:HOUSEHOLD_ID].to_i)
 		end
		l_client_serach_service = SearchModule::ClientSearch.new
		# return_obj = l_client_serach_service.search(params)
		return_obj = l_client_serach_service.search_for_add_household_member(session[:HOUSEHOLD_ID].to_i,params)
	    if return_obj.class.name == "String"
	    	   # Manoj -09/17/2014
			    # Save SSN in session -so that if user decides to add new client for SSN he did not find - we can prepopulate that SSN.
			    populate_session_from_params(params)
			    # show result or error message.
	    	if return_obj == "No results found"
	    		@show_add_button = true
	    		@clients = nil
	    		render 'no_data_found_search_results'
	    	else
	    		# flash.now[:notice] = return_obj
	    		@household.errors[:base] = return_obj
	    		render 'search_and_add_household_member'
	    	end
	    else
	    	 # results found
	    	reset_pre_populate_session_variables()
	        @clients = return_obj
	        @show_add_button = false
	       # show result or error message.
	    	render 'search_and_add_household_member'
	    end

	 rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","household_member_search_results",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - error when searching client."
	 	redirect_to_back
	end

#8.
	def add_searched_client_into_current_household
		# the Add to household button on the search result will call this method.
		# client_id = params[:id].to_i
		# fail
		# Rails.logger.debug("session[:HOUSEHOLD_ID] in add_searched_client_into_current_household = #{session[:HOUSEHOLD_ID]}")

		if Client.receiving_benefit?(params[:id].to_i) == true
			# fail
			client_object = Client.find(params[:id].to_i)
			ls_error_message = "This Client: #{client_object.get_full_name} cannot be added to the current household because, he is already receiving benefit from another household."
			flash[:alert] = ls_error_message
			redirect_to household_index_path
		else
			# fail
			# a) Make searched client(say client1) status out of household from its current household say hh1.
			# b) add client1 into In focus Household (say household_focus) & make its status In household
			# c)update client1s entity_address so that its address reflects address of Household_in_focus.
			# d) add this client into pending application or create new application
			# e) add this client into application_member table of application.

			begin
				ActiveRecord::Base.transaction do

					# 2.Make searched client(say client1) status out of household from its current household say hh1.
					  if params[:household_id].to_i == 0
					  	# fail
					  else
					  	# fail
					  	old_hh_member_collection = HouseholdMember.where(" household_id = ? and client_id = ?",params[:household_id].to_i,params[:id].to_i)
					  	if old_hh_member_collection.present?
					  		old_hh_member_object = old_hh_member_collection.first
					  		old_hh_member_object.member_status = 6644 # out of household
					  		old_hh_member_object.end_date = Date.today # end date - when it is ended
					  		old_hh_member_object.save!
					  	end
					  end
					  # fail
					# 3.add client1 into In focus Household (say household_focus) & make its status In household
					@household_member_object = HouseholdMember.set_household_member_data(session[:HOUSEHOLD_ID].to_i,params[:id].to_i)
					@household_member_object.save!

					# 4.update client1s entity_address so that its address reflects address of Household_in_focus.
					old_hh_member_address_collection = EntityAddress.where("entity_type = 6150 and entity_id = ?",params[:id].to_i)
					if old_hh_member_address_collection.present?
						# end the current address & create address records of new household
						old_hh_member_address_collection.each do |each_old_entity_address_object|
							address_object = Address.find(each_old_entity_address_object.address_id)
							address_object.effective_end_date = Date.today
							address_object.save!
						end
						# add new address of current household
						current_hh_member_in_household_collection = HouseholdMember.where("household_id = ? and member_status = 6643",session[:HOUSEHOLD_ID].to_i).order("id ASC")
						if current_hh_member_in_household_collection.present?
							one_current_hh_member_in_household_object = current_hh_member_in_household_collection.first
							# does this current hh member have address
							current_hh_member_address_collection = EntityAddress.where("entity_type = 6150 and entity_id = ?",one_current_hh_member_in_household_object.client_id)
							if current_hh_member_address_collection.present?
								current_hh_member_address_collection.each do |each_entity_address_object|
									new_entrity_address_object = EntityAddress.new
									new_entrity_address_object.entity_type = 6150
									new_entrity_address_object.entity_id = params[:id].to_i
									new_entrity_address_object.address_id = each_entity_address_object.address_id
									new_entrity_address_object.save!
								end
							end
						end
					else
						# update current household's address to this new searched client
						# find one of the inhousehold member of current household
						current_hh_member_in_household_collection = HouseholdMember.where("household_id = ? and member_status = 6643",session[:HOUSEHOLD_ID].to_i).order("id ASC")
						if current_hh_member_in_household_collection.present?
							one_current_hh_member_in_household_object = current_hh_member_in_household_collection.first
							# does this current hh member have address
							current_hh_member_address_collection = EntityAddress.where("entity_type = 6150 and entity_id = ?",one_current_hh_member_in_household_object.client_id)
							if current_hh_member_address_collection.present?
								current_hh_member_address_collection.each do |each_entity_address_object|
									new_entrity_address_object = EntityAddress.new
									new_entrity_address_object.entity_type = 6150
									new_entrity_address_object.entity_id = params[:id].to_i
									new_entrity_address_object.address_id = each_entity_address_object.address_id
									new_entrity_address_object.save!
								end
							end
						end
					end
					# fail
					# 5.add this client into pending application or create new application

					not_disposed_application_collection = ClientApplication.where("household_id = ? and application_disposition_status is null",session[:HOUSEHOLD_ID].to_i).order("id DESC")
						if not_disposed_application_collection.present?
							# Rails.logger.debug("USE EXISTING APPLICATION -Not disposed APPLICATION FOUND")
							client_application_object = not_disposed_application_collection.first
						else
							# Rails.logger.debug("CREATE NEW APPLICATION ")
							client_application_object = ClientApplication.new
							client_application_object.application_date = Date.today
							client_application_object.application_status = 5942
							client_application_object.application_origin = 6025
							user_local_office_object = UserLocalOffice.where("user_id = ?",current_user.uid).order("id ASC").first
							client_application_object.application_received_office = user_local_office_object.local_office_id
							client_application_object.household_id = session[:HOUSEHOLD_ID].to_i
							client_application_object.save!

							# add it to queue
							 # 3. Add it to Queue - "Applications Queue" 6735
							 # create queue & task
							 #  1.Create queue
							common_action_argument_object = CommonEventManagementArgumentsStruct.new
							common_action_argument_object.event_id = 865 # Save Button -- event type for client application
							common_action_argument_object.queue_reference_type = 6587 # client application
							common_action_argument_object.queue_reference_id =  client_application_object.id
							common_action_argument_object.queue_worker_id = current_user.uid
							# for task
							common_action_argument_object.client_application_id =  client_application_object.id
							common_action_argument_object.client_id = params[:id].to_i
							# step2: call common method to process event.
							ls_msg = EventManagementService.process_event(common_action_argument_object)


						end
						session[:APPLICATION_ID] = client_application_object.id
						# Rails.logger.debug("session[:APPLICATION_ID] in add_searched_client_into_current_household = #{session[:APPLICATION_ID]}")

						# 4.create application member ( hh member) to this application
						# e) add this client into application_member table of application.
						application_member_object = ApplicationMember.set_application_member_data(client_application_object.id,params[:id].to_i)
						application_member_object.save!
					# end

				end # end of ActiveRecord::Base.transaction
				# All is well -proceed with after save activities.
				#01/14/2016 Manoj - step process - start
				# 1. populate steps to be completed table for this client.
				HouseholdMemberStepStatus.populate_all_steps_for_client(params[:id].to_i)
				# 2. update first step as completed.

				HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(params[:id].to_i,'household_member_demographics_step','Y')
				#01/14/2016 Manoj - step process - end
				# Manoj 01/14/2016 - start
				# update household_id to client_steps
				HouseholdMemberStepStatus.update_household_id_to_client_steps(params[:id].to_i,session[:HOUSEHOLD_ID].to_i)
				# Manoj 01/14/2016 - end



				ls_msg = "SUCCESS"
			rescue => err
					error_object = CommonUtil.write_to_attop_error_log_table("Household controller","new_household_member",err,current_user.uid)
					ls_msg = "Failed to create household and client application - for more details refer to error ID: #{error_object.id}."
			end
			@client = Client.find(params[:id].to_i)
			session[:CLIENT_ID] = @client.id
			# session[:NEW_HOUSEHOLD_MEMBER_ID] = @household_member_object.id
			# session[:HOUSEHOLD_MEMBER_ID] = @household_member_object.id
			flash[:notice] = "Client added to the current household successfully."
			reset_pre_populate_session_variables()
			if ls_msg != "SUCCESS"
				flash[:alert] = ls_msg
			else
				session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_citizenship_step'
			end
			redirect_to start_household_member_registration_wizard_path




			# # searched client ID is stored in session to be used in Add member page.
		 #  	session[:MODAL_TARGET_SELECTED_CLIENT_ID] = params[:id]
		 #  	# session[:NAVIGATED_FROM] = nil
		 #    # Navigate to new_member creation path.
		 #    # get household member
		 #    hh_member_collection = HouseholdMember.where("client_id = ? and member_status = 6643",params[:id].to_i)
		 #    if hh_member_collection.present?
		 #    	hh_member = hh_member_collection.first
		 #    	redirect_to new_household_member_path(hh_member.household_id)
		 #    else
		 #    	redirect_to new_household_member_path(0)
		 #    end

		end



	 rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","add_searched_client_into_current_household",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - error occured when selecting client."
	 	redirect_to_back

	end

# HOUSEHOLD MEMBER SEARCH ****************************END


# DEMOGRAPHICS ************************START**********************************************

#9.
	# Add member or HOH yes answer will call this action.
	def new_household_member
		session[:BACK_BUTTON_FROM_ADDRESS] = nil
		# action to add new members.
		@household_id = params[:household_id]
		# @client = Client.new
		# if session[:MODAL_TARGET_SELECTED_CLIENT_ID].present?
		# 	# If client made it to household member?
		# 	household_member_collection = HouseholdMember.where("client_id = ?",session[:MODAL_TARGET_SELECTED_CLIENT_ID].to_i)
		# 	if household_member_collection.present?
		# 		# Navigate him to that household of selected client
		# 		# adding client from one household to another needs to be addressed in different maintenance page.
		# 		household_member = HouseholdMember.where("client_id = ?",session[:MODAL_TARGET_SELECTED_CLIENT_ID].to_i).first
		# 		session[:NEW_HOUSEHOLD_ID] = household_member.household_id
		# 		# for INDEX session[:HOUSEHOLD_ID] is used.
		# 		session[:HOUSEHOLD_ID] = household_member.household_id
		# 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_demographics_step'
		# 		session[:NEW_HOUSEHOLD_MEMBER_ID] = household_member.id
		# 		session[:HOUSEHOLD_MEMBER_ID] = household_member.id
		# 		session[:CLIENT_ID] = session[:MODAL_TARGET_SELECTED_CLIENT_ID].to_i
	 #            # clear the session
	 #            session[:MODAL_TARGET_SELECTED_CLIENT_ID] = nil
	 #            redirect_to start_household_member_registration_wizard_path
		# 	else
		# 		# add this client to the current household and navigate to start_household_member_registration_wizard_path
		# 		create_household_member(session[:MODAL_TARGET_SELECTED_CLIENT_ID].to_i,session[:HOUSEHOLD_ID].to_i)
		# 		redirect_to start_household_member_registration_wizard_path
		# 	end
	 #    else
        	# member is not found in the system- so add client first and then add it to household_member table.
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
        	session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_demographics_step'
        # end
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","new_household_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - error when adding member."
		redirect_to_back
	end

#10.
	# Creating Clients - when search results are not found.
	def create_new_household_member
		# fail
		# Post method of new_member
		@household_id = params[:household_id].to_i
		if @household_id == 0
			@household = Household.new
			session[:HOUSEHOLD_ID] = 0
			# Rule: Household ID is not there First client in the household , so create only client

			@client = Client.new(client_params)
			@client.sves_status = 'S'
			if @client.valid?
				return_object = ClientDemographicsService.create_client(@client,params[:notes])
				if return_object.class.name == "String"
					# error
					flash[:alert] = return_object
					render :new_household_member
				else
					# success
					# @client.save
					#01/14/2016 Manoj - step process - start
			  		# 1. populate steps to be completed table for this client.
			  		HouseholdMemberStepStatus.populate_all_steps_for_client(@client.id)
			  		# 2. update first step as completed.

			  		HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_demographics_step','Y')
			  		#01/14/2016 Manoj - step process - end
			  		session[:CLIENT_ID] = @client.id
			  		# session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_demographics_step'
			  		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_address_step'
		  			reset_pre_populate_session_variables()
		  			flash[:notice] = "Client created successfully."
		  			redirect_to start_household_member_registration_wizard_path
				end
			else
				render :new_household_member
			end
		else
			# Rule: Household is there
			# 1. create Client
			# 2. create household member in that household
			# 3. CREATE NEW APPLICATION IF THERE IS NO PENDING ( NOT DISPOSED APPLICATION) FOUND, ELSE USE EXISTING PENDING APPLICATION.
			# 3. create application member
			session[:HOUSEHOLD_ID] = @household_id
			@client = Client.new(client_params)
			@client.sves_status = 'S'

			if @client.valid?
				begin
			    	ActiveRecord::Base.transaction do
			    		# 1.
			    		# @client.save!
			    		@client = ClientDemographicsService.create_client(@client,params[:notes])
			    		# 2.
			    		@household_member_object = HouseholdMember.set_household_member_data(@household_id,@client.id)
			    		@household_member_object.save!
			    		# 3.
			    		# if session[:APPLICATION_ID].present?
			    		# 	# Called from CLIENT APPLICATION MENU
			    		# 	application_member_object = ApplicationMember.set_application_member_data(session[:APPLICATION_ID].to_i,@client.id)
			    		# 	application_member_object.save!
			    		# else
			    			#
			    			not_disposed_application_collection = ClientApplication.where("household_id = ? and application_disposition_status is null",@household_id).order("id DESC")
							if not_disposed_application_collection.present?
								# Rails.logger.debug("USE EXISTING APPLICATION -Not disposed APPLICATION FOUND")
								client_application_object = not_disposed_application_collection.first
							else
								# Rails.logger.debug("CREATE NEW APPLICATION ")
								client_application_object = ClientApplication.new
								client_application_object.application_date = Date.today
								client_application_object.application_status = 5942
								client_application_object.application_origin = 6025
								user_local_office_object = UserLocalOffice.where("user_id = ?",current_user.uid).order("id ASC").first
								client_application_object.application_received_office = user_local_office_object.local_office_id
								client_application_object.household_id = @household_id
								client_application_object.save!

								# add it to queue
						    	 # 3. Add it to Queue - "Applications Queue" 6735
								 # create queue & task
								 #  1.Create queue
								common_action_argument_object = CommonEventManagementArgumentsStruct.new
								common_action_argument_object.event_id = 865 # Save Button -- event type for client application
					            common_action_argument_object.queue_reference_type = 6587 # client application
					            common_action_argument_object.queue_reference_id =  client_application_object.id
					            common_action_argument_object.queue_worker_id = current_user.uid
					            # for task
					            common_action_argument_object.client_application_id =  client_application_object.id
					            common_action_argument_object.client_id = @client.id
					            # step2: call common method to process event.
					            ls_msg = EventManagementService.process_event(common_action_argument_object)


							end
							session[:APPLICATION_ID] = client_application_object.id

							# 4.create application member ( hh member) to this application
							application_member_object = ApplicationMember.set_application_member_data(client_application_object.id,@client.id)
					    	application_member_object.save!
			    		# end

					end # end of ActiveRecord::Base.transaction
					# All is well -proceed with after save activities.
					#01/14/2016 Manoj - step process - start
			  		# 1. populate steps to be completed table for this client.
			  		HouseholdMemberStepStatus.populate_all_steps_for_client(@client.id)
			  		# 2. update first step as completed.

			  		HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_demographics_step','Y')
			  		#01/14/2016 Manoj - step process - end
			  		# Manoj 01/14/2016 - start
					# update household_id to client_steps
					HouseholdMemberStepStatus.update_household_id_to_client_steps(@client.id,@household_id)
					# Manoj 01/14/2016 - end


					session[:CLIENT_ID] = @client.id
					# session[:NEW_HOUSEHOLD_MEMBER_ID] = @household_member_object.id
					# session[:HOUSEHOLD_MEMBER_ID] = @household_member_object.id
					# session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_demographics_step'
					session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_address_step'
			  		flash[:notice] = "Client created successfully."
			  		reset_pre_populate_session_variables()
			  		ls_msg = "SUCCESS"
				rescue => err
						error_object = CommonUtil.write_to_attop_error_log_table("Household controller","new_household_member",err,current_user.uid)
						ls_msg = "Failed to create household and client application - for more details refer to error ID: #{error_object.id}."
				end
				if ls_msg != "SUCCESS"
					flash[:alert] = ls_msg
				end
				redirect_to start_household_member_registration_wizard_path
			else
				render :new_household_member
			end
		end
     rescue => err
		 # take the user to appropriate action and write error to table.
		 error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","create_new_household_member",err,current_user.uid)
		 flash[:alert] = "Error occured when creating household member, refere to error ID: #{error_object.id}."
		 redirect_to_back
	end

#11.

	def edit_household_member
		# find and show the record to be modified in edit.html
    	li_client_id = params[:client_id].to_i
  		@client = Client.find(li_client_id)
  		@notes =  nil
  	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","edit_household_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

#12.
	def update_household_member
		li_client_id = params[:client_id].to_i
    	@client = Client.find(li_client_id)

	  	# @notes = params[:notes]
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
			 	session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_demographics_step'
		  		redirect_to start_household_member_registration_wizard_path
			end
		else
		 	render :edit_household_member
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","update_household_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - error occured when updating household member."
		redirect_to_back
	end

# DEMOGRAPHICS ************************END**********************************************



#13.
# Manage Relationship calls this Action
	def edit_household_member_multiple_relationship
		session[:BACK_BUTTON_FROM_RELATIONSHIP] = 'Y'
		@household = Household.find(params[:household_id].to_i )
		session[:HOUSEHOLD_ID] = @household.id
		# session[:NEW_HOUSEHOLD_ID] = @household.id
		@client = Client.find(session[:CLIENT_ID].to_i)
		household_member_object = HouseholdMember.where("client_id = ? and household_id = ?",@client.id,@household.id).first
		# session[:HOUSEHOLD_MEMBER_ID] = household_member_object.id
		# session[:NEW_HOUSEHOLD_MEMBER_ID] = household_member_object.id
		@household_members_count = HouseholdMember.where("household_id = ? and member_status = 6643",@household.id).count


		# @head_of_household_name = HouseholdMember.get_hoh_name(params[:household_id].to_i)
		# Check at least Two household members are there to proceed.
		household_members = HouseholdMember.where("household_id = ? and member_status = 6643",@household.id)
		if household_members.size >= 2 then
			@client_multiple_relationships = ClientRelationship.prepare_household_member_relationship_data_one_direction(@household.id)
		else
			# flash[:alert] = "Minimum Two Household Members are needed to setup relationship between them"
			# redirect_to navigate_to_household_relations_path
			# redirect_to household_index_path
			session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_relations_step'
		 	@household.errors[:base] << "Minimum two household members are needed to setup relationship between them."
		 	render :start_household_member_registration_wizard
		end
	rescue => err
		# take the user to New action and write error to table.
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","edit_household_member_multiple_relationship",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - error occured when editing relationship."
		redirect_to_back
	end

#14.
	# Put action of  Manage Relationship .
	def update_household_member_multiple_relationship

		@household = Household.find(params[:household_id].to_i )
		# @head_of_household_name = HouseholdMember.get_hoh_name(params[:household_id].to_i)
		@household_members_count = HouseholdMember.where("household_id = ?",@household.id).count

		@client_multiple_relationships = ClientRelationship.prepare_household_member_relationship_data_one_direction(@household.id)
		# logger.debug("-->client_multiple_relationships = #{@client_multiple_relationships.inspect}")
		# fail
		l_params = multiple_relationships_params
		# logger.debug("-->l_params = #{l_params.inspect}")
		# fail
     	if all_relationships_populated_and_valid?(l_params)

     		@client_multiple_relationships = ClientRelationship.update_multiple_relationships_with_inverse_relation(l_params)
			msg = "SUCCESS"
     		@client_multiple_relationships.each do |arg_reln|
				if arg_reln.errors.any?
					msg = "FAIL"
					break
				end
			end
			if msg == "SUCCESS"
				flash[:notice] = "Household member relationships saved successfully."
				if session[:NAVIGATE_FROM].present?
					redirect_to session[:NAVIGATE_FROM]
				else
					# redirect_to navigate_to_household_relations_path
					session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_relations_step'
					redirect_to start_household_member_registration_wizard_path
				end
			else
				render 'edit_household_member_multiple_relationship'
			end
     	else

     		# @client_relationship_errors = ClientRelationship.new
     		# @client_relationship_errors.errors[:base] = "Relationship type is mandatory."
			li = 0
			@client_multiple_relationships.each do |arg_reln|
				l_hash = l_params[li]
				arg_reln.relationship_type = l_hash[:relationship_type]
				li = li + 1
			end
			# logger.debug "UPDATE - second-@client_multiple_relationships -inspect = #{@client_multiple_relationships.inspect}"
			render 'edit_household_member_multiple_relationship'
     	end
	rescue => err
		# take the user to New action and write error to table.
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","update_household_member_multiple_relationship",err,current_user.uid)
		# flash[:alert] = "Error ID: #{error_object.id} - Error when Creating Relationship."
		flash[:alert] = "Set up all the relationship between members."
		redirect_to_back
	end




# *********************************household memeber relationship end *********************************

# ************************* Assessment for not having earned income ***********************start********
#15.
	def edit_member_employment_assessment
		# fail
		@client = Client.find(params[:client_id].to_i)
		@client_assessment = ClientAssessment.find(params[:assessment_id].to_i)
		@assessment_id = @client_assessment.id
		@sub_section_id = params[:sub_section_id].to_i
		@assessment_questions = AssessmentQuestion.get_questions_collection(@sub_section_id)
		@common_assessment_answer_object = ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 2",@client_assessment.id).first
		session[:BACK_BUTTON_FROM_ASSESSMENT] = 'Y'
	rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdController","edit_member_employment_assessment",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Error occurred when managing assessment."
	 	# redirect_to_back
	 	session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_assessment_employment_step'
		redirect_to start_household_member_registration_wizard_path
	end

#16.
	def update_member_employment_assessment
		# fail
		li_sub_section_id = params[:sub_section_id]
		@client = Client.find(params[:client_id].to_i)
		@client_assessment = ClientAssessment.find(params[:assessment_id].to_i)
		@assessment_id = @client_assessment.id
		@sub_section_id = params[:sub_section_id].to_i
		@assessment_questions = AssessmentQuestion.get_questions_collection(@sub_section_id)
		@common_assessment_answer_object = ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 2",@client_assessment.id).first

			ret_message = AssessmentService.save_assessment_answer(@client_assessment.id,params,@assessment_questions)
			if ret_message == "SUCCESS"
				# session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_assessment_employment_step'
				session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_incomes_step'
				redirect_to start_household_member_registration_wizard_path

			else
				 flash[:notice] = "Failed to save assessment data."
				 render 'edit_member_employment_assessment'
				 # redirect_to edit_common_assessment_path(li_sub_section_id,@assessment_id)
			end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdController","update_member_employment_assessment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - error occurred when saving assessment."
		# redirect_to_back
		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_assessment_employment_step'
		redirect_to start_household_member_registration_wizard_path

	end

	# ************************* Assessment for not having earned income ***********************END********



#  Not Used Now - may be needed - not finalised how to handle Complete Household registration process.
#16.
	# def complete_household_registration
	# 	# fail
	# 	@household = Household.find(params[:household_id].to_i)
	# 	household_members = HouseholdMember.get_all_members_with_in_household_status(@household.id)
	# 	client_applications_collection = ClientApplication.where("household_id = ?",@household.id).order("id ASC")
	# 		if client_applications_collection.present?
	# 			# fail
	# 			client_application_object = client_applications_collection.first
	# 			populate_application_members(session[:HOUSEHOLD_ID].to_i,client_application_object.id)
	# 			# if ls_return_message == "SUCCESS"
	# 				# fail
	# 				# 4. run application screening & # navigate to application screening
	# 				# flash[:notice] = "Benefit application created successfully "
	# 				session[:APPLICATION_ID] = client_application_object.id
	# 				# redirect_to view_screening_summary_path(session[:INITIAL_APPLICATION_ID].to_i)

	# 				# Move to Ready for Application processing queue
	# 				# complete applications task
	# 				# create work on Application processing task
	# 				# step1 : Populate common event management argument structure
	# 				common_action_argument_object = CommonEventManagementArgumentsStruct.new
	# 				common_action_argument_object.event_id = 309 # Save Button
	# 	            common_action_argument_object.queue_reference_type = 6587 # client application
	# 	            common_action_argument_object.queue_reference_id = client_application_object.id
	# 	            common_action_argument_object.queue_worker_id = current_user.uid
	# 	            # for task
	# 	            common_action_argument_object.client_application_id = client_application_object.id
	# 	            common_action_argument_object.client_id = session[:CLIENT_ID].to_i
	# 	            # step2: call common method to process event.
	# 	            ls_return_message = EventManagementService.process_event(common_action_argument_object)
	# 	            if ls_return_message == "SUCCESS"
	# 	            	session[:APPLICATION_PROCESSING_STEP] = nil
	# 	            	redirect_to start_application_processing_wizard_path
	# 	            else
	# 	            	flash[:alert] = ls_return_message
	# 					redirect_to household_index_path
	# 	            end
	# 			# else
	# 			# 	# fail
	# 			# 	flash[:alert] = ls_return_message
	# 			# 	redirect_to household_index_path
	# 			# end
	# 		else
	# 			# fail
	# 			flash[:alert] = "Application ID not found for this household to proceed.."
	# 			redirect_to household_index_path
	# 		end

	# end


#17.
#  This action is called from 'Continue from where you left' link
	def navigate_to_first_skiped_step
		# fail
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		@client = Client.find(params[:client_id].to_i)
		@household_member = nil
		hh_member_collection = HouseholdMember.get_household_member_collection(@household.id,@client.id)
		if hh_member_collection.present?
			@household_member = hh_member_collection.first
		end
		session[:CLIENT_ID] = @client.id
		# get the first partial for which step is incomplete.
		ls_first_incomplete_step = HouseholdMemberStepStatus.get_first_incomplete_step_for_client(@client.id,@household.id)
		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = "#{ls_first_incomplete_step}"
		# fail
		redirect_to start_household_member_registration_wizard_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","edit_household_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error occured when showing household member, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end

# 18. This is called from add client to household address link
	def add_client_to_selected_household_address
		# fail
		#  Rules
		# 1. create household member
		create_household_member(params[:client_id].to_i,params[:household_id].to_i)

		# 1.1 update selected households residential address to the new client.
		EntityAddress.update_residential_address_id_with_household_res_address_id(params[:client_id].to_i,params[:address_id].to_i)

		# 2 client can be added in the system with supporting application
		save_client_application_and_app_member(params[:household_id].to_i,params[:client_id].to_i)



		# 3. update household id and household member session variables.
		# session[:NEW_HOUSEHOLD_ID] = params[:household_id].to_i
	   	session[:HOUSEHOLD_ID] = params[:household_id].to_i

		# 3. proceed to next step.
		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_citizenship_step'
		redirect_to start_household_member_registration_wizard_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdsController","add_client_to_selected_household_address",err,current_user.uid)
		flash[:alert] = "Error occured when adding client to the household, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end


#19. This action is used to create another household when client chooses to create separate household even when system finds another household in the same address.
	def create_new_household_after_address_search
		ls_message = create_household_and_initial_application(params[:client_id].to_i)
		#Rails.logger.debug("ls_message = #{ls_message.inspect}")
		#Rails.logger.debug("ls_message = #{ls_message.class.inspect}")
		if ls_message != "SUCCESS"
			flash[:alert] = ls_message
		end
		redirect_to start_household_member_registration_wizard_path
	end



	private

	# 1.
		def create_household_and_initial_application(arg_client_id)
			client_object = Client.find(arg_client_id)
			# 1. create Household
			household_object = Household.new
			household_object.name = client_object.last_name

			# 2. create household member

			household_member = HouseholdMember.new
			household_member.client_id = client_object.id
			household_member.member_status = 6643 # IN HOUSEHOLD STATUS
			household_member.start_date = Date.today

			client_application_object = nil






			ls_msg = "SUCCESS"
			begin
			    ActiveRecord::Base.transaction do
			    	# 1.
			    	household_object.save!

			    	household_member.household_id = household_object.id
			    	# 2.
			    	household_member.save!

			    	# 3.
			    	# 3. create new application
					# create_application(session[:HOUSEHOLD_ID].to_i)
					# Find if there is any pending application found - if found use it.
					not_disposed_application_collection = ClientApplication.where("household_id = ? and application_disposition_status is null",household_object.id).order("id DESC")

					if not_disposed_application_collection.present?
						# Rails.logger.debug("USE EXISTING APPLICATION -Not disposed APPLICATION FOUND")
						client_application_object = not_disposed_application_collection.first
					else
						# Rails.logger.debug("CREATE NEW APPLICATION ")
						client_application_object = ClientApplication.new
						client_application_object.application_date = Date.today
						client_application_object.application_status = 5942
						client_application_object.application_origin = 6025
						user_local_office_object = UserLocalOffice.where("user_id = ?",current_user.uid).order("id ASC").first
						client_application_object.application_received_office = user_local_office_object.local_office_id
						client_application_object.household_id = household_object.id
						client_application_object.save!
					end


					# 4.create application member ( hh member) to this application
					application_member_object = ApplicationMember.set_application_member_data(client_application_object.id,client_object.id)
			    	application_member_object.save!
			    	# add it to queue
			    	 # 3. Add it to Queue - "Applications Queue" 6735
					 # create queue & task
					 #  1.Create queue
					common_action_argument_object = CommonEventManagementArgumentsStruct.new
					common_action_argument_object.event_id = 865 # Save Button -- event type for client application
		            common_action_argument_object.queue_reference_type = 6587 # client application
		            common_action_argument_object.queue_reference_id =  client_application_object.id
		            common_action_argument_object.queue_worker_id = current_user.uid
		            # for task
		            common_action_argument_object.client_application_id =  client_application_object.id
		            common_action_argument_object.client_id = client_object.id
		            # step2: call common method to process event.
		            ls_msg = EventManagementService.process_event(common_action_argument_object)

			    end # end of ActiveRecord::Base.transaction
			    # All is well - proceed to populate sessions
			    # session[:NEW_HOUSEHOLD_ID] = household_object.id
	   			session[:HOUSEHOLD_ID] = household_object.id
			    session[:APPLICATION_ID] = client_application_object.id
			    # session[:NEW_HOUSEHOLD_MEMBER_ID] = household_member.id
				# session[:HOUSEHOLD_MEMBER_ID] = household_member.id
				# Manoj 01/14/2016 - start
				# update household_id to client_steps
				HouseholdMemberStepStatus.update_household_id_to_client_steps(client_object.id,household_object.id)
				# Manoj 01/14/2016 - end
			    # 5. proceed to next step.
				# 5. Navigate to citizenship step
				session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_citizenship_step'
			rescue => err
			    error_object = CommonUtil.write_to_attop_error_log_table("Household controller","create_household_and_initial_application",err,current_user.uid)
			    ls_msg = "Failed to create household and client application - for more details refer to error ID: #{error_object.id}."
			end

			return ls_msg
		end


	# 2.
		def save_client_application_and_app_member(arg_household_id,arg_client_id)
			client_application_object = nil
			not_disposed_application_collection = ClientApplication.where("household_id = ? and application_disposition_status is null",arg_household_id).order("id DESC")
			if not_disposed_application_collection.present?
				Rails.logger.debug("USE EXISTING APPLICATION -Not disposed APPLICATION FOUND")
				client_application_object = not_disposed_application_collection.first
			else
				Rails.logger.debug("CREATE NEW APPLICATION ")
				client_application_object = ClientApplication.new
				client_application_object.application_date = Date.today
				client_application_object.application_status = 5942
				client_application_object.application_origin = 6025
				user_local_office_object = UserLocalOffice.where("user_id = ?",current_user.uid).order("id ASC").first
				client_application_object.application_received_office = user_local_office_object.local_office_id
				client_application_object.household_id = arg_household_id
				client_application_object.save

				# add it to queue
		    	 # 3. Add it to Queue - "Applications Queue" 6735
				 # create queue & task
				 #  1.Create queue
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
				common_action_argument_object.event_id = 865 # Save Button -- event type for client application
	            common_action_argument_object.queue_reference_type = 6587 # client application
	            common_action_argument_object.queue_reference_id =  client_application_object.id
	            common_action_argument_object.queue_worker_id = current_user.uid
	            # for task
	            common_action_argument_object.client_application_id =  client_application_object.id
	            common_action_argument_object.client_id = arg_client_id
	            # step2: call common method to process event.
	            ls_msg = EventManagementService.process_event(common_action_argument_object)

			end
			session[:APPLICATION_ID] = client_application_object.id
			# Rails.logger.debug("client_application_object = #{client_application_object.inspect}")

			# 4.create application member ( hh member) to this application
			application_member_object = ApplicationMember.set_application_member_data(client_application_object.id,arg_client_id)
			application_member_object.save
		end


	# 2.

		def create_household_member(arg_client_id,arg_household_id)
			household_member = HouseholdMember.set_household_member_data(arg_household_id,arg_client_id)
			household_member.save
			# session[:NEW_HOUSEHOLD_MEMBER_ID] = household_member.id
			# session[:HOUSEHOLD_MEMBER_ID] = household_member.id

			# Manoj 01/14/2016 - start
			# update household_id to client_steps
			HouseholdMemberStepStatus.update_household_id_to_client_steps(arg_client_id,arg_household_id)
			# Manoj 01/14/2016 - end
			if session[:APPLICATION_ID].present?
				application_member_object = ApplicationMember.set_application_member_data(session[:APPLICATION_ID].to_i,arg_client_id)
				application_member_object.save
			end
		end



	# 3

		def client_params
			params.require(:client).permit(:first_name, :middle_name,:last_name,:suffix,:ssn,:ssn_not_found,:dob,:gender,:marital_status,:primary_language,:ssn_enumeration_type,:identification_type,:veteran_flag,:other_identification_document,:felon_flag,:rcvd_tea_out_of_state_flag,:register_to_vote_flag)
  		end

  	# 4

  		def client_update_params
			params.require(:client).permit(:first_name, :middle_name,:last_name,:suffix,:ssn,:ssn_not_found,:dob,:gender,:marital_status,:primary_language,:death_date,:ssn_enumeration_type,:identification_type,:veteran_flag,:other_identification_document,:felon_flag,:rcvd_tea_out_of_state_flag,:register_to_vote_flag)
	  	end

    #5.
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

	#6.
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

    #7.
	  	def strip_spaces_and_downcase(arg_string)
			return arg_string.strip.downcase
		end

	#8.
	# def save_member_citizenship_add_flag
	# 	if @household.member_citizenship_add_flag.present?
	# 		@household_member.citizenship_add_flag = @household.member_citizenship_add_flag
	# 		@household_member.save
	# 	end
	# end


   #9.
	# hh member relations start

	# Allowing Arrays through STRONG PARAMETER
#   	[{number:"1234",client_id:"11"},{{number:"1235",client_id:"11"}},{{number:"1444",client_id:"11"}}]
#   	we have to reach the hash inside Array and permit them.

  	 def multiple_relationships_params
	  params.require(:relationships).map do |p|
	     ActionController::Parameters.new(p.to_hash).permit(:relationship_type,:from_client_id,:to_client_id,:update_flag)
	   end
	end

	#10.
	def all_relationship_types_populated?(arg_params)
			l_return = true
			arg_params.each do |arg_param|
				if arg_param[:relationship_type].blank?
					l_return = false
					break
				end
			end
			return l_return
	end

	def all_relationships_populated_and_valid?(arg_params)
		result = true
		@client_relationship_errors = ClientRelationship.new
		arg_params.each do |arg_param|
			if arg_param[:relationship_type].blank? && !(@client_relationship_errors.errors[:base].include?("Relationship type is mandatory."))
				@client_relationship_errors.errors[:base] << "Relationship type is mandatory."
				result = false
			end
			if [5962,6014,5977,6009,5973,5972,5969,5968,5965,5964].include?(arg_param[:relationship_type].to_i)
				from_client_id = arg_param[:from_client_id].to_i
				to_client_id = arg_param[:to_client_id].to_i

				case arg_param[:relationship_type].to_i
				when 5962,5977,5973,5969,5965
					if Client.get_age(from_client_id) > Client.get_age(to_client_id)
						@client_relationship_errors.errors[:base] << "#{Client.get_client_full_name_from_client_id(from_client_id)} should not be elder than #{Client.get_client_full_name_from_client_id(to_client_id)}"
						result = false
					end
				else
					if Client.get_age(from_client_id) < Client.get_age(to_client_id)
						@client_relationship_errors.errors[:base] << "#{Client.get_client_full_name_from_client_id(to_client_id)} should not be elder than #{Client.get_client_full_name_from_client_id(from_client_id)}"
						result = false
					end
				end
			end
		end
		return result
	end

	# hh member relations end

	# hh member education start

    #11.
	def save_member_education_add_flag
		if @household.member_education_add_flag.present?
			@client.education_add_flag = @household.member_education_add_flag
			@client.save
		end
	end

	# hh member education end

    #12.
	# income /income details start
	def save_member_income_add_flag()
		if @household.member_earned_income_flag.present? #|| @household.member_job_offer_flag.present?
			if @household.member_earned_income_flag.present?
				@client.earned_income_flag = @household.member_earned_income_flag
				@client.save
				if @household.member_earned_income_flag == 'N'
					# Manoj 01/14/2016 - step completed logic start
       				#  update second step as completed.

	  				HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_incomes_step','Y')
	  				# Manoj 01/14/2016 - step completed logic end
				end
			end

			# if @household.member_job_offer_flag.present?
			# 	@client.job_offer_flag = @household.member_job_offer_flag
			# 	@client.save
			# 	if @household.member_job_offer_flag == 'N'
			# 		# Manoj 01/14/2016 - step completed logic start
   #     				#  update second step as completed.

	  # 				HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_incomes_step','Y')
	  # 				# Manoj 01/14/2016 - step completed logic end
			# 	end
			# end

		end
	end

	def save_member_employment_question_flags()
		if @household.member_currently_working_flag.present? || @household.member_job_offer_flag.present?
			if @household.member_currently_working_flag.present?
				@client.currently_working_flag = @household.member_currently_working_flag
				@client.save
				if @household.member_currently_working_flag == 'N'
					# Manoj 01/14/2016 - step completed logic start
       				#  update second step as completed.

	  				HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_employments_step','Y')
	  				# Manoj 01/14/2016 - step completed logic end
				end
			end

			if @household.member_job_offer_flag.present?
				@client.job_offer_flag = @household.member_job_offer_flag
				@client.save
				if @household.member_job_offer_flag == 'N'
					# Manoj 01/14/2016 - step completed logic start
       				#  update second step as completed.

	  				HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_employments_step','Y')
	  				# Manoj 01/14/2016 - step completed logic end
				end
			end

		end




	end



	# 20.
	def earned_income_step_data_entry_checks()
		# fail
			lb_income_detail_record_found = nil
			# lb_employment_detail_record_found = nil
			# lb_employment_record_found = nil
			li_income_id = 0

	   		ls_detail_msg = ' '
	   		earned_incomes = Income.earned_income_records(@client.id)
   		# if earned_incomes.present?
   		 	lb_income_detail_record_found = true
   		 	# income detail check
   		 	earned_incomes.each do |each_income_object|
   		 		# check income detail record found for this income that has abegin date less than are equal to today?
   		 		if each_income_object.effective_beg_date.to_date <= Date.today
	   		 		income_details_collection = IncomeDetail.where("income_id = ?",each_income_object.id)
	   		 		if income_details_collection.blank?
	   		 			# fail
	   		 			lb_income_detail_record_found = false
	   		 			ls_income_type = CodetableItem.get_short_description (each_income_object.incometype)
	   		 			ls_begin_date = each_income_object.effective_beg_date.strftime("%m/%d/%Y")
	   		 			ls_detail_msg = "Income type: #{ls_income_type} with begin date: #{ls_begin_date.to_s}."
	   		 			break
	   		 		end
	   		 	end
   		 	end
   		 	# Rails.logger.debug("lb_income_detail_record_found = #{lb_income_detail_record_found}")
   		 	# fail

   		 	if lb_income_detail_record_found == false
   		 		# fail
   		 		@household.previous_step
				session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
				@household.errors[:base] << "Earned income details information is not found for the income record: #{ls_detail_msg}, income details record is needed to proceed to next step."
				render :start_household_member_registration_wizard
   		 	else
   		 		# fail
   		 		# Manoj 01/14/2016 - step completed logic start
		       	#  update second step as completed.
	  			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_incomes_step','Y')
	  			# Manoj 01/14/2016 - step completed logic end
 				redirect_to start_household_member_registration_wizard_path
 			end

	end

   		 		# income details are found for all income records.check for employment for these incomes.
   		 		# lb_employment_record_found = true
   		 		# lb_employment_detail_record_found = true

   		 		# salary_earned_incomes = Income.earned_income_records_with_salary_type_incomes(@client.id)

   		 		# salary_earned_incomes.each do |each_income_object|
   		 		# 	if each_income_object.employment_id.blank?
   		 		# 		lb_employment_record_found = false
   		 		# 		ls_income_type = CodetableItem.get_short_description (each_income_object.incometype)
   		 		# 		ls_begin_date = each_income_object.effective_beg_date.strftime("%m/%d/%Y")
   		 		# 		ls_detail_msg = "income type: #{ls_income_type} with begin date: #{ls_begin_date.to_s}"
   		 		# 		break
   		 		# 	else
   		 		# 		# check if employment details is populated
   		 		# 		employment_detail_collection = EmploymentDetail.where("employment_id = ?",each_income_object.employment_id)
   		 		# 		if employment_detail_collection.blank?
   		 		# 			li_income_id = each_income_object.id
   		 		# 			lb_employment_detail_record_found = false
   		 		# 			break
   		 		# 		end
   		 		# 	end
   		 		# end
   		 		# fail

   		#  		if  lb_employment_record_found == false
   		#  			# fail
   		#  			@household.previous_step
					# session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
					# @household.errors[:base] << "Employment information is not found for the income record: #{ls_detail_msg},When income type is salary then Employment detaisls information is mandatory."
					# render :start_household_member_registration_wizard
   		#  		else
   		#  			# fail
   		#  			if  lb_employment_detail_record_found == false
   		#  				@household.previous_step
					# 	session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
   		#  				flash[:alert] = "When income type is salary then Employment detaisls information is mandatory."
		 		# 		redirect_to show_household_member_income_path(@client.id,li_income_id)
		 		# 	else
		 		# 		# Manoj 01/14/2016 - step completed logic start
		   #     			#  update second step as completed.

			  # 			HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_incomes_step','Y')
			  # 			# Manoj 01/14/2016 - step completed logic end
		 		# 		redirect_to start_household_member_registration_wizard_path
		 		# 	end
   		#  		end
   		 		# fail




	def employment_step_data_entry_checks()

		# Manoj 01/29/2015
		ls_detail_msg = ' '
		lb_employment_detail_record_found = true
		@employments.each do |each_employment_object|
	 		# check income detail record found for this income?
	 		employment_details_collection = EmploymentDetail.where("employment_id = ?",each_employment_object.id)
	 		if employment_details_collection.blank?
	 			employer_object = Employer.find(each_employment_object.employer_id)
	 			lb_employment_detail_record_found = false
	 			ls_begin_date = each_employment_object.effective_begin_date.strftime("%m/%d/%Y")
	 			ls_detail_msg = "Employer: #{employer_object.employer_name} with begin date: #{ls_begin_date.to_s}"
	 			break
	 		end
       	end

       	if lb_employment_detail_record_found == true
	 		# Both expense & expense detail records are there proceed to next step
	 		# redirect_to start_household_member_registration_wizard_path

   			if @client.dob? && Client.is_child(@client.id)
   				# child - no assessment - so jump to earned income
   				session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_incomes_step'
   				redirect_to start_household_member_registration_wizard_path
   			else
   				redirect_to start_household_member_registration_wizard_path
   			end
	 	else
	 		@household.previous_step
			session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
			@household.errors[:base] << "Employment details information is not found for the employment record with #{ls_detail_msg}, employment detail record is needed to proceed to next step."
			render :start_household_member_registration_wizard
			# redirect_to start_household_member_registration_wizard_path
	 	end


	end


	# Expense methods
	#14.
	# def save_member_expense_add_flag()
	# 	if @household.member_expense_add_flag.present?
	# 		@client.expense_add_flag = @household.member_income_add_flag
	# 		@client.save

	# 	end
	# end

	#15.
	# def save_member_resource_add_flag()
	# 	if @household.member_resource_add_flag.present?
	# 		@client.resource_add_flag = @household.member_resource_add_flag
	# 		@client.save

	# 	end
	# end

	#16.
	def expense_step_data_entry_checks()

		# Manoj 01/29/2015
		ls_detail_msg = ' '
		lb_expense_detail_record_found = true
		@expenses.each do |each_expense_object|
	 		# check income detail record found for this income?
	 		if each_expense_object.effective_beg_date.present? && each_expense_object.effective_beg_date <= Date.today
		 		expense_details_collection = ExpenseDetail.where("expense_id = ?",each_expense_object.id)
		 		if expense_details_collection.blank?
		 			lb_expense_detail_record_found = false
		 			ls_expense_type = CodetableItem.get_short_description (each_expense_object.expensetype)
		 			ls_begin_date = each_expense_object.effective_beg_date.strftime("%m/%d/%Y")
		 			ls_detail_msg = "Expense type: #{ls_expense_type} with begin date: #{ls_begin_date.to_s}."
		 			break
		 		end
	 		end
       	end

       	if lb_expense_detail_record_found == true
	 		# Both expense & expense detail records are there proceed to next step
	 		redirect_to start_household_member_registration_wizard_path
	 	else
	 		@household.previous_step
			session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
			@household.errors[:base] << "Expense details information is not found for the expense record: #{ls_detail_msg}, expense details record is needed to proceed to next step."
			render :start_household_member_registration_wizard
			# redirect_to start_household_member_registration_wizard_path
	 	end


	end

	#17.
	def resource_step_data_entry_checks()
		# fail
		# latest expense record.
		# latest_resource_collection = Resource.get_latest_resource_record_collection(@client.id)
		# latest_resource_object = latest_resource_collection.first
		# # Expense details is mandatory
		# if ResourceDetail.where("resource_id = ?",latest_resource_object.id).present?
		# 		# # Navigate to next step

		# 		redirect_to start_household_member_registration_wizard_path

		# else
		# 	# go back to previous step and show flash message as error message
	 # 		# @household.previous_step
	 # 		session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
	 # 		@household.errors[:base] << "Resource detail information for resource is needed to proceed to next step."
	 # 		render :start_household_member_registration_wizard
		# end


		# Manoj 01/29/2016
		ls_detail_msg = ' '
		lb_resource_detail_record_found = true
		@resources.each do |each_resource_object|
       		# check resource detail record found for this resource?
       		if each_resource_object.date_assert_acquired.present? && each_resource_object.date_assert_acquired <= Date.today
		 		resource_details_collection = ResourceDetail.where("resource_id = ?",each_resource_object.id)
		 		if resource_details_collection.blank?
		 			lb_resource_detail_record_found = false
		 			ls_resource_type = CodetableItem.get_short_description (each_resource_object.resource_type)
		 			ls_date_resource_aquired = each_resource_object.date_assert_acquired.strftime("%m/%d/%Y")
		 			ls_detail_msg = "Resource type: #{ls_resource_type} with resource aquired date: #{ls_date_resource_aquired.to_s}."
		 			break
		 		end
		 	end
	 	end

	 	if lb_resource_detail_record_found == true
	 		# Both Income & Income detail records are there proceed to next step
	 		HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_resources_step','Y')
	 		redirect_to start_household_member_registration_wizard_path
	 	else
	 		@household.previous_step
			session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = @household.current_step
			@household.errors[:base] << "Resource details information is not found for the resource record: #{ls_detail_msg}, resource details record is needed to proceed to next step."
			render :start_household_member_registration_wizard
		# redirect_to start_household_member_registration_wizard_path
	 	end




	end

	#18.
	def set_phone_numbers
			if session[:CLIENT_ID].present?
				phones = Phone.get_entity_contact_list(session[:CLIENT_ID], 6150)
				primary_phone = phones.where("phone_type = 4661")
				secondary_phone = phones.where("phone_type = 4662")
				other_phone = phones.where("phone_type = 4663")
				if @address.present?
					@address.client_email = @client.client_email
					@address.primary = primary_phone.first.phone_number if primary_phone.present?
					@address.secondary = secondary_phone.first.phone_number if secondary_phone.present?
					@address.other = other_phone.first.phone_number if other_phone.present?
				else
					@email = @client.client_email
					@primary_phone = primary_phone.first if primary_phone.present?
					@secondary_phone = secondary_phone.first if secondary_phone.present?
					@other_phone = other_phone.first if other_phone.present?
					# find the last updated by record for client.
					phone_collection = EntityPhone.where("entity_type = 6150 and entity_id = ?", @client.id).order("updated_at DESC")
					@modified_by = nil
					if phone_collection.present?
						latest_phone_object = phone_collection.first
						@modified_by = latest_phone_object.updated_by
					end
				end
			end
	end

	# 19.
	def check_for_assessment_step_for_adult()
		# fail
		if @client.dob?
				# fail
			if Client.is_adult( @client.id) == true
				ClientAssessmentAnswer.populate_assessment_and_assessment_answer_from_employment_step(@client.id)
				# fail
				# assessment_collection = ClientAssessment.where("client_id = ?",@client.id)
				# if assessment_collection.present?
				# 	client_assessment_object = assessment_collection.first
				# else
				# 	client_assessment_object = ClientAssessment.new
				# end
				# client_assessment_object.client_id = @client.id
				# client_assessment_object.assessment_date = Date.today
				# client_assessment_object.assessment_status = 6265 # incomplete
				# client_assessment_object.save

				# # Assessment answer for earned_income_flag
				# assessment_answer_collection = ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 2",client_assessment_object.id)
				# if assessment_answer_collection.present?
				# 	client_assessment_answer_object = assessment_answer_collection.first
				# else
				# 	client_assessment_answer_object = ClientAssessmentAnswer.new
				# end

				# client_assessment_answer_object.client_assessment_id = client_assessment_object.id
				# client_assessment_answer_object.assessment_question_id = 2 #
				# if @client.currently_working_flag == 'Y'
				# 	client_assessment_answer_object.answer_value = 'Y'
				# else
				# 	client_assessment_answer_object.answer_value = 'N'
				# end
				# client_assessment_answer_object.save
				# # Rails.logger.debug("client_assessment_answer_object = #{client_assessment_answer_object.inspect}")
				# # fail

				# # Assessment answer for job offer_flag
				# assessment_answer_collection = ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 3",client_assessment_object.id)
				# if assessment_answer_collection.present?
				# 	client_assessment_answer_object = assessment_answer_collection.first
				# else
				# 	client_assessment_answer_object = ClientAssessmentAnswer.new
				# end


				# 	client_assessment_answer_object.client_assessment_id = client_assessment_object.id
				# 	client_assessment_answer_object.assessment_question_id = 3 #
				# 	if @client.job_offer_flag == 'Y'
				# 		client_assessment_answer_object.answer_value = 'Y'
				# 	else
				# 		client_assessment_answer_object.answer_value = 'N'
				# 	end
				# 	client_assessment_answer_object.save
				# 	# Rails.logger.debug("client_assessment_answer_object = #{client_assessment_answer_object.inspect}")
				#  # fail



			else
				# Not adult - so must be kid, mark the assessment step as complete - since it is not needed for them.
				# Manoj 01/14/2016 - step completed logic start
       			#  update second step as completed.

	  			# HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(@client.id,'household_member_assessment_employment_step','Y')
	  			# Manoj 01/14/2016 - step completed logic end
				session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_incomes_step'
				# redirect_to start_household_member_registration_wizard_path
			end # if Client.is_adult( @client.id) == true
		else
			# fail
				# proceed to employment Assessment - sine no DOB not sure child /adult
				ClientAssessmentAnswer.populate_assessment_and_assessment_answer_from_employment_step(@client.id)
				# assessment_collection = ClientAssessment.where("client_id = ?",@client.id)
				# if assessment_collection.present?
				# 	client_assessment_object = assessment_collection.first
				# else
				# 	client_assessment_object = ClientAssessment.new
				# end
				# client_assessment_object.client_id = @client.id
				# client_assessment_object.assessment_date = Date.today
				# client_assessment_object.assessment_status = 6265 # incomplete
				# client_assessment_object.save

				# # Assessment answer
				# assessment_answer_collection = ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 2",client_assessment_object.id)
				# if assessment_answer_collection.present?
				# 	client_assessment_answer_object = assessment_answer_collection.first
				# else
				# 	client_assessment_answer_object = ClientAssessmentAnswer.new
				# end
				# client_assessment_answer_object.client_assessment_id = client_assessment_object.id
				# client_assessment_answer_object.assessment_question_id = 2 #
				# if @client.currently_working_flag == 'Y'
				# 	client_assessment_answer_object.answer_value = 'Y'
				# else
				# 	client_assessment_answer_object.answer_value = 'N'
				# end
				# client_assessment_answer_object.save

				# # Assessment answer for job offer_flag
				# assessment_answer_collection = ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 3",client_assessment_object.id)
				# if assessment_answer_collection.present?
				# 	client_assessment_answer_object = assessment_answer_collection.first
				# else
				# 	client_assessment_answer_object = ClientAssessmentAnswer.new
				# end


				# 	client_assessment_answer_object.client_assessment_id = client_assessment_object.id
				# 	client_assessment_answer_object.assessment_question_id = 3 #
				# 	if @client.job_offer_flag == 'Y'
				# 		client_assessment_answer_object.answer_value = 'Y'
				# 	else
				# 		client_assessment_answer_object.answer_value = 'N'
				# 	end
				# 	client_assessment_answer_object.save
		end # END of if @client.dob.present?



	end





	def start_household_member_registration_wizard_common_steps_with_or_without_household_id
		if session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_demographics_step"
			@notes = NotesService.get_notes(6150,@client.id,6471,@client.id)
		# citizenship step
		elsif session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_citizenship_step"
			# fail
			if @client.citizenship?
		  		alien_collection = Alien.where("client_id = ?", @client.id).order("id desc")
		  		@alien = nil
		  		if alien_collection.present?
		  			@alien = alien_collection.first
		  		end
		  		@notes = NotesService.get_notes(6150,@client.id,6473,@client.id)
	  		else
	  			# fail
	  			if session[:BACK_BUTTON_FROM_CITIZENSHIP].present? && session[:BACK_BUTTON_FROM_CITIZENSHIP] == 'Y'
	  			# fail
	  				# nORMAL SHOW PAGE - SINCE USER HIT BACK ON NEW PAGE
	  			else
	  				# fail
	  				redirect_to new_household_member_citizenship_path(@client.id,'HOUSEHOLD_MEMBER_STEP_WIZARD')
	  				# return
	  			end
	  		end
	  	# Education step
	  	elsif session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_education_step"
			session[:CLIENT_ASSESSMENT_ID] = nil
			@educations = @client.educations
			 # SET the flags
			if  @educations.present?
				@household.member_education_add_flag = 'Y'
			else
				 if @client.education_add_flag.present?
				 	@household.member_education_add_flag = @client.education_add_flag
				 else
				 	@household.member_education_add_flag = 'N'
				 end
			end

  		elsif session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_employments_step"
  			# fail
  			@employments = Employment.employment_records_for_client(@client.id)
  			if @client.job_offer_flag.present?
  				# fail
  				@household.member_job_offer_flag =  @client.job_offer_flag
  			end
  			if @client.currently_working_flag.present?
  				# fail
  				@household.member_currently_working_flag =  @client.currently_working_flag
  			end
  		elsif session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_incomes_step"
  			session[:MEMBER_FINANCE_STEP_PROCESS] = 'Y'
  			# fail
  			# Earned income step
  			 # Incomes - earned income or income deemed zero
  			@incomes = Income.earned_income_records(@client.id)
  			if @incomes.present?
  				# fail
  				@household.member_earned_income_flag = 'Y'
  			else
  				if @client.earned_income_flag.present?
  					# fail
  					@household.member_earned_income_flag =  @client.earned_income_flag
  				else
  					# fail
  					@household.member_earned_income_flag = 'N'
  				end
  			end
  	    elsif session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_unearned_incomes_step"
  	    	# fail
  	    	session[:MEMBER_FINANCE_STEP_PROCESS] = 'Y'
  			# UnEarned income step
  			  @unearned_incomes = Income.unearned_income_records(@client.id)
  			  # Rails.logger.debug("@unearned_incomes = #{@unearned_incomes.inspect}")
  			 # SET the flags
  			 if  @unearned_incomes.present?
  			 	@household.member_unearned_income_flag = 'Y'
  			 else
  			 	if @client.unearned_income_flag.present?
  			 		@household.member_unearned_income_flag = @client.unearned_income_flag
  			 	else
  			 		@household.member_unearned_income_flag = 'N'
  			 	end
  			 end
  	    elsif session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_assessment_employment_step"
  			# fail
  			li_sub_section_id = 2 #  working subsection
			@assessment_questions = AssessmentQuestion.get_questions_collection(li_sub_section_id) #
			@client_assessment_collection = ClientAssessment.get_client_assessments(@client.id)
			@client_assessment_answers = nil
			if @client_assessment_collection.present?
				@client_assessment_object = ClientAssessment.get_client_assessments(@client.id).first
  				@client_assessment_answers = ClientAssessmentAnswer.get_answers_collection_for_assessment(@client_assessment_object.id)
				# if user has not edited assessment page take him to edit mode.
				if ClientAssessmentAnswer.did_user_answer_any_employment_assessment_questions?(@client.id) == false
					# Rails.logger.debug("is false")
					# Rails.logger.debug("session[:BACK_BUTTON_FROM_ASSESSMENT] is #{session[:BACK_BUTTON_FROM_ASSESSMENT]}")
					if session[:BACK_BUTTON_FROM_ASSESSMENT].present? && session[:BACK_BUTTON_FROM_ASSESSMENT] == 'Y'
						# Rails.logger.debug("**assessment in show mode")
						# If BACK button from assessment is hit - it has to come back to show page of assessment -Normal step path
						# session[:BACK_BUTTON_FROM_ASSESSMENT] = nil
					else
						# Rails.logger.debug("**assessment in edit mode")
						# user has not modified and BACK button of edut assessment is not hit, so open in edit mode.
						redirect_to edit_member_employment_assessment_path(@client.id,@client_assessment_object.id,2)
					end
				else
					# Rails.logger.debug(" did_user_answer_any_employment_assessment_questions? is true")
				end
			end
  		elsif session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_expenses_step"
  			    # fail
  			@expenses = @client.expenses

  			if  @expenses.present?
  				# Rails.logger.debug("@expenses is present")
  				@household.member_expense_add_flag = 'Y'
  			else
  				if @client.expense_add_flag.present?
  					# Rails.logger.debug("@client.expense_add_flag.present is present")
  					@household.member_expense_add_flag = @client.expense_add_flag
  				else
  					# Rails.logger.debug("@client.expense_add_flag.present is not present")
  					@household.member_expense_add_flag = 'N'
  				end
  			end
		elsif session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_resources_step"
  			 # fail
  			@resources = @client.shared_resources.order("date_assert_acquired  desc")

  			if @resources.present?

  				@household.member_resource_add_flag = 'Y'
  			else
  				if @client.resource_add_flag.present?
  					@household.member_resource_add_flag = @client.resource_add_flag
  				else
  					@household.member_resource_add_flag = 'N'
  				end
  			end
		elsif session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_relations_step"
				@client_relations = ClientRelationship.get_household_member_relationships(@household.id)
				household_members = HouseholdMember.where("household_id = ?",@household.id)
				if household_members.present?
					@household_members_count = household_members.size
					if @household_members_count > 1
						if @client_relations.blank?
							if session[:BACK_BUTTON_FROM_RELATIONSHIP].present? && session[:BACK_BUTTON_FROM_RELATIONSHIP] == 'Y'
				  			# fail
				  				# nORMAL SHOW PAGE - SINCE USER HIT BACK ON NEW PAGE
				  			else
				  				# fail
				  				redirect_to edit_household_member_multiple_relationship_path(@household.id)
				  				# return
				  			end
				  		else
				  			l_members_count = HouseholdMember.where("household_id = ?",@household.id).count
							l_expected_relationship_count = l_members_count * (l_members_count - 1)
							l_db_relationship_count = @client_relations.size
							if  l_expected_relationship_count != l_db_relationship_count
								if session[:BACK_BUTTON_FROM_RELATIONSHIP].present? && session[:BACK_BUTTON_FROM_RELATIONSHIP] == 'Y'
					  				# fail
					  				# nORMAL SHOW PAGE - SINCE USER HIT BACK ON NEW PAGE
					  			else
					  				# fail
					  				redirect_to edit_household_member_multiple_relationship_path(@household.id)
					  				# return
					  			end
							end
						end
					end
				else
					@household_members_count = 0
				end
		end # end of if -elseif for steps

	end



	# def populate_assessment_and_assessment_answer(arg_client_id)
	# 		client_object = Client.find(arg_client_id)
	# 		assessment_collection = ClientAssessment.where("client_id = ?",arg_client_id)
	# 		if assessment_collection.present?
	# 			client_assessment_object = assessment_collection.first
	# 		else
	# 			client_assessment_object = ClientAssessment.new
	# 		end
	# 		client_assessment_object.client_id = arg_client_id
	# 		client_assessment_object.assessment_date = Date.today
	# 		client_assessment_object.assessment_status = 6265 # incomplete
	# 		client_assessment_object.save

	# 		# Assessment answer for are you currently working
	# 		assessment_answer_collection = ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 2",client_assessment_object.id)
	# 		if assessment_answer_collection.present?
	# 			client_assessment_answer_object = assessment_answer_collection.first
	# 		else
	# 			client_assessment_answer_object = ClientAssessmentAnswer.new
	# 		end

	# 		client_assessment_answer_object.client_assessment_id = client_assessment_object.id
	# 		client_assessment_answer_object.assessment_question_id = 2 # are you currently working
	# 		if client_object.currently_working_flag == 'Y'
	# 			client_assessment_answer_object.answer_value = 'Y'
	# 		else
	# 			client_assessment_answer_object.answer_value = 'N'
	# 		end
	# 		client_assessment_answer_object.save

	# 		# Assessment answer for job offer_flag
	# 		assessment_answer_collection = ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = 3",client_assessment_object.id)
	# 		if assessment_answer_collection.present?
	# 			client_assessment_answer_object = assessment_answer_collection.first
	# 		else
	# 			client_assessment_answer_object = ClientAssessmentAnswer.new
	# 		end
	# 		client_assessment_answer_object.client_assessment_id = client_assessment_object.id
	# 		client_assessment_answer_object.assessment_question_id = 3 #
	# 		if client_object.job_offer_flag == 'Y'
	# 			client_assessment_answer_object.answer_value = 'Y'
	# 		else
	# 			client_assessment_answer_object.answer_value = 'N'
	# 		end
	# 		client_assessment_answer_object.save

	# end



end



