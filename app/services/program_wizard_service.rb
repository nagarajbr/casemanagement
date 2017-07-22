class ProgramWizardService

	def self.by_pass_program_wizard_and_run_ed(arg_program_unit_id)
		program_wizard = nil
		begin
	        ActiveRecord::Base.transaction do
	        	# step1: Create new program wizard, when program wizard is created by default the run month is set to the first day of the current month - step1 complete
				program_wizard = ProgramWizard.manage_program_wizard_creation(arg_program_unit_id)
				# Rails.logger.debug("--> program_wizard = #{program_wizard.inspect}")
				program_unit = ProgramUnit.find(arg_program_unit_id)
				# complete the program unit
				program_unit.program_unit_status = 5942
				program_unit.save!
				# step1 - end

				# step2: Adding Program Benefit members
				available_members = ProgramBenefitMember.get_available_program_unit_members_query(program_wizard.id)
				# Rails.logger.debug("-->available_members = #{available_members.inspect}")
				available_members.each do |member|
					# Rails.logger.debug("member = #{member.inspect}")
					unless Client.date_of_death_present(member.id)
						program_benefit_member = ProgramBenefitMember.new
						program_benefit_member.program_wizard_id = program_wizard.id
						program_benefit_member.run_id = program_wizard.run_id
						program_benefit_member.month_sequence = program_wizard.month_sequence
						program_benefit_member.client_id = member.id
						pgu_member = ProgramUnitMember.get_program_unit_member(arg_program_unit_id,member.id)
						status = nil
						status = pgu_member.member_status if pgu_member.present?
						program_benefit_member.member_status = status# 4468 # "Active"
						program_benefit_member.member_sequence = ProgramBenefitMember.get_next_member_sequence(program_wizard.id)
						program_benefit_member.save!
					end
				end
				# step2: ends here all the program benefit members are added and associated to the current run

				# step3: Run ED

				fts = FamilyTypeService.new
				family_type_struct = FamilyTypeStruct.new
				family_type_struct = fts.determine_family_type_for_program_wizard(program_wizard.id)

				if family_type_struct.family_type != 0
					appl_eligibilty_servc = ApplicationEligibilityService.new
					# appl_eligibilty_servc.determine_program_unit_eligibilty(family_type_struct)
					# This is done
					# family_type_struct = fts.determine_family_type_for_program_wizard(program_wizard.id)
					# Case type is saved in program wizard -start - 03/25/2015
					program_wizard.case_type = family_type_struct.case_type_integer
					program_wizard.save!
					# Case type is saved in program wizard -end
					family_type_struct.run_month = program_wizard.run_month
					family_type_struct.run_id = program_wizard.run_id
					family_type_struct.month_sequence = program_wizard.month_sequence
					family_type_struct.ed_activie_members_list = ProgramBenefitMember.get_active_program_benefit_memebers_from_wizard_id(program_wizard.id)
					appl_eligibilty_servc.determine_program_wizard_eligibilty(family_type_struct)
					EligibilityDetermineService.common_rules_for_all_tanf_service_programs(family_type_struct,program_wizard.id)
					case program_unit.service_program_id
					when 1
						# TEA
						str_budget = BenefitCalculator.sum_budget_cal(program_unit.service_program_id,0,nil, program_unit.id, program_wizard.run_id, 355)

						if str_budget.error_flag == 'Y'
							flash[:alert] = str_budget.error_message
						else
							# pass the budget information from above to determine resource
							# get the rule id for resource (category 25)


							# Manoj Patil 05/21/2015 - commented Resource ED calculation - as it is giving run time error - need to revisit later
							effective_begin_date = str_budget.str_months[0].month.to_datetime
							resourec_rule_id = BenefitCalculator.bu_rule_id(4,'25',effective_begin_date,nil)
							str_budget.rule_id = resourec_rule_id
							# Run the resourec eligibility rules
							ResourceModule.sum_resource(str_budget)
							EligibilityDetermineService.tea_program_eligibility_validations(family_type_struct,program_wizard.id)
							# demo code for snap -START
							# step 1  : create snap program unit
							# step 2 : create snap program unit members
							# step 3 : create snap program wizard object
							# step 4 : create snap program wizard object
							# step 5 : call ed budget calculation

							# snap_program_unit = ProgramUnit.demo_test_function(program_unit)
							# if snap_program_unit.present?
							# 	snap_program_wizard_object = ProgramWizard.where("program_unit_id = ?",snap_program_unit.id).last
							# 	BenefitCalculator.sum_budget_cal(snap_program_unit.service_program_id, snap_program_unit.id, snap_program_wizard_object.run_id, 355)
							# end

							# demo code for snap - END
		                end

					when 3
						# TEA DIVERSION
						str_budget =  BenefitCalculator.sum_budget_cal(program_unit.service_program_id,0,nil,program_unit.id, program_wizard.run_id, 355)
						resourec_rule_id = BenefitCalculator.bu_rule_id(4,'25',effective_begin_date,nil)
						str_budget.rule_id = resourec_rule_id
						ResourceModule.sum_resource(str_budget)
						EligibilityDetermineService.tea_diversion_program_eligibility_validations(family_type_struct,program_wizard.id)
					when 4
						# WORKPAYS
						BenefitCalculator.sum_budget_cal(program_unit.service_program_id, 0, nil, program_unit.id, program_wizard.run_id, 357)
						EligibilityDetermineService.work_pays_program_eligibility_validations(family_type_struct,program_wizard.id)
					end
					EligibilityDetermineService.update_program_month_summaries_ed_indicator(program_wizard.run_id,program_wizard.month_sequence)
					# @client_program_units = ProgramUnit.get_completed_program_units(program_unit.id)

					# program_wizards = program_unit.program_wizards

					# details_for_run_id(program_unit.id,program_wizard.id)
					# redirect_to show_program_wizard_run_id_details_path(program_unit.id,program_wizard.id)
				else
					# flash message No child present in composition.
					# program_wizard.current_step = program_wizard.steps[1]
					# session[:PROGRAM_WIZARD_STEP] = program_wizard.current_step
					# flash[:alert] = "Unable to determine the Case Type"
					# redirect_to start_eligibility_determination_wizard_path(program_unit.id)
				end
				# fail
	        end
	    rescue => err
	        error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardService","by_pass_program_wizard_and_run_ed",err,AuditModule.get_current_user.uid)
	        msg = "Failed to run Eligibility Determination - for more details refer to Error ID: #{error_object.id}"
	    end
	    return program_wizard
	end

	def self.by_pass_program_wizard_and_run_ed_screening_only(arg_family_struct)
		# program_wizard = nil
		begin
	        ActiveRecord::Base.transaction do
	        	# step1: Create new program wizard, when program wizard is created by default the run month is set to the first day of the current month - step1 complete

				# program_wizard = ProgramWizard.manage_program_wizard_creation(arg_program_unit_id)
				# # Rails.logger.debug("--> program_wizard = #{program_wizard.inspect}")
				# program_unit = ProgramUnit.find(arg_program_unit_id)
				# # complete the program unit
				# program_unit.program_unit_status = 5942
				# program_unit.save!

				# step1 - end

				# step2: Adding Program Benefit members

				# available_members = ProgramBenefitMember.get_available_program_unit_members_query(program_wizard.id)

				# Remove all ineligible_code for the application, we will be run the Eligibility rules again.
				screeningineligiblecode = ScreeningIneligibleCode.where("application_id = ?",arg_family_struct.application_id)
				if screeningineligiblecode.present?
				 	screeningineligiblecode.destroy_all
				end

				available_members = Members.generate_members_list(arg_family_struct)
				# Rails.logger.debug("-->available_members = #{available_members.inspect}")
				# fail
				# available_members.each do |member|
				# 	# Rails.logger.debug("member = #{member.inspect}")
				# 	unless Client.date_of_death_present(member.id)
				# 		program_benefit_member = ProgramBenefitMember.new
				# 		program_benefit_member.program_wizard_id = program_wizard.id
				# 		program_benefit_member.run_id = program_wizard.run_id
				# 		program_benefit_member.month_sequence = program_wizard.month_sequence
				# 		program_benefit_member.client_id = member.id
				# 		pgu_member = ProgramUnitMember.get_program_unit_member(arg_program_unit_id,member.id)
				# 		status = nil
				# 		if pgu_member.present?
				# 			status = pgu_member.member_status
				# 		end
				# 		program_benefit_member.member_status = status# 4468 # "Active"
				# 		program_benefit_member.member_sequence = ProgramBenefitMember.get_next_member_sequence(program_wizard.id)
				# 		program_benefit_member.save!
				# 	end
				# end

				# step2: ends here all the program benefit members are added and associated to the current run

				# step3: Run ED

				# ===========================================================

				# fts = FamilyTypeService.new
				# family_type_struct = FamilyTypeStruct.new
				# family_type_struct = fts.determine_family_type_for_program_wizard(program_wizard.id)

				# if family_type_struct.family_type != 0
					appl_eligibilty_servc = ApplicationEligibilityServiceScreeningOnly.new
					# appl_eligibilty_servc.determine_program_unit_eligibilty(family_type_struct)
					# This is done
					# family_type_struct = fts.determine_family_type_for_program_wizard(program_wizard.id)
					# Case type is saved in program wizard -start - 03/25/2015

					# program_wizard.case_type = family_type_struct.case_type_integer
					# program_wizard.save!
					# # Case type is saved in program wizard -end
					# family_type_struct.run_month = program_wizard.run_month
					# family_type_struct.run_id = program_wizard.run_id
					# family_type_struct.month_sequence = program_wizard.month_sequence
					# family_type_struct.ed_activie_members_list = ProgramBenefitMember.get_active_program_benefit_memebers_from_wizard_id(program_wizard.id)

					# none_of_family_members_received_diversion_payemnts = true
					# atleast_one_of_family_members_has_valid_tea_diversion_requirements = false
					# available_members.each do |member|
					# 	if none_of_family_members_received_diversion_payemnts && InStatePayment.check_for_diversion_payments(member.client_id)
					# 		none_of_family_members_received_diversion_payemnts = false
					# 		break
					# 	end
					# 	if !(atleast_one_of_family_members_has_valid_tea_diversion_requirements) && ClientAssessmentAnswer.does_this_client_need_tea_diversion_based_on_assessment?(member.client_id)
					# 		atleast_one_of_family_members_has_valid_tea_diversion_requirements = true
					# 	end
					# end
					srvc_pgms = [1,4]
					# if none_of_family_members_received_diversion_payemnts && atleast_one_of_family_members_has_valid_tea_diversion_requirements
						srvc_pgms << 3
					# end
					service_programs = ServiceProgram.where("id in (?)",srvc_pgms).order("id")

					# service_programs = ServiceProgram.where("id in (1,4,22)").order("id")

					service_programs.each do |service_program|
						arg_family_struct.ineligible_codes[0] = []
			       		if arg_family_struct.members.present?
			       			arg_family_struct.members.each do |client_id|
				       			arg_family_struct.ineligible_codes[client_id] = []
				       		end
			       		end
						# Rails.logger.debug("arg_family_struct = #{arg_family_struct.inspect}")
						# fail
						arg_family_struct.service_program_id = service_program.id
						arg_family_struct = appl_eligibilty_servc.determine_program_wizard_eligibilty(arg_family_struct)
						# Rails.logger.debug("arg_family_struct.ineligible_codes.values = #{arg_family_struct.ineligible_codes.values.inspect}")
						# Rails.logger.debug("arg_family_struct.ineligible_codes.values.flatten = #{arg_family_struct.ineligible_codes.values.flatten.inspect}")
						str_budget = nil
						# fail
						# if arg_family_struct.ineligible_codes.values.flatten.blank?
							arg_family_struct.service_program_id = service_program.id
							arg_family_struct = EligibilityDetermineServiceScreeningOnly.common_rules_for_all_tanf_service_programs(arg_family_struct)
							case arg_family_struct.service_program_id
							when 1
								# TEA
								str_budget = BenefitCalculator.sum_budget_cal(1,arg_family_struct.application_id,available_members, 0, 0, 355)
								# Rails.logger.debug("str_budget = #{str_budget.inspect}")
								# fail
								if str_budget.error_flag == 'Y'
									flash[:alert] = str_budget.error_message
								else
									# pass the budget information from above to determine resource
									# get the rule id for resource (category 25)


									# Manoj Patil 05/21/2015 - commented Resource ED calculation - as it is giving run time error - need to revisit later
									effective_begin_date = str_budget.str_months[0].month.to_datetime
									resourec_rule_id = BenefitCalculator.bu_rule_id(4,'25',effective_begin_date,nil)
									str_budget.rule_id = resourec_rule_id
									# Run the resourec eligibility rules
									str_budget = ResourceModule.sum_resource(str_budget)
									arg_family_struct = EligibilityDetermineServiceScreeningOnly.tea_program_eligibility_validations(arg_family_struct)
									# demo code for snap -START
									# step 1  : create snap program unit
									# step 2 : create snap program unit members
									# step 3 : create snap program wizard object
									# step 4 : create snap program wizard object
									# step 5 : call ed budget calculation

									# snap_program_unit = ProgramUnit.demo_test_function(program_unit)
									# if snap_program_unit.present?
									# 	snap_program_wizard_object = ProgramWizard.where("program_unit_id = ?",snap_program_unit.id).last
									# 	BenefitCalculator.sum_budget_cal(snap_program_unit.service_program_id, snap_program_unit.id, snap_program_wizard_object.run_id, 355)
									# end

									# demo code for snap - END
				                end
							when 3
								# TEA DIVERSION
								str_budget = BenefitCalculator.sum_budget_cal(3,arg_family_struct.application_id,available_members, 0, 0, 355)
								resourec_rule_id = BenefitCalculator.bu_rule_id(4,'25',effective_begin_date,nil)
								str_budget.rule_id = resourec_rule_id
								str_budget = ResourceModule.sum_resource(str_budget)
								arg_family_struct = EligibilityDetermineServiceScreeningOnly.tea_diversion_program_eligibility_validations(arg_family_struct)
							when 4
								# WORKPAYS
								str_budget = BenefitCalculator.sum_budget_cal(4,arg_family_struct.application_id,available_members, 0, 0, 357)
								arg_family_struct = EligibilityDetermineServiceScreeningOnly.work_pays_program_eligibility_validations(arg_family_struct)
							end
							# Rails.logger.debug("service_program = #{service_program.id}")
							# Rails.logger.debug("***str_budget = #{str_budget.inspect}")
							# Rails.logger.debug("-->arg_family_struct = #{arg_family_struct.inspect}")
						 	# Populate all ineligible_codes into the model for the application
						 	# Rails.logger.debug("str_budget.ineligible_codes = #{str_budget.ineligible_codes.inspect}")
						 	# fail
			             	screeningineligiblecode = ScreeningIneligibleCode.new
			             	screeningineligiblecode.application_id = arg_family_struct.application_id
			             	screeningineligiblecode.service_program = service_program.id

							if str_budget.ineligible_codes.present?
								str_budget.ineligible_codes.each do |code|
		                			arg_family_struct.ineligible_codes[0] << code
		                        end
							end

							if arg_family_struct.ineligible_codes.values.flatten.uniq.present?
								arg_family_struct.budget_eligible_ind[service_program.id] = "N"
								# arg_family_struct.service_program_id = nil
								arg_family_struct.service_programs_ineligible_codes[service_program.id] = arg_family_struct.ineligible_codes
								screeningineligiblecode.ineligible_codes = arg_family_struct.ineligible_codes.values.flatten.uniq
				             	screeningineligiblecode.save!
							else
								arg_family_struct.budget_eligible_ind[service_program.id] = "Y"
								arg_family_struct.any_eligible_service_program = true
								arg_family_struct.eligible_service_programs << service_program.id
								# break
							end
							if str_budget.amount_eligible.present?
								arg_family_struct.benefit_amount[service_program.id] = service_program.id == 3 ? str_budget.amount_eligible*3 : str_budget.amount_eligible*12
							else
								arg_family_struct.benefit_amount[service_program.id] = 0
								# Rails.logger.debug("service program with nil amount = #{service_program.id}")
							end

						# else

						# 	Rails.logger.debug("arg_family_struct.ineligible_codes.values.flatten = #{arg_family_struct.ineligible_codes.values.flatten.inspect}")
						# 	fail
						# end
					end




					# EligibilityDetermineServiceScreeningOnly.update_program_month_summaries_ed_indicator(program_wizard.run_id,program_wizard.month_sequence)
					# @client_program_units = ProgramUnit.get_completed_program_units(program_unit.id)
					# program_wizards = program_unit.program_wizards
					# details_for_run_id(program_unit.id,program_wizard.id)
					# redirect_to show_program_wizard_run_id_details_path(program_unit.id,program_wizard.id)
				# else
					# flash message No child present in composition.
					# program_wizard.current_step = program_wizard.steps[1]
					# session[:PROGRAM_WIZARD_STEP] = program_wizard.current_step
					# flash[:alert] = "Unable to determine the Case Type"
					# redirect_to start_eligibility_determination_wizard_path(program_unit.id)
				# end
				# fail
	        end
	        return arg_family_struct
	    rescue => err
	        error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardService","by_pass_program_wizard_and_run_ed_screening_only",err,AuditModule.get_current_user.uid)
	        msg = "Failed to run eligibility determination - for more details refer to error ID: #{error_object.id}."
	    end
	end
end