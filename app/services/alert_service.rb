class AlertService
	def self.create_alert(arg_object,arg_event_to_action_mapping_object)
		return_alert_objects = AlertService.set_alert_data(arg_object,arg_event_to_action_mapping_object)
		# if return_alert_object.present?
		# 	return_alert_object.save!
		# end
		#Rails.logger.debug("-->return_alert_objects = #{return_alert_objects.inspect}")
    	# fail
		return_alert_objects.each do |alert_object|
			alert_object.save!
		end

	end


	def self.set_alert_data(arg_object,arg_event_to_action_mapping_object)
		alert_object = nil
		program_unit_object = nil
		ls_processing_office_name = nil
		alert_objects = []
		if arg_object.client_id.present?
        	client_object = Client.find(arg_object.client_id)
	    	ls_client_name = client_object.get_full_name
	    end
	    if arg_object.program_unit_id.present?

	    	program_unit_object = ProgramUnit.find(arg_object.program_unit_id)
	    	ls_processing_office_name = CodetableItem.get_short_description (program_unit_object.processing_location)
	    end

	    li_task_type = arg_event_to_action_mapping_object.task_type
	    case li_task_type
      	when 2178
      		ls_alert_text ="Program unit for client: #{ls_client_name} is transferred to local office: #{ls_processing_office_name}."
	        alert_object = Alert.set_alert(6348, #arg_alert_category, Business Alert
				                          li_task_type,#arg_alert_type,
				                          6345, #arg_alert_for_type,
				                          program_unit_object.id, #arg_alert_for_id,
				                          ls_alert_text,#arg_alert_text,
				                          6339, #arg_status,
				                          program_unit_object.case_manager_id#arg_alert_assigned_to_user_id
				                          )
	        alert_objects << alert_object
	    when 6353
	    	provider_agreement_object = ProviderAgreement.find(arg_object.provider_agreement_id)
	    	provider_agreement_transition_object = ProviderAgreementStateTransition.get_latest_transition_record(provider_agreement_object.id)
	    	ls_provider_name = Provider.get_provider_name(provider_agreement_object.provider_id)
      		ls_alert_text ="Provider agreement for provider:#{ls_provider_name} is approved."
	        alert_object = Alert.set_alert(6348, #arg_alert_category,
				                          li_task_type,#arg_alert_type,
				                          6354, #arg_alert_for_type, - provider agreement
				                          provider_agreement_object.id, #arg_alert_for_id,
				                          ls_alert_text,#arg_alert_text,
				                          6339, #arg_status,
				                          provider_agreement_transition_object.created_by #arg_alert_assigned_to_user_id
				                          )
	        alert_objects << alert_object
        when 6603 # "Reject Provider Agreement"
	    	provider_agreement_object = ProviderAgreement.find(arg_object.provider_agreement_id)
	    	provider_agreement_transition_object = ProviderAgreementStateTransition.get_latest_transition_record(provider_agreement_object.id)
	    	ls_provider_name = Provider.get_provider_name(provider_agreement_object.provider_id)
      		ls_alert_text ="Provider agreement for provider:#{ls_provider_name} is rejected."
	        alert_object = Alert.set_alert(6348, #arg_alert_category,
				                          li_task_type,#arg_alert_type,
				                          6354, #arg_alert_for_type, - provider agreement
				                          provider_agreement_object.id, #arg_alert_for_id,
				                          ls_alert_text,#arg_alert_text,
				                          6339, #arg_status,
				                          provider_agreement_transition_object.created_by #arg_alert_assigned_to_user_id
				                          )
	        alert_objects << alert_object
      #   when 6463 # "Request to approve CPP"
      #   	cpp_transition_object = CareerPathwayPlanStateTransition.get_latest_transition_record(arg_object.cpp_id)
	    	# ls_alert_text ="CPP for client: #{ls_client_name} is approved."
	     #    alert_object = Alert.set_alert(6348, #arg_alert_category, Client
				  #                         li_task_type,#arg_alert_type,
				  #                         6465, #arg_alert_for_type, - Career Path Way Plan
				  #                         arg_object.cpp_id, #arg_alert_for_id, cpp_id
				  #                         ls_alert_text,#arg_alert_text,
				  #                         6339, #arg_status,
				  #                         cpp_transition_object.created_by #arg_alert_assigned_to_user_id
				  #                         )
	     #    alert_objects << alert_object
        when 6607 # "Approve CPP"
        	# result = !(ProgramUnitParticipation.is_program_unit_participation_status_closed(program_unit_object.id))
          	# if result && program_unit_object.disposition_status != 6041 # "Denied"

          	# Case manager who requested for CPP approval will get an alert for CPP approval for client
		    	ls_alert_text ="career plan for client: #{ls_client_name} is approved."
		        alert_object = Alert.set_alert(6348, #arg_alert_category, Client
					                          li_task_type,#arg_alert_type,
					                          6465, #arg_alert_for_type, - Career Path Way Plan
					                          arg_object.cpp_id, #arg_alert_for_id, cpp_id
					                          ls_alert_text,#arg_alert_text,
					                          6339, #arg_status,
					                          program_unit_object.case_manager_id #arg_alert_assigned_to_user_id
					                          )
		        alert_objects << alert_object

	        # If program unit is not in open status yet, then alert ED worker for first time benefit amount approval
	        	# if ProgramUnitParticipation.is_program_unit_participation_status_open(program_unit_object.id) == false
	        	# 	if ProgramUnit.check_is_cpp_signed_by_program_unit_members(program_unit_object.id)
	        	# 		client_name = ProgramUnitMember.get_primary_beneficiary_name(program_unit_object.id)
	        	# 		ls_alert_text ="Request first time benefit amount approval for Program unit: #{program_unit_object.id}, self of program unit is #{client_name}"
	        	# 		alert_object = Alert.set_alert(6348, #arg_alert_category, Client
					     #                      6633,#arg_alert_type,
					     #                      6345, #arg_alert_for_type, - program unit type
					     #                      program_unit_object.id, #arg_alert_for_id, program unit id
					     #                      ls_alert_text,#arg_alert_text,
					     #                      6339, #arg_status,
					     #                      program_unit_object.eligibility_worker_id #arg_alert_assigned_to_user_id
					     #                      )
		        # 		alert_objects << alert_object
	        	# 	end
	        	# end
		    # end
        when 6633
        	# Request for First time benefit amount approval alert
        	client_name = ProgramUnitMember.get_primary_beneficiary_name(program_unit_object.id)
	        			ls_alert_text ="Request first time benefit amount approval for program unit: #{program_unit_object.id}, self of program unit is #{client_name}."
	        			alert_object = Alert.set_alert(6348, #arg_alert_category, Client
					                          6633,#arg_alert_type,
					                          6345, #arg_alert_for_type, - program unit type
					                          program_unit_object.id, #arg_alert_for_id, program unit id
					                          ls_alert_text,#arg_alert_text,
					                          6339, #arg_status,
					                          program_unit_object.eligibility_worker_id #arg_alert_assigned_to_user_id
					                          )
		        		alert_objects << alert_object

      #   when 6469 # Request to approve Service Payment
      #   	# service_authorization_line_item_obj = ServiceAuthorizationLineItem.find(arg_object.service_authorization_line_item_id)
      #     	ls_provider_name = Provider.get_provider_name(arg_object.provider_id)
	    	# service_authorization_line_item_transition_object = ServiceAuthorizationLineItemStateTransition.get_latest_transition_record(arg_object.service_authorization_line_item_id)
      # 		ls_alert_text ="Transportation Service Payment for provider: #{ls_provider_name} on service to client: #{ls_client_name} is approved."
	     #    alert_object = Alert.set_alert(6348, #arg_alert_category, "Provider"
				  #                         li_task_type,#arg_alert_type,
				  #                         6382, #arg_alert_for_type, - Service Authorization Line Item
				  #                         arg_object.service_authorization_line_item_id, #arg_alert_for_id,
				  #                         ls_alert_text,#arg_alert_text,
				  #                         6339, #arg_status,
				  #                         service_authorization_line_item_transition_object.created_by #arg_alert_assigned_to_user_id
				  #                         )
	     #    alert_objects << alert_object
        when 6604 # Reject Provider Service Payment
        	ls_provider_name = Provider.get_provider_name(arg_object.provider_id)
	    	service_authorization_line_item = ServiceAuthorizationLineItem.find(arg_object.service_authorization_line_item_id)
      		ls_alert_text ="Service payment for provider: #{ls_provider_name} on service to client: #{ls_client_name} is rejected."
	        alert_object = Alert.set_alert(6348, #arg_alert_category, "Provider"
				                          li_task_type,#arg_alert_type,
				                          6382, #arg_alert_for_type, - Service Authorization Line Item
				                          arg_object.service_authorization_line_item_id, #arg_alert_for_id,
				                          ls_alert_text,#arg_alert_text,
				                          6339, #arg_status,
				                          service_authorization_line_item.created_by #arg_alert_assigned_to_user_id
				                          )
	        alert_objects << alert_object
        when 6469 # Request to approve Provider Invoice
        	provider_invoice_obj = ProviderInvoice.find(arg_object.provider_invoice_id)
        	ls_provider_name = Provider.get_provider_name(provider_invoice_obj.provider_id)

	        provider_invoice_transition_obj = ProviderInvoiceStateTransition.get_latest_transition_record(provider_invoice_obj.id)
      		ls_alert_text ="Provider invoice for provider: #{ls_provider_name} on service to client: #{ls_client_name} is approved."
	        alert_object = Alert.set_alert(6348, #arg_alert_category, "Provider"
				                          li_task_type,#arg_alert_type,
				                          6383, #arg_alert_for_type, - Provider Invoice
				                          arg_object.provider_invoice_id, #arg_alert_for_id,
				                          ls_alert_text,#arg_alert_text,
				                          6339, #arg_status,
				                          provider_invoice_transition_obj.created_by #arg_alert_assigned_to_user_id
				                          )
	        alert_objects << alert_object
        when 2172
      		ls_service_program = ServiceProgram.service_program_description(program_unit_object.service_program_id)
      		ls_alert_text ="Supervisor approved first time benefit amount for #{ls_service_program} program unit for client:#{ls_client_name}."
      		alert_object = Alert.set_alert(6348, #arg_alert_category,
				                          li_task_type,#arg_alert_type,
				                          6345, #arg_alert_for_type,
				                          program_unit_object.id, #arg_alert_for_id,
				                          ls_alert_text,#arg_alert_text,
				                          6339, #arg_status,
				                          program_unit_object.eligibility_worker_id#arg_alert_assigned_to_user_id
				                          )
      		alert_objects << alert_object
      		if program_unit_object.case_manager_id != program_unit_object.eligibility_worker_id
      			alert_object = nil
      			alert_object = Alert.set_alert(6348, #arg_alert_category,
				                          li_task_type,#arg_alert_type,
				                          6345, #arg_alert_for_type,
				                          program_unit_object.id, #arg_alert_for_id,
				                          ls_alert_text,#arg_alert_text,
				                          6339, #arg_status,
				                          program_unit_object.case_manager_id#arg_alert_assigned_to_user_id
				                          )

      			alert_objects << alert_object if alert_object.present?

      		end



  		# when 6612
    #   		ls_service_program = ServiceProgram.service_program_description(program_unit_object.service_program_id)
    #   		reason = arg_object.reason
    #   		ls_alert_text ="Supervisor Rejected First Time Benefit Amount for #{ls_service_program} Program unit for Client:#{ls_client_name}, Reason: #{reason}"
    #   		alert_object = Alert.set_alert(6348, #arg_alert_category,
				#                           li_task_type,#arg_alert_type,
				#                           6345, #arg_alert_for_type,
				#                           program_unit_object.id, #arg_alert_for_id,
				#                           ls_alert_text,#arg_alert_text,
				#                           6339, #arg_status,
				#                           program_unit_object.eligibility_worker_id#arg_alert_assigned_to_user_id
				#                           )
    #   		alert_objects << alert_object
    #   		if program_unit_object.case_manager_id != program_unit_object.eligibility_worker_id
    #   			alert_object = nil
    #   			alert_object = Alert.set_alert(6348, #arg_alert_category,
				#                           li_task_type,#arg_alert_type,
				#                           6345, #arg_alert_for_type,
				#                           program_unit_object.id, #arg_alert_for_id,
				#                           ls_alert_text,#arg_alert_text,
				#                           6339, #arg_status,
				#                           program_unit_object.case_manager_id#arg_alert_assigned_to_user_id
				#                           )
    #   			alert_objects << alert_object if alert_object.present?
    #   		end
  		when 2173
  			can_create_alert = false
			model_name = arg_object.model_object.class.name.camelize
  			# attribute_name = RubyElement.find(arg_object.event_id).element_title
  			if arg_object.model_object.present?
  						# creating alert text
  				ls_alert_text = get_formatted_alert_text(arg_object, ls_client_name)

	  			if program_unit_object.present?
	  				assigned_to_user_id = program_unit_object.eligibility_worker_id
	  			end
				case arg_object.model_object.class.name
	  			when "Client"
	  				if arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id
	  					can_create_alert = true
	  				end
	  			when "Address"
	  				if (arg_object.address_type.present? && (arg_object.address_type == 4664) &&
	  					(arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id) && (arg_object.entity_type == 6150))
	  					can_create_alert = true
	  					ls_alert_text = CodetableItem.get_short_description(arg_object.address_type) + " " + ls_alert_text
	  				end
	  			when "Employment"
	  				client_age = Client.get_age(arg_object.client_id)
					if client_age >= SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i &&
														arg_object.model_object.updated_by != program_unit_object.case_manager_id
						can_create_alert = false
						# assigned_to_user_id = program_unit_object.case_manager_id
						alert_object = Alert.set_alert(6348,#arg_alert_category, = Business Alert
												2173, #arg_alert_type, = information change
												6172, #arg_alert_for_type, = participant
												arg_object.client_id,#arg_alert_for_id,
												ls_alert_text, #arg_alert_text,
												6339,#arg_status,
												program_unit_object.case_manager_id#arg_alert_assigned_to_user_id
									           )
						alert_objects << alert_object
					end
					if client_age >= SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i &&
									(arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id) &&
										(program_unit_object.eligibility_worker_id != program_unit_object.case_manager_id)
						can_create_alert = false
						alert_object = Alert.set_alert(6348,#arg_alert_category, = Business Alert
												2173, #arg_alert_type, = information change
												6172, #arg_alert_for_type, = participant
												arg_object.client_id,#arg_alert_for_id,
												ls_alert_text, #arg_alert_text,
												6339,#arg_status,
												program_unit_object.eligibility_worker_id#arg_alert_assigned_to_user_id
									           )
						alert_objects << alert_object
					end
				when "Income"
	  				can_create_alert = true
	  			when "IncomeDetail"
	  				can_create_alert = true
	  			when "IncomeDetailAdjustReason"
	  				can_create_alert = true
	  			when "Education"
	  				client_age = Client.get_age(arg_object.client_id)
					if client_age > 0 && client_age < SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i &&
									arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id
						can_create_alert = true
					elsif client_age > 0 && arg_object.model_object.updated_by != program_unit_object.case_manager_id
						can_create_alert = true
						assigned_to_user_id = program_unit_object.case_manager_id
					end
				when "Pregnancy"
					if arg_object.model_object.updated_by != program_unit_object.case_manager_id
						assigned_to_user_id = program_unit_object.case_manager_id
						can_create_alert = true
					end
				when "ClientParentalRspability"
					if arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id
						can_create_alert = true
					end
				when "Resource"
					if arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id
						can_create_alert = true
					end
				when "ResourceDetail"
					if arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id
						can_create_alert = true
					end
				when "ResourceAdjustment"
					if arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id
						can_create_alert = true
					end
				when "ResourceUse"
					if arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id
						can_create_alert = true
					end
				when "Alien"
					if arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id
						ls_alert_text = "Citizenship information changed for the client: #{ls_client_name}."
						can_create_alert = true
					end
				when "SanctionDetail"
					if ((arg_object.model_object.updated_by != program_unit_object.case_manager_id) && (arg_object.model_object.release_indicatior == '1'))
						assigned_to_user_id = program_unit_object.case_manager_id
						can_create_alert = false
						alert_object = Alert.set_alert(6348,#arg_alert_category, = Business Alert
												2173, #arg_alert_type, = information change
												6172, #arg_alert_for_type, = participant
					 							arg_object.client_id,#arg_alert_for_id,
												ls_alert_text, #arg_alert_text,
												6339,#arg_status,
												assigned_to_user_id#arg_alert_assigned_to_user_id
									           )
	  					alert_objects << alert_object
					end
					if ((arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id) &&
										(program_unit_object.eligibility_worker_id != program_unit_object.case_manager_id))
						can_create_alert = false
						alert_object = Alert.set_alert(6348,#arg_alert_category, = Business Alert
												2173, #arg_alert_type, = information change
												6172, #arg_alert_for_type, = participant
												arg_object.client_id,#arg_alert_for_id,
												ls_alert_text, #arg_alert_text,
												6339,#arg_status,
												program_unit_object.eligibility_worker_id#arg_alert_assigned_to_user_id
									           )
						alert_objects << alert_object
					end
	  			end
	  			if can_create_alert
	  				alert_object = Alert.set_alert(6348,#arg_alert_category, = Business Alert
												2173, #arg_alert_type, = information change
												6172, #arg_alert_for_type, = participant
					 							arg_object.client_id,#arg_alert_for_id,
												ls_alert_text, #arg_alert_text,
												6339,#arg_status,
												assigned_to_user_id#arg_alert_assigned_to_user_id
									           )
	  				alert_objects << alert_object
	  			end


	  		else
	  			alert_for_user = program_unit_object.eligibility_worker_id
	  			if arg_object.event_id == 468
  					ls_alert_text = "Out of state payment deleted for client:#{ls_client_name}."
  					can_create_alert = true
  				elsif arg_object.event_id == 778
  					ls_alert_text = "Out of state payment created for client:#{ls_client_name}."
  					can_create_alert = true
  				elsif arg_object.event_id == 435
  					ls_alert_text = "Income deleted for client:#{ls_client_name}."
  					can_create_alert = true
  				elsif arg_object.event_id == 438
  					ls_alert_text = "Income details deleted for client:#{ls_client_name}."
  					can_create_alert = true
  				elsif arg_object.event_id == 564
  					ls_alert_text = "Resource deleted for client:#{ls_client_name}."
  					can_create_alert = true
  				elsif arg_object.event_id == 818
  					if arg_object.logged_in_user_id != program_unit_object.eligibility_worker_id
  						ls_alert_text = "Program unit representative is added."
  						can_create_alert = true
  					end
  				elsif arg_object.event_id == 678 # "ProgramUnitRepresentativesController - Deactivate"
  					if arg_object.logged_in_user_id != program_unit_object.eligibility_worker_id
  						ls_alert_text = "Program unit representative is deactivated."
  						can_create_alert = true
  					end
  				elsif arg_object.event_id == 343
  					if arg_object.logged_in_user_id != program_unit_object.eligibility_worker_id
  						ls_alert_text = "Relationship is added for client:#{ls_client_name}."
  						can_create_alert = true
  					end
  				elsif arg_object.event_id == 345
  					if arg_object.logged_in_user_id != program_unit_object.eligibility_worker_id
  						ls_alert_text = "Relationship is deleted for client:#{ls_client_name}."
  						can_create_alert = true
  					end
				elsif arg_object.event_id == 834# 595
					ls_alert_text = "Sanction detail is added for client:#{ls_client_name}."
					case arg_object.sanction_type
					when 3064,3067,3068,3070,3073,3085 # Progressive Sanction
						if program_unit_object.case_manager_id.present? && arg_object.logged_in_user_id != program_unit_object.case_manager_id
							can_create_alert = true
							alert_for_user = program_unit_object.case_manager_id
						end

						if program_unit_object.eligibility_worker_id.present? && (arg_object.logged_in_user_id != program_unit_object.eligibility_worker_id) &&
									(program_unit_object.case_manager_id != program_unit_object.eligibility_worker_id)
							# change in requirements an alert to eleigibility worker is also needed in this case
							alert_object = Alert.set_alert(6348, #arg_alert_category, Business Alert
					                          li_task_type,#arg_alert_type,
					                          6172, #arg_alert_for_type,#has to be changed
					                          arg_object.client_id, #arg_alert_for_id,
					                          ls_alert_text,#arg_alert_text,
					                          6339, #arg_status,
					                          program_unit_object.eligibility_worker_id#arg_alert_assigned_to_user_id
					                          )
  							alert_objects << alert_object
						end
					when 6225,3081,3062,6349
						if arg_object.logged_in_user_id != program_unit_object.eligibility_worker_id
							can_create_alert = true
						end
					end
				elsif arg_object.event_id == 833
					if arg_object.logged_in_user_id != program_unit_object.case_manager_id
						can_create_alert = true
						alert_for_user = program_unit_object.case_manager_id
						ls_alert_text = "Activity hour information changed for client:#{ls_client_name}."
					end
  				end
  				if can_create_alert
  					alert_object = Alert.set_alert(6348, #arg_alert_category, Business Alert
					                          li_task_type,#arg_alert_type,
					                          6172, #arg_alert_for_type,#has to be changed
					                          arg_object.client_id, #arg_alert_for_id,
					                          ls_alert_text,#arg_alert_text,
					                          6339, #arg_status,
					                          alert_for_user#arg_alert_assigned_to_user_id
					                          )
  					alert_objects << alert_object
  				end
			end
		when 6530
  			attribute_name = RubyElement.find(arg_object.event_id).element_title
  			humanized_attr_name = arg_object.model_object.class.human_attribute_name(attribute_name)
  			# if humanized_attr_name == "Characteristic"
  			# 	ls_alert_text = "#{arg_object.model_object.characteristic_type.titleize} changed for client:#{ls_client_name}"
  			# else
  			# 	ls_alert_text = "#{arg_object.model_object.characteristic_type.titleize} #{humanized_attr_name} changed for client:#{ls_client_name}"
  			# end
  			ls_alert_text = get_formatted_alert_text_for_characteristics(arg_object, ls_client_name)
  			case arg_object.model_object.characteristic_type
  			when "WorkCharacteristic"
  				if arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id
  					can_create_alert = true
  				end
  			when "LegalCharacteristic"
  				if arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id
  					can_create_alert = true
  				end
  			when "OtherCharacteristic"
  				if arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id
	  				if arg_object.is_a_new_record
	  					can_create_alert = true
	  				elsif ((arg_object.model_object.characteristic_id.to_i == 5610 || arg_object.model_object.characteristic_id.to_i == 6541 ) )#&&
	  						# (arg_event_to_action_mapping_object.event_type == 771 || arg_event_to_action_mapping_object.event_type == 770))	 # In case of update if characteristic is ended then only create alert
	  					#  5610 - "Family Cap Characteristic"
	  					#  6541 - "No School Attendance"
	  					can_create_alert = true
	  				end
	  			end
	  		when "DisabilityCharacteristic"
  				if arg_object.model_object.updated_by != program_unit_object.case_manager_id
  					can_create_alert = true
  				end
  			end
			if can_create_alert
  				alert_object = Alert.set_alert(6348,#arg_alert_category, = Business Alert
											li_task_type, #arg_alert_type, = information change
											6510, #arg_alert_for_type, = client
											arg_object.client_id,#arg_alert_for_id,
											ls_alert_text, #arg_alert_text,
											6339,#arg_status,
											program_unit_object.case_manager_id#arg_alert_assigned_to_user_id
								           )
  				alert_objects << alert_object
			end
		when 6606 #EmploymentDetails
			ls_alert_text = get_formatted_alert_text(arg_object, ls_client_name)
			if arg_object.model_object.updated_by != program_unit_object.case_manager_id
				alert_object = Alert.set_alert(6348, #arg_alert_category, Client
				                          li_task_type,#arg_alert_type,
				                          6510, #arg_alert_for_type, - Client
				                          arg_object.client_id, #arg_alert_for_id, cpp_id
				                          ls_alert_text,#arg_alert_text,
				                          6339, #arg_status,
				                          program_unit_object.case_manager_id #arg_alert_assigned_to_user_id
				                          )
				alert_objects << alert_object
			end
			if (arg_object.model_object.updated_by != program_unit_object.eligibility_worker_id) && (program_unit_object.case_manager_id != program_unit_object.eligibility_worker_id)
				alert_object = Alert.set_alert(6348, #arg_alert_category, Client
				                          li_task_type,#arg_alert_type,
				                          6510, #arg_alert_for_type, - Client
				                          arg_object.client_id, #arg_alert_for_id, cpp_id
				                          ls_alert_text,#arg_alert_text,
				                          6339, #arg_status,
				                          program_unit_object.eligibility_worker_id #arg_alert_assigned_to_user_id
				                          )
				alert_objects << alert_object
			end
		when 6639 # "Notification for Program Unit closure due to Batch ED"
			ls_alert_text ="Program unit: #{program_unit_object.id} for client: #{ls_client_name} has been closed by the system."
	        alert_object = Alert.set_alert(6348, #arg_alert_category, Client
				                          li_task_type,#arg_alert_type,
				                          6345, #arg_alert_for_type, - Program Unit
				                          program_unit_object.id, #arg_alert_for_id, cpp_id
				                          ls_alert_text,#arg_alert_text,
				                          6339, #arg_status,
				                          program_unit_object.eligibility_worker_id #arg_alert_assigned_to_user_id
				                          )
	        alert_objects << alert_object
		when 6640 # "Notification for Program Unit submit due to Batch ED"
			ls_alert_text ="Program unit: #{program_unit_object.id} for client: #{ls_client_name} has been submitted by the system to apply eligibility changes."
	        alert_object = Alert.set_alert(6348, #arg_alert_category, Client
				                          li_task_type,#arg_alert_type,
				                          6345, #arg_alert_for_type, - Program Unit
				                          program_unit_object.id, #arg_alert_for_id, cpp_id
				                          ls_alert_text,#arg_alert_text,
				                          6339, #arg_status,
				                          program_unit_object.eligibility_worker_id #arg_alert_assigned_to_user_id
				                          )
	        alert_objects << alert_object
      	end
	    return alert_objects
    end

    def self.get_formatted_alert_text(arg_object, ls_client_name)
    	model_attr_for_alert_txt = ''
    	ls_alert_text = ''
    	if arg_object.is_a_new_record
			ls_alert_text = "#{arg_object.model_object.class.name.titleize} record is added for client:#{ls_client_name}."
		else
			arg_object.changed_attributes.each  do |attribute|
				model_name = arg_object.model_object.class.name
	        	ruby_element_id = RubyElement.get_ruby_element_id_for_field(model_name, attribute)
	        	if ruby_element_id.present?
	        		humanized_attr_name = arg_object.model_object.class.human_attribute_name(attribute)
	        		model_attr_for_alert_txt += humanized_attr_name + ','
	        	end
	        end
	        if model_attr_for_alert_txt.present?
	        	model_attr_for_alert_txt = model_attr_for_alert_txt.strip[0, model_attr_for_alert_txt.length-1]
	        	ls_alert_text = "#{arg_object.model_object.class.name.titleize}: #{model_attr_for_alert_txt} changed for client:#{ls_client_name}."
	        end
		end
		return ls_alert_text
    end

    def self.get_formatted_alert_text_for_characteristics(arg_object, ls_client_name)
    	model_attr_for_alert_txt = ''
    	ls_alert_text = ''
    	if arg_object.is_a_new_record
			ls_alert_text = "#{arg_object.model_object.characteristic_type.titleize} record is added for client:#{ls_client_name}."
		else
			arg_object.changed_attributes.each  do |attribute|
				model_name = arg_object.model_object.class.name
	        	ruby_element_id = RubyElement.get_ruby_element_id_for_field(model_name, attribute)
	        	if ruby_element_id.present?
	        		humanized_attr_name = arg_object.model_object.class.human_attribute_name(attribute)
	        		model_attr_for_alert_txt += humanized_attr_name + ','
	        	end
	        end
	        if model_attr_for_alert_txt.present?
	        	model_attr_for_alert_txt = model_attr_for_alert_txt.strip[0, model_attr_for_alert_txt.length-1]
	        	ls_alert_text = "#{arg_object.model_object.characteristic_type.titleize} record attributes: #{model_attr_for_alert_txt} changed for client:#{ls_client_name}."
	        end
		end
		return ls_alert_text
    end

end