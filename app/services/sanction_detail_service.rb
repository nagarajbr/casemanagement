class SanctionDetailService

	def self.save_sanction_details(arg_client_id,arg_sanction_details_object,arg_run_month)
		 Rails.logger.debug("arg_sanction_details_object = #{arg_sanction_details_object.inspect}")
		begin
        	ActiveRecord::Base.transaction do
        		common_action_argument_object = CommonEventManagementArgumentsStruct.new
		        common_action_argument_object.client_id = arg_client_id
		        common_action_argument_object.event_id = 834 # Creating a sanction detail
		        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
		        common_action_argument_object.sanction_id = arg_sanction_details_object.sanction_id
		        common_action_argument_object.sanction_type = Sanction.find(arg_sanction_details_object.sanction_id).sanction_type
		        common_action_argument_object.run_month = arg_run_month
		        common_action_argument_object.is_a_new_record = arg_sanction_details_object.new_record?
		        common_action_argument_object.changed_attributes = arg_sanction_details_object.changed_attributes().keys
		        Rails.logger.debug("common_action_argument_object = #{common_action_argument_object.inspect}")
        		arg_sanction_details_object.save!
            common_action_argument_object.sanction_detail_id = arg_sanction_details_object.id
				    msg = EventManagementService.process_event(common_action_argument_object)
    		end
    	rescue => err
            error_object = CommonUtil.write_to_attop_error_log_table("SanctionDetailService","save_sanction_details",err,AuditModule.get_current_user.uid)
            msg = "Failed to create sanction detail- for more details refer to error ID: #{error_object.id}."
    	end

	end

	def self.validate_immunization_sanction_details(client_id)
		#1. Age of client is less than 5
        #2. If immunization is provided, else if not provided check if client is exempt from immunization
        result = ""
        client = Client.find(client_id)
        if client.dob?
        	client_age = Client.get_age(client_id)
	        if client_age < 5
	        	client_exempt_from_immunization = Client.is_exempted_from_immunization(client_id)
	        	if client_exempt_from_immunization
                    #immunization is exempted
                    result = "Sanction is not required as client is exempt from immunization "
	        	else
                   #immunization is required
                   client_immunization = ClientImmunization.get_client_immunization(client_id)
                   if (client_immunization.present? and client_immunization.immunizations_record == "Y")
                   	  result = "Sanction is not required as immunization information is present"
                   	else
                      result = "save"
                   end
	        	end
	        else
	        	 result = "Client age is: #{client_age}.Immunization is not required for client"
	        end
        else
         	result = "Client date of birth is required "
        end



    end



end
