class PotentialIntakeClientsController  < AttopAncestorController
	def index
		@potential_clients_for_intake = PotentialIntakeClient.get_clients_for_intake_queue()
		# logger.debug("@potential_clients_for_intake - inspect = #{@potential_clients_for_intake.inspect}")
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PotentialIntakeClientsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to access potential intake clients."
		redirect_to_back
	end

	def process_for_intake

		@potential_client_object = PotentialIntakeClient.find(params[:id])
		#  Search client.
		@client_results = Client.search_for_intake_queue(@potential_client_object.id)
		if @client_results.size == 0
			render 'no_client_found'
			# Populate prepopulate session variables
			 session[:NEW_CLIENT_LAST_NAME] = @potential_client_object.last_name
			 session[:NEW_CLIENT_FIRST_NAME] =  @potential_client_object.first_name
			 session[:NEW_CLIENT_DOB] = @potential_client_object.date_of_birth
			if @potential_client_object.ssn.present?
				session[:NEW_CLIENT_SSN] = @potential_client_object.ssn
			end
		elsif @client_results.size == 1
			# Only One record found - Navigate to Client Applications Path
			session[:CLIENT_ID] = @client_results.first.id
	  		# clear APPLICATION ID & PROGRAM_UNIT_ID in sessions - since focus client is changed. Manoj 10/09/2014
	  		session[:APPLICATION_ID] = nil
	  		session[:PROGRAM_UNIT_ID] = nil
			redirect_to client_applications_path
		else
			# more than 1 record.
			render 'process_for_intake'
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PotentialIntakeClientsController","process_for_intake",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to access process for potential intake clients."
		redirect_to_back
	end

	def set_client_in_session_and_navigate

		session[:CLIENT_ID] = params[:client_id].to_i
  		# clear APPLICATION ID & PROGRAM_UNIT_ID in sessions - since focus client is changed. Manoj 10/09/2014
  		session[:APPLICATION_ID] = nil
  		session[:PROGRAM_UNIT_ID] = nil
  	 	# Manoj 10/09/2014 - end
		redirect_to client_applications_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PotentialIntakeClientsController","set_client_in_session_and_navigate",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to access process for potential intake clients."
		redirect_to_back

	end


	def mark_as_complete
		@potential_client_object = PotentialIntakeClient.find(params[:id])
		@potential_client_object.intake_status = "C"  # complete.
		@potential_client_object.save
		redirect_to intake_queue_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PotentialIntakeClientsController","mark_as_complete",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to access process for potential intake clients."
		redirect_to_back

	end

end
