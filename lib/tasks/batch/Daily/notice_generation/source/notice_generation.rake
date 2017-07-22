
# /****                  PROGRAM DESCRIPTION                                  *
# *                    Daliy notice generation                                *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *
# *  DATE OF WRITTEN     : 10-19-2015.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:                  Generating daily notices                   *
# *                                                                           *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:             NONE                                      *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  NONE                                      *
# *																			  *
# *  ERROR FILES,LOG FILES         notice_generation, notice_generation_error *
# *                                                                           *
# *  RECOVERY  INSTRUCTIONS        Re run the program                         *
# *                                                                           *
# *****************************************************************************
require "#{Rails.root}/app/pdfs/core/fillable_pdf_form.rb"
require "#{Rails.root}/lib/tasks/notices/daily/daily_action/source/notice_generation_batch.rb"

task :notice_generation_from_batch => :environment do
	batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
	filename = "batch_results/daily/notice_generation/results/notice_generation_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	error_filename = "batch_results/daily/notice_generation/results/notice_generation_error_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	path = File.join(Rails.root, filename )
	error_path = File.join(Rails.root, error_filename )
	# # Create new file called 'filename.txt' at a specified path.
	file = File.new(path,"w+")
	error_file = File.new(error_path,"w+")

	total_notices_extracted_count = 0
	total_notices_processed_count = 0
	total_notices_process_fail_count = 0
	notice_generation = NoticeGeneration.where("(date(created_at) = current_date or date(updated_at) = current_date ) and notice_status = 6614")
	if notice_generation.present?
			total_notices_extracted_count = notice_generation.length
			notice_generation.each do |notice|
			primary_contact_object = PrimaryContact.get_primary_contact(notice.reference_id,notice.reference_type)
			if (notice.reference_id.present? and notice.reference_type.present? and notice.processing_location.present? and notice.case_manager_id.present? and primary_contact_object.present?)
			local_office_information = LocalOfficeInformation.local_office_informations_details_from_codetable_items_id(notice.processing_location)
			   primary_client_full_name = Client.get_client_full_name_from_client_id(primary_contact_object.client_id)
			   client_mailing_address = AddressEntityService.get_mailing_address_from_client_id(primary_contact_object.client_id)
            program_benefit_members = nil
            if notice.reference_type == 6345# program unit
            	if notice.action_type == 6100 #close
            		program_benefit_members =  ProgramUnitMember.get_program_unit_members(notice.reference_id)
				    program_benefit_details = ProgramBenefitDetail.program_benefit_detail_from_program_unit_id(notice.reference_id)
            	else
	            	program_benefit_members =  ProgramUnitMember.get_active_program_unit_members(notice.reference_id)
				    program_benefit_details = ProgramBenefitDetail.program_benefit_detail_from_program_unit_id(notice.reference_id)
            	end

               if (notice.action_type == 6100 or notice.action_type == 6099 or notice.action_type == 6043 or notice.action_type == 6719)
                    notice_text = NoticeText.get_notice_text_from_action_reason_action_type(notice.action_reason,notice.action_type,notice.service_program_id)
			   elsif notice.action_type == 6572
					if notice.program_wizard_id.present?
						progran_unit_object = ProgramUnit.find(notice.reference_id)
						program_wizard_collection = ProgramWizard.get_latest_submited_records_limit_to_2(notice.program_wizard_id)
						if program_wizard_collection.present?
							present_run_id = ProgramBenefitDetail.get_program_benefit_detail_collection_by_run_id(program_wizard_collection.first.run_id).first
							previous_run_id = ProgramBenefitDetail.get_program_benefit_detail_collection_by_run_id(program_wizard_collection.last.run_id).first
							present_run_benfit_members =ProgramBenefitMember.get_active_program_benefit_memebers_client_id_from_wizard_id_for_batch(program_wizard_collection.first.id)
							previous_run_benfit_members =ProgramBenefitMember.get_active_program_benefit_memebers_client_id_from_wizard_id_for_batch(program_wizard_collection.last.id)
							present_amount =  present_run_id.program_benefit_amount
							previous_amount  =  previous_run_id.program_benefit_amount
							notice_reason = ProgramWizardReason.get_program_wizard_reasons(notice.program_wizard_id)
							notice_text = []
							policy_collection = []
							result = nil
							policy_for_reason = nil
							time_limt = nil
							if progran_unit_object.case_type == 6046 || progran_unit_object.case_type == 6047 #"Single Parent" "Two Parent"
								benfit_members = ProgramBenefitMember.get_count_of_active_adults_present(program_wizard_collection.first.run_id)
								if benfit_members.present?
									if benfit_members.count > 1
										benfit_members.each do |each_member|
										state_counts_array = []

										state_count =  TimeLimit.get_details_by_client_id(each_member.client_id).first
											if state_count == nil
												state_count_for_clients = 24
										   else
												if (notice.service_program_id.present? and notice.service_program_id == 4)
													state_count_for_clients = 24 - (state_count.work_pays_state_count.to_i)
												elsif (notice.service_program_id.present? and notice.service_program_id == 1)
													state_count_for_clients = 24 - (state_count.tea_state_count)
												end #(notice.service_program_id.present? and notice.service_program_id == 4)
											end
										state_counts_array << state_count_for_clients
										time_limt = state_counts_array.max
										end #benfit_members.each do |each_member|
									elsif benfit_members.count == 1
										state_count = TimeLimit.get_details_by_client_id(primary_contact_object.client_id).first
										if state_count == nil
											time_limt = 24
										else
											if (notice.service_program_id.present? and notice.service_program_id == 4)
											time_limt = 24 - (state_count.work_pays_state_count.to_i)
											elsif (notice.service_program_id.present? and notice.service_program_id == 1)
											time_limt = 24 - (state_count.tea_state_count)
											end #(notice.service_program_id.present?
										end #state_count == nil
									end #benfit_members.count > 1
								end #benfit_members.present?

							end #if progran_unit_object.case_type == 6046 || progran_unit_object.case_type == 6047

							if notice_reason.present?
								notice_reason.each do |notice_each|
									if (present_run_benfit_members.present? and previous_run_benfit_members.present?)
										clients_deleted = previous_run_benfit_members - present_run_benfit_members
											if clients_deleted.present?
												clients_deleted.each do |delete|
												result = "Your members dropped: #{Client.get_client_full_name_from_client_id(delete)}"+ "\n"
													if notice_each.reason == 6608 ||notice_each.reason == 6584 ||notice_each.reason == 6546 ||notice_each.reason == 6594 ||notice_each.reason == 6596 ||notice_each.reason == 6595 ||notice_each.reason == 6583 ||notice_each.reason == 6534 ||notice_each.reason == 6577 ||notice_each.reason == 6584
														policy_for_reason = SystemParam.get_key_value(27,(notice_each.reason).to_s,"policy number for reasons" )
													elsif notice_each.reason.blank?
														 policy_for_reason = "TEA-2201"
													else
													end#notice_each.reason == 6608
												end#clients_deleted.each do |delete|
											else
												result =  "true"
											end#clients_deleted.present?
										unless policy_collection.include?(policy_for_reason)
										policy_collection << policy_for_reason
										end
										unless notice_text.include?(result)
										notice_text << result
										end

									clients_added = present_run_benfit_members - previous_run_benfit_members
										if clients_added.present?
											clients_added.each do |add|
											result = " Your members added: #{Client.get_client_full_name_from_client_id(add)}"+ "\n"
											policy_for_reason = "TEA-4132"
											end
										else
											result = "true"
										end #clients_added.present?
										unless policy_collection.include?(policy_for_reason)
											policy_collection << policy_for_reason
										end
										unless notice_text.include?(result)
											notice_text << result
										end

									end#(present_run_benfit_members.present? and previous_run_benfit_members.present?)

									if present_run_id.program_benefit_amount == previous_run_id.program_benefit_amount
										result=  "true"
									else
										if present_run_id.sanction == previous_run_id.sanction
											result=  "true"
										elsif (present_run_id.sanction != previous_run_id.sanction and present_run_id.sanction == 0.00)
											result=  "Your payment has been returned to full amount for complying on the sanction applied."
										elsif (present_run_id.sanction != previous_run_id.sanction and present_run_id.sanction != 0.00)
											reason = []
											if notice_each.reason == 6600 || notice_each.reason == 6599 || notice_each.reason == 6598 || notice_each.reason == 6602|| notice_each.reason == 6601
											get_client = "#{Client.get_client_full_name_from_client_id(notice_each.client_id)}, #{CodetableItem.get_short_description(notice_each.reason)}"
											reason << get_client
												reason.each do |client_and_reason|
													present_benefit = present_run_id.full_benefit - present_run_id.reduction
													sanction_presentage = (present_run_id.sanction.to_f/present_benefit.to_f * 100.0).round
													result = "Your payments have been reduced due to sanctions on: #{client_and_reason} "+ "\n" +
													"Your benefits were reduced by #{sanction_presentage}%"+ "\n" +
													"While your case is under sanction, the months you receive payments at reduced amounts will continue to count towards your 24-month time limit."+ "\n"+
													"Your payment will be released and/or can be returned to full amount by complying on the sanction applied.	"+ "\n"
													policy_for_reason = SystemParam.get_key_value(27,(notice_each.reason).to_s,"policy number for reasons" )
												end #reason.each do |client_and_reason|
											end#notice_each.reason == 6600 || notice_each.reason == 6599
										end#present_run_id.sanction == previous_run_id.sanction
										unless policy_collection.include?(policy_for_reason)
											policy_collection << policy_for_reason
										end

										unless notice_text.include?(result)
											notice_text << result
										end

										if notice_each.reason == 6544 || notice_each.reason == 6543 || notice_each.reason == 6542
											if present_run_id.eligibility_gross_earned == previous_run_id.eligibility_gross_earned
											result=  "true"
											else
												result=  "Your earned income has changed from $#{"%.2f" % previous_run_id.eligibility_gross_earned} to $#{"%.2f" % present_run_id.eligibility_gross_earned} "+ "\n"
												policy_for_reason = SystemParam.get_key_value(27,(notice_each.reason).to_s,"policy number for reasons" )
											end
											unless policy_collection.include?(policy_for_reason)
												policy_collection << policy_for_reason
											end
											unless notice_text.include?(result)
												notice_text << result
											end
											if present_run_id.eligibility_tot_unearned == previous_run_id.eligibility_tot_unearned
												result=  "true"
											else
												result=  "Your unearned income has changed from $#{previous_run_id.eligibility_tot_unearned} to $#{present_run_id.eligibility_tot_unearned} "+ "\n"
												policy_for_reason = SystemParam.get_key_value(27,(notice_each.reason).to_s,"policy number for reasons" )
											end
											unless policy_collection.include?(policy_for_reason)
												policy_collection << policy_for_reason
											end
											unless notice_text.include?(result)
												notice_text << result
											end
										end#notice_each.reason == 6544 || notice_each.reason == 6543 || notice_each.reason == 6542
									end#present_run_id.program_benefit_amount
								end#notice_reason.each do |notice_each|
							end# if notice_reason.present?
							if policy_collection.any?
								policy = policy_collection.compact.to_sentence
								policy_reason =  "The above actions are based on policies #{policy}"
							else
								policy_reason = "true"
							end #policy_collection.present?
							notice_text << policy_reason
							end # program_wizard_collection.present?
						else
							unless notice.program_wizard_id.present?
								total_notices_process_fail_count = total_notices_process_fail_count + 1
								error = "Unable to get program wizard id for program unit - #{notice.reference_id}"
								error_file.write(error + "\n")
							end#notice.program_wizard_id.present?
						end#notice.program_wizard_id.present?
				end#(notice.action_type == 6100 or notice.action_type == 6099 or notice.action_type == 6043)
			elsif notice.reference_type == 6587 #Client Application
				program_benefit_members =  ApplicationMember.get_clients_list_for_the_application(notice.reference_id)
		        if notice.action_type == 6018#rejected
		        	notice_text = NoticeText.get_notice_text_from_action_reason_action_type_for_application(notice.action_reason,notice.action_type)
		        end
			end#notice.reference_type
	   if (notice.present? and notice.reference_id.present? and notice.reference_type.present? and primary_client_full_name.present? and program_benefit_members.present? and local_office_information.present? and client_mailing_address.present? and program_benefit_details.present?)
					details = {}
					if notice.present?
					    details[:NOTICE] = notice
					end
					if primary_client_full_name.present?
						details[:PRIMARY_CLIENT_FULL_NAME] = primary_client_full_name
					end
					if program_benefit_members.present?
						if notice.action_type == 6572
							details[:PROGRAM_BENFIT_MEMBERS] =present_run_benfit_members
						else
							details[:PROGRAM_BENFIT_MEMBERS] = program_benefit_members
						end

					end
					if local_office_information.present?
						local_office_information = local_office_information.first
						details[:LOCAL_OFFICE_INFO] = local_office_information
					end

					if notice.action_type == 6572
						if notice_text.any?
							notice_text = notice_text.each do |each_reason_for_notice|
								Rails.logger.debug("each_reason_for_notice = #{each_reason_for_notice.inspect}")
								unless each_reason_for_notice  == 'true'
									details[:NOTICE_TEXT] = notice_text
								end
							end

						end

					else
						if notice_text.present?
							notice_text = notice_text.first
							details[:NOTICE_TEXT] = notice_text
						end
				    end

					if client_mailing_address.present?
						client_mailing_address = client_mailing_address.first
						details[:CLIENT_MAILING_ADDRESS] = client_mailing_address
					end
					if program_benefit_details.present?
						if notice.action_type == 6572
							present_run_id = present_run_id
						    details[:PROGRAM_BENEFIT_DETAILS] = present_run_id
						else
							program_benefit_details = program_benefit_details.first
						    details[:PROGRAM_BENEFIT_DETAILS] = program_benefit_details
						end

					end
					if notice.program_wizard_id.present?
						if time_limt.present?
							details[:TIME_LIMIT] = time_limt
						end
						if present_run_id.present?
							details[:PRESENT_RUN_ID] = present_run_id
						end
						if previous_run_id.present?
							details[:PREVIOUS_RUN_ID] = previous_run_id
						end
					end
					total_notices_processed_count = total_notices_processed_count + 1
					Rails.logger.debug("details[:NOTICE_TEXT] = #{details[:NOTICE_TEXT].inspect}")
					if details[:NOTICE_TEXT].present?
						output_path = "#{Rails.root}/tmp/pdfs/client name -#{primary_client_full_name},program unit id - #{notice.reference_id},#{notice.action_reason}.pdf" # make sure tmp/pdfs exists
						NoticeGenerationBatch.new(details).export(output_path)
						name = " client name -#{primary_client_full_name},program unit id - #{notice.reference_id}"
						file.write(name + "\n")
					else
			            #if no change notice should not be generated
			            name = " client name -#{primary_client_full_name},program unit id - #{notice.reference_id} action_type is change and no change in benfits"
					    file.write(name + "\n")
					     NoticeGeneration.find(notice.id).update(notice_status: 6613)

					end


			else
					unless primary_client_full_name.present?
						total_notices_process_fail_count = total_notices_process_fail_count + 1
						error = "Unable to get primary members full name for program unit - #{notice.reference_id}"
						error_file.write(error + "\n")
					end#primary_client_full_name.present?
					unless program_benefit_members.present?
						total_notices_process_fail_count = total_notices_process_fail_count + 1
						error = "unable to get program benfit members for program unit- #{notice.reference_id}"
						error_file.write(error + "\n")
					end#program_benefit_members.present?
					unless local_office_information.present?
						total_notices_process_fail_count = total_notices_process_fail_count + 1
						error = "unable to get local office information for program unit-#{notice.reference_id}"
						error_file.write(error + "\n")
					end#local_office_information.present?
					if notice.action_type == 6572
						unless notice_text.any?
							total_notices_process_fail_count = total_notices_process_fail_count + 1
							error = "unable to get notice text for program unit- #{notice.reference_id}. #{notice.action_type} change"
						    error_file.write(error + "\n")
						end
					else
						unless notice_text.present?
							total_notices_process_fail_count = total_notices_process_fail_count + 1
							error = "unable to get notice text for program unit- #{notice.reference_id}"
							error_file.write(error + "\n")
						end
					end
					unless client_mailing_address.present?
						total_notices_process_fail_count = total_notices_process_fail_count + 1
						error = "unable to get malling address client in program unit- #{notice.reference_id}"
						error_file.write(error + "\n")
					end#client_mailing_address.present?
					unless program_benefit_details.present?
						total_notices_process_fail_count = total_notices_process_fail_count + 1
						error = "Unable to get primary members full name for program unit - #{notice.reference_id}"
						error_file.write(error + "\n")
					end #program_benefit_details.present?
					if notice.action_type == 6572
						unless time_limt.present?
							total_notices_process_fail_count = total_notices_process_fail_count + 1
						    error = "Unable to get time limits for client - #{primary_client_full_name.first_name},#{primary_client_full_name.last_name}"
							error_file.write(error + "\n")
						end
						unless present_run_id.present?
							total_notices_process_fail_count = total_notices_process_fail_count + 1
							error = "Unable to get program benefit detail for program unit - #{notice.reference_id}"
							error_file.write(error + "\n")
						end
						unless previous_run_id.present?
							total_notices_process_fail_count = total_notices_process_fail_count + 1
							error = "Unable to get program benefit detail for program unit - #{notice.reference_id}"
							error_file.write(error + "\n")
						end
					end
			    end #(notice.present? and primary_client_full_name.present?
				else
					unless notice.reference_id.present?
			            total_notices_process_fail_count = total_notices_process_fail_count + 1
						error = "Unable to get reference id for notice generation id - #{notice.id}"
						error_file.write(error + "\n")
					end
					unless notice.reference_type.present?
			            total_notices_process_fail_count = total_notices_process_fail_count + 1
						error = "Unable to get reference type for notice generation id - #{notice.id}"
						error_file.write(error + "\n")
					end
					unless notice.processing_location.present?
			            total_notices_process_fail_count = total_notices_process_fail_count + 1
						error = "Unable to get processing location for notice generation id - #{notice.id}"
						error_file.write(error + "\n")
					end
					unless (notice.service_program_id.present? and notice.action_type == 6018)
			            total_notices_process_fail_count = total_notices_process_fail_count + 1
						error = "Unable to get service program id for notice generation id - #{notice.id}"
						error_file.write(error + "\n")
					end
					unless notice.case_manager_id.present?
			            total_notices_process_fail_count = total_notices_process_fail_count + 1
						error = "Unable to get case manager id for notice generation id - #{notice.id}"
						error_file.write(error + "\n")
					end
					unless primary_contact_object.present?
			            total_notices_process_fail_count = total_notices_process_fail_count + 1
						error = "Unable to get primary contact for notice generation id - #{notice.id}"
						error_file.write(error + "\n")
					end

				end #if (notice.reference_id.present? and notice.processing_location.present? and notice.service_program_id.present? and notice.case_manager_id.present?)
		   end #notice_generation.each do |notice|
		end #notice_generation.present?
	file.write("Total notices extracted = " + total_notices_extracted_count.to_s + "\n")
	file.write("Total notices processed = " + total_notices_processed_count.to_s + "\n")
	file.write("Total notices failed to process = " + total_notices_process_fail_count.to_s + "\n")

	file.close

end #task :notice_generation_from_batch => :environment do

