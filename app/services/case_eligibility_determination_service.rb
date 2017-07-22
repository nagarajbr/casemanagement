class CaseEligibilityDeterminationService

	def self.calculate_benefits_for_the_determined_case_types_screening_only(arg_application_id, arg_household_struct)
		Rails.logger.debug("calculate_benefits_for_the_determined_case_types_screening_only - begin")
		# Rails.logger.debug("arg_household_struct = #{arg_household_struct.inspect}")
		# fail
		# Rails.logger.debug("-->determine_cases arg_household_id = #{arg_household_id}")
		# application_id = ClientApplication.get_application_id(arg_household_id)
		application_id = arg_application_id
		client_application_object = ClientApplication.find(application_id)
		# Rails.logger.debug("arg_household_struct = #{arg_household_struct.class.name}")
		# Rails.logger.debug("arg_household_struct = #{arg_household_struct.inspect}")
		# fail
		begin
	        ActiveRecord::Base.transaction do
	        	i = 0
				arg_household_struct.family_structure.each do |family_struct|
					family_struct.validation_date = client_application_object.application_date
					family_struct.application_id = arg_application_id

					# ap_srvc_pgms = ApplicationServiceProgram.where("client_application_id = ? and service_program_id = 1 and status = 4000",application_id)
					# app_srvc_prgm_object = nil

					# if ap_srvc_pgms.present?
					# 	app_srvc_prgm_object = ap_srvc_pgms.first
					# else
					# 	app_srvc_prgm_object = ApplicationServiceProgram.new
					#     app_srvc_prgm_object.client_application_id = application_id
					#     app_srvc_prgm_object.service_program_id = 1 # "TEA"
					#     app_srvc_prgm_object.status = 4000  # Pending
					#     app_srvc_prgm_object.save!
					# end

					# Check if any of the members within this household has a program unit, if so use that program unit object
					program_unit_object = nil
					new_pgu = false
					# Rails.logger.debug("family_struct.members = #{family_struct.members.inspect}")

					# family_struct.members.each do |client_id|
					# 	if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(client_id)
					# 		program_units = ProgramUnit.get_open_client_program_units(client_id)
					# 		if program_units.present?
					# 			program_unit_object = program_units.first
					# 			break
					# 		end
					# 	end
					# end
					# service_program_id = 1 # "TEA" This need to come as a parameter when we are handling different programs
					# if program_unit_object.blank?
					# 	family_struct.members.each do |client_id|
					# 		program_unit_id = ProgramUnitMember.is_the_client_associated_with_any_program_unit_which_has_not_been_activated?(client_id, service_program_id)
					# 		if program_unit_id.present?
					# 			program_unit_object = ProgramUnit.find(program_unit_id)
					# 			break
					# 		end
					# 	end
					# end

					# Rails.logger.debug("program_unit_object = #{program_unit_object.inspect}")
					# fail
					# session.delete(:PROGRAM_UNIT_PROCESSING_LOCATION)

					# if program_unit_object.blank?
					# 	program_unit_object = ProgramUnit.new
					#     program_unit_object.client_application_id = application_id
				 #        program_unit_object.service_program_id = 1
				 #        program_unit_object.processing_location = 18# session[:PROGRAM_UNIT_PROCESSING_LOCATION].to_i
				 #        # program_unit_object.case_type = family_struct.case_type
				 #        # program_unit_object.save!
				 #        # program_unit_object.complete
				 #        new_pgu = true
					# end
					# program_unit_object.case_type = family_struct.case_type
			  #       program_unit_object.save!

			        # At this point of time we did not select the primary contact for pgu
			        # So we are adding application primary contact as the pgu primary contact, this can be edited by ED worker.

			        # if program_unit_object.complete
			        # 	application_primary_contact = PrimaryContact.get_primary_contact(application_id, 6587)
			        # 	if application_primary_contact.present?
			        # 		PrimaryContactService.save_primary_contact(program_unit_object.id, 6345, application_primary_contact.client_id)
			        # 	end
			        # end

					# arg_household_struct.family_structure[i].program_unit_id = program_unit_object.id

			        # family_struct.members.each do |client_id|
			        # 	if new_pgu || ProgramUnitMember.the_client_is_not_associated_with_given_program_unit?(program_unit_object.id, client_id)
			        # 		# If the family type is child only (6048) then don't allow any adults in family composition
			        # 		if (family_struct.case_type != 6048) || Client.is_child(client_id)
			        # 			l_program_unit_member_object = ProgramUnitMember.new
				       #          l_program_unit_member_object.program_unit_id = program_unit_object.id
				       #          l_program_unit_member_object.client_id = client_id
				       #          l_program_unit_member_object.member_of_application = "Y"
				       #          l_program_unit_member_object.member_status = get_client_status(family_struct,client_id)
				       #          l_program_unit_member_object.save!
			        # 		end
			        # 	end
			        # end
			        Rails.logger.debug("****************************************")
			        Rails.logger.debug("arg_household_struct = #{arg_household_struct.inspect}")
			        Rails.logger.debug("****************************************")
			        Rails.logger.debug("family_struct = #{family_struct.inspect}")
			        # fail

			        # if program_unit_object.present?
			        # 	program_unit_members = ProgramUnitMember.sorted_program_unit_members(program_unit_object.id)
			        # 	program_unit_members.each do |pgu_member|
			        # 		unless family_struct.members.include?(pgu_member.client_id)
			        # 			family_struct.members << pgu_member.client_id
			        # 		end
			        # 	end
			        # end

			        # arg_household_struct.family_structure[i] = ProgramWizardService.by_pass_program_wizard_and_run_ed_screening_only(family_struct)
			        family_struct = ProgramWizardService.by_pass_program_wizard_and_run_ed_screening_only(family_struct)
			        if family_struct.class.name != "String"
			        	arg_household_struct.any_eligible_program_units = true if (arg_household_struct.any_eligible_program_units == false) && family_struct.any_eligible_service_program
			        end

			       # ==========================================================

			        # # program_month_summaries = ProgramMonthSummary.get_program_month_summary_collection_from_run_id(program_wizard.run_id)
			        # program_benefit_details = ProgramBenefitDetail.get_program_benefit_detail_collection_by_run_id(program_wizard.run_id)
			        # # if program_month_summaries.present?
			        # # 	program_month_summary = program_month_summaries.first
			        # # 	arg_household_struct.family_structure[i].budget_eligible_ind = program_month_summary.budget_eligible_ind
			        # # end
			        # eligibility_deterimine_results = EligibilityDetermineResult.get_results_list(program_wizard.run_id,program_wizard.month_sequence)
			        # if eligibility_deterimine_results.where("program_unit_id is not null").count > 0
			        # 	arg_household_struct.family_structure[i].budget_eligible_ind = 'N'
			        # else
			        # 	arg_household_struct.family_structure[i].budget_eligible_ind = 'Y'
			        # end
			        # if program_benefit_details.present?
			        # 	program_benefit_detail = program_benefit_details.first
			        # 	arg_household_struct.family_structure[i].benefit_amount = program_benefit_detail.full_benefit
			        # end
			        # # Rails.logger.debug("***program_wizard = #{program_wizard.inspect}")

			        i+= 1
		        end
	        end
	    # rescue => err
	    #     error_object = CommonUtil.write_to_attop_error_log_table("CaseEligibilityDeterminationService","calculate_benefits_for_the_determined_case_types_screening_only",err,AuditModule.get_current_user.uid)
	    #     msg = "Failed to run Eligibility Determination - for more details refer to Error ID: #{error_object.id}"
	    end
	    Rails.logger.debug("calculate_benefits_for_the_determined_case_types_screening_only - end")
	    return arg_household_struct
	end

	def self.calculate_benefits_for_the_determined_case_types(arg_application_id, arg_screening_input, arg_household_struct)
		service_programs_hash = arg_screening_input[:service_programs]
		Rails.logger.debug("calculate_benefits_for_the_determined_case_types - begin")
		# Rails.logger.debug("arg_household_struct = #{arg_household_struct.inspect}")
		# fail
		# Rails.logger.debug("-->determine_cases arg_household_id = #{arg_household_id}")
		# application_id = ClientApplication.get_application_id(arg_household_id)
		application_id = arg_application_id
		client_application_object = ClientApplication.find(application_id)
		# client_application_object.application_disposition_status = 6017
		# client_application_object.disposition_date  = Time.now.to_date
		# client_application_object.application_disposition_reason = 6045
		# client_application_object.save!
		program_units = []
		begin
	        ActiveRecord::Base.transaction do
	        	i = 0
				arg_household_struct.family_structure.each do |family_struct|
					if service_programs_hash[i.to_s].present?
						service_programs_hash[i.to_s].each do |srv_pgm_id|
							service_program_id = srv_pgm_id.to_i
							ap_srvc_pgms = ApplicationServiceProgram.where("client_application_id = ? and service_program_id = ? and status = 4000",application_id,service_program_id)
							app_srvc_prgm_object = nil

							if ap_srvc_pgms.present?
								app_srvc_prgm_object = ap_srvc_pgms.first
							else
								app_srvc_prgm_object = ApplicationServiceProgram.new
							    app_srvc_prgm_object.client_application_id = application_id
							    app_srvc_prgm_object.service_program_id = service_program_id
							    app_srvc_prgm_object.status = 4000  # Pending
							    app_srvc_prgm_object.save!
							end

							# Check if any of the members within this household has a program unit, if so use that program unit object
							program_unit_object = nil
							new_pgu = false
							# Rails.logger.debug("family_struct.members = #{family_struct.members.inspect}")
							family_struct.members.each do |client_id|
								if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_for_a_given_service_program_and_active?(client_id, service_program_id)
									program_units = ProgramUnit.get_open_client_program_units_for_a_given_service_program(client_id, service_program_id)
									if program_units.present? && arg_household_struct.used_open_pgus.include?(program_units.first.id) == false
										program_unit_object = program_units.first
										arg_household_struct.used_open_pgus << program_units.first.id
										break
									end
								end
							end
							# service_program_id = 1 # "TEA" This need to come as a parameter when we are handling different programs
							if program_unit_object.blank?
								family_struct.members.each do |client_id|
									program_unit_id = ProgramUnitMember.is_the_client_associated_with_any_program_unit_which_has_not_been_activated?(client_id, service_program_id)
									if program_unit_id.present? && arg_household_struct.used_open_pgus.include?(program_unit_id) == false
										program_unit_object = ProgramUnit.find(program_unit_id)
										arg_household_struct.used_open_pgus << program_unit_id
										break
									end
								end
							end

							# session.delete(:PROGRAM_UNIT_PROCESSING_LOCATION)
							if program_unit_object.blank?
								program_unit_object = ProgramUnit.new
							    program_unit_object.client_application_id = application_id
						        program_unit_object.service_program_id = service_program_id
						        program_unit_object.processing_location = client_application_object.application_received_office# arg_screening_input[:program_unit_processing_location]
						        # program_unit_object.case_type = family_struct.case_type
						        # program_unit_object.save!
						        # program_unit_object.complete
						        new_pgu = true
						    else
						    	# if we are reusing an open avtive program unit for the gievn service program,
						    	# in that case need to update the application id in the program unit
						    	program_unit_object.client_application_id = application_id
							end
							program_unit_object.case_type = family_struct.case_type
							program_unit_object.eligibility_worker_id = AuditModule.get_current_user.uid
					        program_unit_object.save!
					        # At this point of time we did not select the primary contact for pgu
					        # So we are adding application primary contact as the pgu primary contact, this can be edited by ED worker.

					        if program_unit_object.complete
					        	application_primary_contact = PrimaryContact.get_primary_contact(application_id, 6587)
					        	if application_primary_contact.present?
					        		PrimaryContactService.save_primary_contact(program_unit_object.id, 6345, application_primary_contact.client_id)
					        	end
					        end

							arg_household_struct.family_structure[i].program_unit_id = program_unit_object.id
					        family_struct.members.each do |client_id|
					        	program_unit_member = ProgramUnitMember.get_program_unit_member(program_unit_object.id, client_id)
					        	if new_pgu || program_unit_member.blank?
					        		# If the family type is child only (6048) then don't allow any adults in family composition
					        		if (family_struct.case_type != 6048) || Client.is_child(client_id)
					        			l_program_unit_member_object = ProgramUnitMember.new
						                l_program_unit_member_object.program_unit_id = program_unit_object.id
						                l_program_unit_member_object.client_id = client_id
						                l_program_unit_member_object.member_of_application = "Y"
						                l_program_unit_member_object.member_status = family_struct.member_status[client_id]
						                l_program_unit_member_object.save!
					        		end
					        	else
					        		program_unit_member.member_status = family_struct.member_status[client_id]
					        		program_unit_member.save!
					        	end
					        	client_application_object = ClientApplication.find(program_unit_object.client_application_id)
					        	if family_struct.case_type == 6049 && is_minor_parent(family_struct, client_id) # "Minor Parent"
					        		client_characteristics_collection = ClientCharacteristic.where("client_id = ? and characteristic_id = 5701 and (end_date is null or end_date > current_date)",client_id)
					    			if client_characteristics_collection.blank?
					    				client_characteristic = ClientCharacteristic.populate_client_characteristic_information(client_id, 5701, "WorkCharacteristic", client_application_object.application_date, nil) # 5701 - "TEA Minor Parent School"
					    				client_characteristic.save!
					    			end
					        	end
					        end

					        # Commented to create run only once

					        # program_wizard = ProgramWizardService.by_pass_program_wizard_and_run_ed(program_unit_object.id)
					        # # program_month_summaries = ProgramMonthSummary.get_program_month_summary_collection_from_run_id(program_wizard.run_id)
					        # program_benefit_details = ProgramBenefitDetail.get_program_benefit_detail_collection_by_run_id(program_wizard.run_id)
					        # # if program_month_summaries.present?
					        # # 	program_month_summary = program_month_summaries.first
					        # # 	arg_household_struct.family_structure[i].budget_eligible_ind = program_month_summary.budget_eligible_ind
					        # # end
					        # eligibility_deterimine_results = EligibilityDetermineResult.get_results_list(program_wizard.run_id,program_wizard.month_sequence)
					        # if eligibility_deterimine_results.where("program_unit_id is not null").count > 0
					        # 	arg_household_struct.family_structure[i].budget_eligible_ind = 'N'
					        # else
					        # 	arg_household_struct.family_structure[i].budget_eligible_ind = 'Y'
					        # end
					        # if program_benefit_details.present?
					        # 	program_benefit_detail = program_benefit_details.first
					        # 	arg_household_struct.family_structure[i].benefit_amount = program_benefit_detail.full_benefit
					        # end

					        program_units << program_unit_object
						end
					end
			        # Rails.logger.debug("***program_wizard = #{program_wizard.inspect}")
			        i+= 1
		        end
	        end
	    # rescue => err
	    #     error_object = CommonUtil.write_to_attop_error_log_table("CaseCreatorService","calculate_benefits_for_the_determined_case_types",err,AuditModule.get_current_user.uid)
	    #     msg = "Failed to run Eligibility Determination - for more details refer to Error ID: #{error_object.id}"
	    end
	    Rails.logger.debug("calculate_benefits_for_the_determined_case_types - end")
	    return program_units
	end

	# def self.get_client_status(arg_family_struct, arg_client_id)
	# 	# Rails.logger.debug("arg_family_struct = #{arg_family_struct.inspect}")
	# 	# Rails.logger.debug("arg_client_id = #{arg_client_id}")
	# 	status = nil
	# 	if Client.get_age(arg_client_id) > 18
	# 		arg_family_struct.adults_struct.each do |adult_struct|
	# 			# Rails.logger.debug("adult_struct.parent_id == arg_client_id = #{adult_struct.parent_id == arg_client_id}")
	# 			# Rails.logger.debug("adult_struct.caretaker_id == arg_client_id = #{adult_struct.caretaker_id == arg_client_id}")
	# 			if (adult_struct.parent_id.present? && adult_struct.parent_id == arg_client_id) ||
	# 				(adult_struct.caretaker_id.present? && adult_struct.caretaker_id == arg_client_id)
	# 				# Rails.logger.debug("-->adult_struct = #{adult_struct.inspect}")
	# 				# fail
	# 				status = adult_struct.status
	# 				break
	# 			# else
	# 				# Rails.logger.debug("status = Inactive Full")
	# 				# fail
	# 				# status = drop_down_value_description(4470)
	# 			end
	# 		end
	# 	else
	# 		status = 4468
	# 	end
	# 	return status
	# end

	def self.is_minor_parent(arg_family_struct, arg_client_id)
		result = false
		arg_family_struct.adults_struct.each do |adult_struct|
			if adult_struct.parent_id.present? && adult_struct.parent_id == arg_client_id && Client.is_child(adult_struct.parent_id)
				result = true
				break
			end
		end
		return result
	end

end