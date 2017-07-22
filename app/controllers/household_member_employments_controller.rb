# class HouseholdMemberEmploymentsController < AttopAncestorController
# 	# Author: Manoj Patil
# 	# 11/19/2015
# 	# Description : This controller actions are called from Household member finance steps

# 	# 1.
# 	def new_household_member_employment
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
# 		@employment = @client.employments.new
# 		@employer_list = Employer.all
# 	rescue => err
# 		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentsController","new_household_member_employment",err,current_user.uid)
# 		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Client"
# 		redirect_to_back
# 	end

# 	# 2.
# 	def create_household_member_employment

# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
# 		@employment = @client.employments.new(employment_params_values)
# 		@employer_list = Employer.all

# 		ls_msg = nil
# 		begin
#             ActiveRecord::Base.transaction do
# 				if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(@client.id)
# 					common_action_argument_object = CommonEventManagementArgumentsStruct.new
# 			        common_action_argument_object.client_id = @client.id
# 			        common_action_argument_object.model_object = @employment
# 			        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(@client.id)
# 			        common_action_argument_object.changed_attributes = @employment.changed_attributes().keys
# 			        common_action_argument_object.is_a_new_record = @employment.new_record?
# 			        common_action_argument_object.run_month = @employment.effective_begin_date
# 			        @employment.save!
# 					ls_msg = EventManagementService.process_event(common_action_argument_object)
# 				else
# 					if  @employment.save!
# 						ls_msg = "SUCCESS"
# 					else
# 						ls_msg ="Cannot create employment information"
# 					end
# 				end
# 			end
# 		rescue => err
# 	          	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentsController","create_household_member_employment",err,AuditModule.get_current_user.uid)
# 	          	ls_msg = "Failed to create Employment information - for more details refer to Error ID: #{error_object.id}"
# 		end
# 		if ls_msg == "SUCCESS"
# 			redirect_to start_household_finance_data_entry_wizard_path, notice: "Employment information saved"
# 		else
# 			if @employment.errors.full_messages.blank?
# 				flash.now[:alert] = ls_msg
# 			end
# 			render :new_household_member_employment
# 		end
# 	rescue => err
# 		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentsController","create_household_member_employment",err,current_user.uid)
# 		ls_msg = "Failed to create Employment information - for more details refer to Error ID: #{error_object.id}"
# 		flash[:alert] = ls_msg
# 		redirect_to_back
# 	end

# 	# 3.
# 	def show_household_member_employment
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
# 		@employment = Employment.find(params[:employment_id])
# 		@employer_name = Employer.get_employer_name(@employment.employer_id)
# 	rescue => err
# 		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentsController","show_household_member_employment",err,current_user.uid)
# 		ls_msg = "Failed to show Employment information - for more details refer to Error ID: #{error_object.id}"
# 		flash[:alert] = ls_msg
# 		redirect_to_back
# 	end

# 	# 4.
# 	def edit_household_member_employment
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
# 		@employment = Employment.find(params[:employment_id])
# 		@employer_list = Employer.all
# 	rescue => err
# 		error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentsController","edit_household_member_employment",err,current_user.uid)
# 		ls_msg = "Failed to edit Employment information - for more details refer to Error ID: #{error_object.id}"
# 		flash[:alert] = ls_msg
# 		redirect_to_back
# 	end

# 	# 5.
# 	def update_household_member_employment
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)

# 		@employment = Employment.find(params[:employment_id])

# 		@employer_list = Employer.all
# 		@employment.assign_attributes(employment_params_values)
# 		ls_msg = nil
# 		begin
#             ActiveRecord::Base.transaction do
# 				if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(@client.id)
# 					common_action_argument_object = CommonEventManagementArgumentsStruct.new
# 			        common_action_argument_object.client_id = @client.id
# 			        common_action_argument_object.model_object = @employment
# 			        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(@client.id)
# 			        common_action_argument_object.changed_attributes = @employment.changed_attributes().keys
# 			        common_action_argument_object.is_a_new_record = @employment.new_record?
# 			        common_action_argument_object.run_month = @employment.effective_begin_date
# 			        @employment.save!
# 					ls_msg = EventManagementService.process_event(common_action_argument_object)
# 				else
# 					if @employment.save!
# 						ls_msg ="SUCCESS"
# 					else
# 						ls_msg = "Cannot update employment information"
# 					end
# 				end
# 			end
# 		rescue => err
# 	          	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentsController","update_household_member_employment",err,AuditModule.get_current_user.uid)
# 	          	ls_msg = "Failed to update Employment information - for more details refer to Error ID: #{error_object.id}"
# 		end

# 		if ls_msg == "SUCCESS" || ls_msg.blank?
# 			redirect_to start_household_finance_data_entry_wizard_path, notice: "Employment information saved"
# 		else
# 			if @employment.errors.full_messages.blank?
# 				flash.now[:alert] = ls_msg
# 			end
# 		 	render :edit_household_member_employment
# 		end
# 	rescue => err
# 		error_object = CommonUtil.write_to_attop_error_log_table("EmploymentsController","update",err,current_user.uid)
# 		ls_msg = "Failed to update Employment information - for more details refer to Error ID: #{error_object.id}"
# 		flash[:alert] = ls_msg
# 		redirect_to_back
# 	end

# 	# 6.
# 	def delete_household_member_employment
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
# 		@employment = Employment.find(params[:employment_id])
# 		@employment.destroy
# 		redirect_to start_household_finance_data_entry_wizard_path, alert: "Employment information deleted"
# 	rescue => err
# 		error_object = CommonUtil.write_to_attop_error_log_table("EmploymentsController","destroy",err,current_user.uid)
# 		ls_msg = "Failed to delete Employment information - for more details refer to Error ID: #{error_object.id}"
# 		flash[:alert] = ls_msg
# 		redirect_to_back
# 	end

# 	private


# 		def employment_params_values
# 			params.require(:employment).permit(:effective_begin_date,:effective_end_date,
# 		  									   :position_title,:duties,:leave_reason,:employment_level,:placement_ind,
# 		  									   :health_ins_covered,:occupation_code,:employer_id
# 		  									 )
# 		end


# end
