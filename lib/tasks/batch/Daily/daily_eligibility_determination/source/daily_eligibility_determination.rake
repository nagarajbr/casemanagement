task :daily_eligibility_determination => :environment do
	batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)

	log_filename = "batch_results/daily/daily_eligibility_determination/results/daily_eligibility_determination_log_#{Time.now.strftime('%Y-%m-%d_%H%M%S')}"+".txt"
	# path = File.join(Rails.root, filename )
	log_path = File.join(Rails.root, log_filename)
	# file = File.new(path,"w+")
	log_file = File.new(log_path,"w+")
	start_time = Time.now.strftime("%Y-%m-%d")
	log_file.puts("Extract date: #{Time.now}")
	ls_count = 0
	ls_processed = 0
	ls_error_cnt = 0
	l_date = (Date.today)
	run_month_new_record = nil
	nightly_batch_processes_for_ed = get_nightly_batch_processes_for_ed.select("distinct entity_id,extract(month from run_month) as month") # "Eligibility Determination"
	ls_count = nightly_batch_processes_for_ed.length
	nightly_batch_processes_for_ed.each do |nbp|
		begin
			ActiveRecord::Base.transaction do
				log_file.puts("")
				log_file.puts("================================================")
				log_file.puts("Started Processing Program Unit: #{nbp.entity_id}")
		        nightly_batch_proceses = get_nightly_batch_processes_for_ed.where("entity_id = ? and submit_flag = 'Y'",nbp.entity_id)
				submit_flag_is_yes = nightly_batch_proceses.count > 0
				existing_program_wizard_record = ProgramWizard.get_latest_run_from_program_unit_id(nbp.entity_id)
				get_nightly_batch_processes_for_ed.each do |each_record|
					if  each_record.run_month.month == nbp.month
		                run_month_new_record = each_record.run_month
		                break
					end
				end
				# run_month = get_nightly_batch_processes_for_ed.run_month
				if existing_program_wizard_record.present?
					existing_program_wizard_record = existing_program_wizard_record.first
					new_program_wizard_record = ProgramWizard.new
					new_program_wizard_record.program_unit_id = existing_program_wizard_record.program_unit_id
					new_program_wizard_record.run_id = ProgramWizard.get_program_wizard_next_run_id
					new_program_wizard_record.run_month = run_month_new_record
					new_program_wizard_record.no_of_months = 1
					new_program_wizard_record.month_sequence = 1
					new_program_wizard_record.retain_ind = existing_program_wizard_record.retain_ind
					new_program_wizard_record.save
					# Rails.logger.debug("new_program_wizard_record = #{new_program_wizard_record.inspect}")
					existing_program_benefit_members = ProgramBenefitMember.get_program_benefit_members_from_run_id_and_month_sequence(existing_program_wizard_record.run_id, existing_program_wizard_record.month_sequence)
					# Rails.logger.debug("existing_program_benefit_members = #{existing_program_benefit_members.inspect}")
					existing_program_benefit_members.each do |pbm|
						#check for the status of these clients in program unit members, only active members should be put in the new run
						# if ProgramUnitMember.is_the_client_active_in_given_program_unit(pbm.client_id, existing_program_wizard_record.program_unit_id)
							ins_program_benefit_member = ProgramBenefitMember.new
							ins_program_benefit_member.program_wizard_id = new_program_wizard_record.id
							ins_program_benefit_member.client_id = pbm.client_id
							ins_program_benefit_member.member_sequence = pbm.member_sequence
							ins_program_benefit_member.member_status = ProgramUnitMember.get_member_status(existing_program_wizard_record.program_unit_id,pbm.client_id)
							ins_program_benefit_member.run_id = new_program_wizard_record.run_id
							ins_program_benefit_member.month_sequence = 1
							ins_program_benefit_member.save
							# Rails.logger.debug("ins_program_benefit_member #{pbm.client_id} = #{ins_program_benefit_member.inspect}")
						# end
					# Rails.logger.debug("pbm.client_id status = #{ProgramUnitMember.get_member_status(existing_program_wizard_record.program_unit_id,pbm.client_id)}")
					end
					log_file.puts("Created new run for Program Unit: #{nbp.entity_id}, Run Id: #{new_program_wizard_record.run_id}")
					arg_service_program_id = ProgramUnit.get_service_program_id(existing_program_wizard_record.program_unit_id)
					arg_rule_id = nil
					if arg_service_program_id.to_i == 1
						arg_rule_id = 355
					elsif arg_service_program_id.to_i == 4
						arg_rule_id = 357
					end

					appl_eligibilty_servc = ApplicationEligibilityService.new
					fts = FamilyTypeService.new
					family_type_struct = fts.determine_family_type_for_program_wizard(new_program_wizard_record.id)
					# Case type is saved in program wizard -start - 03/25/2015
					new_program_wizard_record.case_type = family_type_struct.case_type_integer
					new_program_wizard_record.save
					# Case type is saved in program wizard -end
					family_type_struct.run_month = new_program_wizard_record.run_month
					family_type_struct.run_id = new_program_wizard_record.run_id
					family_type_struct.month_sequence = new_program_wizard_record.month_sequence
					family_type_struct.ed_activie_members_list = ProgramBenefitMember.get_active_program_benefit_memebers_from_wizard_id(new_program_wizard_record.id)
					appl_eligibilty_servc.determine_program_wizard_eligibilty(family_type_struct)
					EligibilityDetermineService.common_rules_for_all_tanf_service_programs(family_type_struct,new_program_wizard_record.id)
		            previous_run_id_benefit_details_object = ProgramBenefitDetail.get_program_benefit_detail_collection_by_run_id(existing_program_wizard_record.run_id).first
		            program_benefit_amount = previous_run_id_benefit_details_object.program_benefit_amount
					str_budget = BenefitCalculator.sum_budget_cal(arg_service_program_id,0,nil, existing_program_wizard_record.program_unit_id, new_program_wizard_record.run_id, arg_rule_id)
					if str_budget.error_flag != 'Y'
						case arg_service_program_id
			  			when 1 # "TEA"
			  				effective_begin_date = str_budget.str_months[0].month.to_datetime
							resourec_rule_id = BenefitCalculator.bu_rule_id(4,'25',effective_begin_date,nil)
							str_budget.rule_id = resourec_rule_id
							ResourceModule.sum_resource(str_budget)
							EligibilityDetermineService.tea_program_eligibility_validations(family_type_struct,new_program_wizard_record.id)
			  			when 4 # "Work Pays"
			  				EligibilityDetermineService.work_pays_program_eligibility_validations(family_type_struct,new_program_wizard_record.id)
			  			end
					end
					# Update program month summary eligibility indicator if any of the business rules fail.
					EligibilityDetermineService.update_program_month_summaries_ed_indicator(new_program_wizard_record.run_id,new_program_wizard_record.month_sequence)
					if family_type_struct.case_type == "Child Not Present"
						EligibilityDetermineService.update_budget_eligibility_indicator(family_type_struct.run_id)
					end
					log_file.puts("Completed eligibility check on the new run for Program Unit: #{nbp.entity_id}")
					program_month_summary_collection = ProgramMonthSummary.get_program_month_summary_collection(new_program_wizard_record.run_id,new_program_wizard_record.month_sequence)
					if program_month_summary_collection.present?
						program_month_summary = program_month_summary_collection.first
						eligibilty_result = program_month_summary.budget_eligible_ind == 'N' ? "Fail" : "Pass"
						log_file.puts("Eligibility result for the new run on Program Unit: #{nbp.entity_id} is #{eligibilty_result}")
					end
					program_unit = ProgramUnit.find(nbp.entity_id)
					self_of_pgu = PrimaryContact.get_primary_contact(nbp.entity_id, 6345)
					# self_of_pgu = ProgramUnitMember.get_primary_beneficiary(nbp.entity_id).first
					msg = nil
					if self_of_pgu.present?
						if (submit_flag_is_yes || (str_budget.amount_eligible == program_benefit_amount))
							if program_month_summary.budget_eligible_ind == 'N'
								# 4. If submit flag is 'Y' in night batch table for the given program unit, and eligibility determination is 'Fail',
								# 	then close the program unit with date as end of month and reason from night batch table.
								# 	(Event to generate notice should triggers, which should be the same as online closure)
								# Rails.logger.debug("Run failed")
						  		begin
						      		ActiveRecord::Base.transaction do
						      			common_action_argument_object = CommonEventManagementArgumentsStruct.new
								        common_action_argument_object.event_id = 810 # "Save", closure of Program Unit
								        common_action_argument_object.program_unit_id = new_program_wizard_record.program_unit_id
								        common_action_argument_object.client_id = self_of_pgu.client_id if self_of_pgu.client_id.present?
								        common_action_argument_object.pgu_action_date = Date.today
								        common_action_argument_object.pgu_action_reason = nightly_batch_proceses.first.reason
								        common_action_argument_object.selected_pgu_action = 6100 # "Close"
								        msg = EventManagementService.process_event(common_action_argument_object)
								        if msg == "SUCCESS"
								        	get_nightly_batch_processes_for_ed.each do |batch_processed|
												batch_processed.processed = 'Y'
												batch_processed.save!
											end
											log_file.puts("Eligibility for the new run failed and the Program Unit: #{new_program_wizard_record.program_unit_id} is closed")# "Payment Submitted successfully"
											ls_processed = ls_processed + 1
										else
											# log msg
											log_file.puts("Run Failed Failed to close the Program Unit, Program Wizard: #{new_program_wizard_record.id}")
											ls_error_cnt = ls_error_cnt + 1
										end
									end
									rescue => err
										error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitActionsController","save_close_action",err,AuditModule.get_current_user.uid)
										msg = "Error ID: #{error_object.id} - Error occurred when Submitting Program Unit"
						        end
							else
								# 5. If submit flag is 'Y' in night batch table for the given program unit, and eligibility determination is 'Pass',
								# 	then submit the eligibility run.
								ret_hash = ProgramUnit.can_submit_program_run_id?(new_program_wizard_record.run_id,new_program_wizard_record.month_sequence)
								if ret_hash[:can_submit] == true
										begin
								            ActiveRecord::Base.transaction do
										    msg = ProgramUnit.submit_payment(new_program_wizard_record.id)
												if msg == "SUCCESS"
													common_action_argument_object = CommonEventManagementArgumentsStruct.new
													common_action_argument_object.event_id = 683 # Submit Payment
													common_action_argument_object.program_wizard_id = new_program_wizard_record.id
													common_action_argument_object.client_id = self_of_pgu.client_id
													common_action_argument_object.program_unit_id = new_program_wizard_record.program_unit_id
													# common_action_argument_object.queue_service = false # Set to false to stop this event being triggered
													msg = EventManagementService.process_event(common_action_argument_object)
													if msg == "SUCCESS"
														get_nightly_batch_processes_for_ed.each do |batch_processed|
														batch_processed.processed = 'Y'
														batch_processed.save!
														end
														log_file.puts("Eligibility had been successfully submitted for Program Unit: #{new_program_wizard_record.program_unit_id}, Submitted Run: #{new_program_wizard_record.run_id}")# "Payment Submitted successfully"
														ls_processed = ls_processed + 1
											        else
														# log msg
														log_file.puts(msg + " Program Wizard: #{new_program_wizard_record.id}")
														ls_error_cnt = ls_error_cnt + 1
											        end
												else
									    		# log msg
													log_file.puts("Failed to submit the run "+ msg + " Program Wizard: #{new_program_wizard_record.id}")
													ls_error_cnt = ls_error_cnt + 1
												end
											end
										rescue => err
											error_object = CommonUtil.write_to_attop_error_log_table("daily_eligibility_determination","submitting_program_wizard_run_id through rake",err,AuditModule.get_current_user.uid)
											msg =  "Error ID: #{error_object.id} - Error occurred when Submitting Program Unit"
							   			end
								else
									log_file.puts("Failed to submit the run #{msg} Program Wizard: #{new_program_wizard_record.id}")
									ls_error_cnt = ls_error_cnt + 1
								end#if ret_hash[:can_submit] == true
							end#if program_month_summary.budget_eligible_ind == 'N'
						else
							# If submit flag is 'N' in night batch table for the given program unit, create a task for eligibility worker
							# to take action on program unit. (task should mention eligibility result and for worker to take action

							begin
					      		ActiveRecord::Base.transaction do
									common_action_argument_object = CommonEventManagementArgumentsStruct.new
							        common_action_argument_object.event_id = 836 # Work on Program Unit
							        common_action_argument_object.program_wizard_id = new_program_wizard_record.id
							        common_action_argument_object.client_id = self_of_pgu.client_id
							        common_action_argument_object.program_unit_id = new_program_wizard_record.program_unit_id
							        msg = EventManagementService.process_event(common_action_argument_object)
									if msg == "SUCCESS"
										# "Payment Submitted successfully"
										get_nightly_batch_processes_for_ed.each do |batch_processed|
											batch_processed.processed = 'Y'
											batch_processed.save!
										end
										log_file.puts("Work task to work on Program Unit: #{new_program_wizard_record.program_unit_id} has been created")
										ls_processed = ls_processed + 1
									else
										# log msg
										log_file.puts("Failed to create work task to work on Program Unit: #{new_program_wizard_record.program_unit_id}")
										ls_error_cnt = ls_error_cnt + 1
									end

								end
								rescue => err
									error_object = CommonUtil.write_to_attop_error_log_table("daily_eligibility_determination","submitting_program_wizard_run_id through rake",err,AuditModule.get_current_user.uid)
									msg =  "Error ID: #{error_object.id} - Error occurred when Submitting Program Unit"
					        end
						end#(submit_flag_is_yes || (str_budget.amount_eligible == program_benefit_amount))
					else
						log_file.puts("No primary contact present #{new_program_wizard_record.program_unit_id}")
						ls_error_cnt = ls_error_cnt + 1
					end
				end
				log_file.puts("================================================")
				log_file.puts("")
			end
		rescue => err
			log_file.puts("Failed to process batch record: #{nbp.id}")
			log_file.puts("Error log: #{err}")
			next
		end
	end
	log_file.puts("Records read : " + ls_count.to_s)
	log_file.puts("Records errored : " + ls_error_cnt.to_s)
	log_file.puts("Records processed : " + ls_processed.to_s)
	log_file.puts("Extract date: #{Time.now}")
	log_file.close
end

def get_nightly_batch_processes_for_ed
	nightly_batch_processes_for_ed = nil
	l_next_date = nil
	l_date = Date.today
	if Date.today == Date.today.at_end_of_month
		l_next_date = Date.today.end_of_month.next_month
		nightly_batch_processes_for_ed = NightlyBatchProcess.where("process_type = 6526 and ((extract(year from run_month) = ? and
	 											extract(month from run_month) = ?) or (extract(year from run_month) = ? and extract(month from run_month) = ?))",
	 													l_date.year, l_date.month,l_next_date.year,l_next_date.month)
	else
		nightly_batch_processes_for_ed = NightlyBatchProcess.where("process_type = 6526 and (extract(year from run_month) = ? and extract(month from run_month) = ?)",
														l_date.year,l_date.month)
	end
	return nightly_batch_processes_for_ed
end