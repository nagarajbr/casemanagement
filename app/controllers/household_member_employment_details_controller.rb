# class HouseholdMemberEmploymentDetailsController < AttopAncestorController

# 	# Author: Manoj Patil
# 	# 11/19/2015
# 	# Description : This controller actions are called from Household member finance steps


# 	# 1.
# 	def household_member_employment_detail_index
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
#     	@employment = Employment.find(params[:employment_id])
#       	@employer_name = Employer.get_employer_name(@employment.employer_id)
# 		@employment_details =  @employment.employment_details
#   	rescue => err
#      	error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentDetailsController","household_member_employment_detail_index",err,current_user.uid)
#      	ls_msg = "Failed to show list of Employment details - for more details refer to Error ID: #{error_object.id}"
#      	flash[:alert] = ls_msg
#      	redirect_to_back
# 	end

# 	# 2.
# 	def new_household_member_employment_detail
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
#     	@employment = Employment.find(params[:employment_id])
#       	@employer_name = Employer.get_employer_name(@employment.employer_id)
# 	    @employment_detail = @employment.employment_details.new
#   	rescue => err
# 	    error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentDetailsController","new_household_member_employment_detail",err,current_user.uid)
# 	    ls_msg = "Failed to show new employment details - for more details refer to Error ID: #{error_object.id}"
# 	    flash[:alert] = ls_msg
# 	    redirect_to_back
# 	end

# 	# 3.
# 	def create_household_member_employment_detail
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
#     	@employment = Employment.find(params[:employment_id])
#       	@employer_name = Employer.get_employer_name(@employment.employer_id)
# 		l_emp_detail_params = employment_detail_params_values
# 		@employment_detail = @employment.employment_details.new(l_emp_detail_params)
# 		if @employment_detail.valid?
#       		ls_msg = EmploymentDetailService.save_employment_detail(@employment_detail,session[:CLIENT_ID])
#       		if ls_msg == "SUCCESS"
#         		redirect_to household_member_employment_detail_index_path(@client.id,@employment.id) , notice: "Employment detail saved"
#       		else
# 		        render :new_household_member_employment_detail
#       		end
#     	else
#       		render :new_household_member_employment_detail
#     	end
#   	rescue => err
# 	    error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentDetailsController","create_household_member_employment_detail",err,current_user.uid)
# 	    ls_msg = "Failed to create employment details - for more details refer to Error ID: #{error_object.id}"
# 	    flash[:alert] = ls_msg
# 	    redirect_to_back
# 	end

# 	# 4.
# 	def show_household_member_employment_detail
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
#     	@employment = Employment.find(params[:employment_id])
#       	@employer_name = Employer.get_employer_name(@employment.employer_id)
#     	@employment_detail = EmploymentDetail.find(params[:employment_detail_id])
#   	rescue => err
# 	    error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentDetailsController","show_household_member_employment_detail",err,current_user.uid)
# 	     ls_msg = "Failed to show employment details - for more details refer to Error ID: #{error_object.id}"
# 	    flash[:alert] = ls_msg
# 	    redirect_to_back
# 	end

# 	# 5.
# 	def edit_household_member_employment_detail
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
#     	@employment = Employment.find(params[:employment_id])
#       	@employer_name = Employer.get_employer_name(@employment.employer_id)
#     	@employment_detail = EmploymentDetail.find(params[:employment_detail_id])
#   	rescue => err
# 	    error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentDetailsController","edit_household_member_employment_detail",err,current_user.uid)
# 	    ls_msg = "Failed to edit employment details - for more details refer to Error ID: #{error_object.id}"
# 	    flash[:alert] = ls_msg
# 	    redirect_to_back
# 	end

# 	# 6.
# 	def update_household_member_employment_detail
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
#     	@employment = Employment.find(params[:employment_id])
#       	@employer_name = Employer.get_employer_name(@employment.employer_id)
#     	@employment_detail = EmploymentDetail.find(params[:employment_detail_id])

#     	l_param_values = employment_detail_params_values
#      	@employment_detail.assign_attributes(l_param_values)
# 	    if @employment_detail.valid?
# 	        ls_msg = EmploymentDetailService.update_employment_detail(@employment_detail,session[:CLIENT_ID])
# 	        if ls_msg == "SUCCESS"
# 	          redirect_to show_household_member_employment_detail_path(@client.id,@employment.id, @employment_detail.id) , notice: "Employment information saved"
# 	        else
# 	          render :edit_household_member_employment_detail
# 	        end
# 	    else
# 	        render :edit_household_member_employment_detail
# 	    end
#     rescue => err
#       error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentDetailsController","update_household_member_employment_detail",err,current_user.uid)
#        ls_msg = "Failed to save employment details - for more details refer to Error ID: #{error_object.id}"
#       flash[:alert] = ls_msg
#       redirect_to_back
# 	end

# 	# 7.
# 	def delete_household_member_employment_detail
# 		@household_member = HouseholdMember.find(params[:household_member_id])
# 		@client = Client.find(@household_member.client_id)
#     	@employment = Employment.find(params[:employment_id])
#       	@employer_name = Employer.get_employer_name(@employment.employer_id)
#     	@employment_detail = EmploymentDetail.find(params[:employment_detail_id])
# 	  	@employment_detail.destroy
# 	    redirect_to  household_member_employment_detail_index_path(@client.id,@employment.id), notice: "Employment information deleted"
# 	rescue => err
# 	    error_object = CommonUtil.write_to_attop_error_log_table("HouseholdMemberEmploymentDetailsController","delete_household_member_employment_detail",err,current_user.uid)
# 	    ls_msg = "Failed to delete employment details - for more details refer to Error ID: #{error_object.id}"
# 	    flash[:alert] = ls_msg
# 	    redirect_to_back
# 	end




# 	private


# 		def employment_detail_params_values
# 	         params.require(:employment_detail).permit(:effective_begin_date, :effective_end_date,
# 	                                                   :hours_per_period, :salary_pay_amt,
# 	                                                   :salary_pay_frequency,:position_type,
# 	                                                   :current_status)
# 	  	end

# end
