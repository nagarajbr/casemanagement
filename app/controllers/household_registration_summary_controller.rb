class HouseholdRegistrationSummaryController < ApplicationController
	def index
		# fail
		# This is Household composition Index Page.
		# WHEN Intake management menu is selected this will be called.
		# Rule : If Household is there then only show the Index Page - else let the user go to Search page create new client/or find the household and come back.
		if session[:HOUSEHOLD_ID].present? && session[:HOUSEHOLD_ID] != 0
				@household = Household.find(session[:HOUSEHOLD_ID].to_i)
				@household_members = HouseholdMember.get_all_members_in_the_household(@household.id)
				# session[:NEW_HOUSEHOLD_ID] = session[:HOUSEHOLD_ID]
				client_object = Client.find(session[:CLIENT_ID].to_i)
				# household_member_collection = HouseholdMember.where("client_id = ?",client_object.id)
				# if household_member_collection.present?
				# 	household_member_object = household_member_collection.first
				# 	# session[:NEW_HOUSEHOLD_MEMBER_ID] = household_member_object.id
				# 	# session[:HOUSEHOLD_MEMBER_ID] = household_member_object.id
				# end
		else
			redirect_to root_path
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdRegistrationSummaryController","index",err,current_user.uid)
		flash[:alert] = "Error occured when showing household members summary, for more details refer to error ID: #{error_object.id}."
		redirect_to_back

	end

	def navigate_to_selected_step
		# fail
		if session[:HOUSEHOLD_ID].present? && session[:HOUSEHOLD_ID] != 0
			household_member_step_statuse_object = HouseholdMemberStepStatus.find(params[:step_id].to_i)
			@client = Client.find(household_member_step_statuse_object.client_id)
			@household = Household.find(household_member_step_statuse_object.household_id)
			household_member_collection = HouseholdMember.where("client_id = ? and household_id = ?",@client.id,@household.id)
			@household_member = household_member_collection.first


			# session[:NEW_HOUSEHOLD_ID] = @household.id
			session[:HOUSEHOLD_ID] = @household.id
			# session[:NEW_HOUSEHOLD_MEMBER_ID] = @household_member.id
			# session[:HOUSEHOLD_MEMBER_ID] = @household_member.id
			session[:CLIENT_ID] = @client.id
			ls_step_partial = household_member_step_statuse_object.step_partial

			session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = "#{ls_step_partial}"
			if request.env['HTTP_REFERER'].include? "registration_status"
				session[:NAVIGATE_FROM] = household_member_registration_status_path
			end
			 session[:BACK_BUTTON_FROM_ASSESSMENT] = nil
			redirect_to start_household_member_registration_wizard_path
		else
			# navigate to search page to search page so that household is created.
	   		redirect_to root_path
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdRegistrationSummaryController","navigate_to_selected_step",err,current_user.uid)
		flash[:alert] = "Error occured when navigating to selected step, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end

	def household_member_registration_status
		@member_steps = HouseholdMemberStepStatus.collection_of_steps_for_given_household_client(session[:HOUSEHOLD_ID],session[:CLIENT_ID])
		@client = Client.find(session[:CLIENT_ID])
		session[:NAVIGATE_FROM] = nil
		@back_button_path = session[:CALLED_FROM]
		if @member_steps.where("complete_flag = 'N' or complete_flag = 'S' or complete_flag = 'I'").count == 0
			session.delete(:CALLED_FROM)
			redirect_to @back_button_path
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdRegistrationSummaryController","household_member_registration_status",err,current_user.uid)
		flash[:alert] = "Error occured when showing household member registration status, for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end

end
