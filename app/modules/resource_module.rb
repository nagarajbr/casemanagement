class ResourceModule


 def self.sum_resource(arg_str_budget)
   #Rails.logger.debug("Info = #{arg_str_budget.inspect}")

#  Decimal ldc_vehicle_amt, ldc_bs_amt, ldc_burial_amt, ldc_household_amt, ldc_burial_tot, ldc_bs_tot
# decimal ldc_household_tot, ldc_resource_tot, ldc_vehicle_tot, ldc_countable_res_tot
# decimal ldc_property_amt, ldc_property_tot
# String ls_cat_elig, ls_resource_type
# long ll_c_rows, ll_m_rows, ll_rows
# integer li_return, li_val_client_cnt = 0, li_cnt, li_cl_cnt
# n_ds lds_resources_by_clientid
# str_pass lstr_pass, lstr_pass1

# #Set instance variables
@istr_budget = arg_str_budget

@idb_rule_id = @istr_budget.rule_id
@idb_run_id = @istr_budget.run_id
@idb_bu_id = @istr_budget.budget_unit_id
@ii_service_program = @istr_budget.service_program_id
@is_bu_status = @istr_budget.budget_unit_status
@idb_b_details_id = @istr_budget.b_mem_details_id
@ii_res_id_cnt = 1
@ii_client_own_cnt = 1



 if @istr_budget.str_months.present?
 		#if @istr_budget.str_months[:month].present?
 		#	@istr_budget.str_months[:str_client].each do |client|
 		#		client.client_id
 		#	end
 		#end

		  @istr_budget.str_months.each do |budget_month|

            if budget_month.present?
			 	@id_budget_month = budget_month.month
			 	@ii_service_program = @istr_budget.service_program_id
			 	@idb_month_id = budget_month.month_id
			 	@idt_first_of_Month = @id_budget_month.to_datetime.beginning_of_month
			 	@idt_last_of_Month = @id_budget_month.to_datetime.end_of_month
			 	@iprogram_unit_id = @istr_budget.budget_unit_id

	    	end

		# 	//Reset Monthly totals
		 	ldc_bs_tot = 0
		 	ldc_burial_tot = 0
		 	ldc_household_tot = 0
		 	ldc_property_tot = 0
		 	ldc_vehicle_tot = 0
		 	ldc_countable_res_tot = 0

		# 	//Re-initialize the valid client array for the next month
		# 	For li_cnt = 1 to li_val_client_cnt
		# 		SetNull(idb_valid_clients[li_cnt])
		# 	Next
		 	li_val_client_cnt = 0
		 	@idb_valid_clients = Array.new

		# 	//Re-initialize the resource_id structure for the next month
		# 	For li_cnt = 1 to (@ii_res_id_cnt - 1)
		# 		SetNull(istr_joint_resources[li_cnt].resource_id)
		# 		SetNull(istr_joint_resources[li_cnt].percent_counted)
		# 		For li_cl_cnt = 1 to UpperBound(istr_joint_resources[li_cnt].client_id[])
		# 			SetNull(istr_joint_resources[li_cnt].client_id[li_cl_cnt])
		# 		Next
		# 	Next
		# 	@ii_res_id_cnt = 1
		# 	@ii_client_own_cnt = 1

		# 	// Process resources that are by client



		 	budget_month.str_client.each do |client|



		 		@idb_client_id = client.client_id
		 		@idb_member_id = client.member_id

		 		if client.client_status != 4471 #Inactive closed - member inactive, no income or resources counted
		 			li_val_client_cnt = li_val_client_cnt + 1
		 			@idb_valid_clients[li_val_client_cnt] = @idb_client_id  #// Saving off client ids that have valid member statuses - anything but Inactive - closed.
		 		else

		 		end



		 	end

                       # declare array variables
                       @istr_joint_resources = Array.new
                       client_array = Array.new

                       # Instantiate class/structure
                       @l_str_resource_object = StrJointResources.new
                       @l_str_resource_object.client_id = client_array

		 			ldc_vehicle_tot = determ_veh_for_tea()
		 			ldc_bs_tot = burial_space()
		 			Rails.logger.debug("Info5 = #{ldc_countable_res_tot.inspect}")
				 	ldc_countable_res_tot = countable_rule_res(@idb_valid_clients,@idt_first_of_Month,@idt_last_of_Month,@ii_service_program)
				 	ldc_resource_tot = (ldc_bs_tot.present? ? ldc_bs_tot : 0) + (ldc_household_tot.present? ? ldc_household_tot : 0) + (ldc_burial_tot.present? ? ldc_burial_tot : 0) + (ldc_property_tot.present? ? ldc_property_tot : 0) + (ldc_vehicle_tot.present? ? ldc_vehicle_tot : 0) + (ldc_countable_res_tot.present? ? ldc_countable_res_tot : 0) + (@istr_budget.str_months[0].income_as_res.present? ? @istr_budget.str_months[0].income_as_res : 0) # assumtion only one month

				 	Rails.logger.debug("Info3 = #{ldc_countable_res_tot.inspect}")
				 	Rails.logger.debug("Info4 = #{ldc_resource_tot.inspect}")
				 	determine_eligibility(ldc_resource_tot, budget_month.str_client.size) # Determine if they pass the resource test

		end
	end
return @istr_budget

end



 def self.countable_rule_res(arg_client_id,arg_first_of_month,arg_last_of_month,arg_service_program)
 # n_ds lds_countable_resources_rule,
 # lds_resource_disregards
 # decimal ldc_countable_res_tot, ldc_resource_amt, ldc_asset_total
 # String ls_resource_used = "N", ls_resource_type, ls_disregard_amt
 # long ll_disregard_rows
 # double ldb_client_id, ldb_resource_id
 # double ldb_max_str
 # str_pass lstr_pass, lstr_pass1, lstr_pass2, lstr_pass3
 # integer li_return, li_cnt, li_cnt2
 # long	ll_num_owners
 # decimal {3} ldc_percent
 # decimal	ldc_adj
 # string ls_sep_spouse
 # string ls_active_mem = "IN"
 # date	ld_resource_date
 # string ls_pass
 # string ls_use_code
 # n_ds lds_use_dupes
 # long ll_use_rows

# // This function uses some datwindows and datastores from the screenin.pbls //



 #ldb_max_str = (lstr_pass1.db) + 1




lds_countable_resources_rule = ClientResource.get_resource_details_for_a_client(arg_client_id, 15, arg_first_of_month, arg_last_of_month)




# //Initialize totals
 ldc_asset_total	= 0
 ll_num_owners = 1
# @istr_joint_resources = []
#if @istr_joint_resources.blank?
#	@istr_joint_resources = Array.new
#	@istr_joint_resources[0] = StrJointResources.new
#	@istr_joint_resources[0].client_id = Array.new
#end

# //****************************************************************************************************************
# //*  Total countable resources and apply any disregards
# //****************************************************************************************************************
 if lds_countable_resources_rule.present?



 	lds_countable_resources_rule.each do |resource|
 		ldb_resource_id = resource.id
 		ll_num_owners = resource.number_of_owners
 		ldb_client_id = resource.client_id
 		ls_resource_used = resource_used(ldb_resource_id, ldb_client_id)
 		@ii_client_own_cnt = 1

 		if ls_resource_used != "Y"
 			ls_resource_type = resource.resource_type
			ldc_resource_amt = resource.first_of_month_value
			ld_resource_date = resource.resource_valued_date
			ld_resource_date =ld_resource_date.to_datetime.beginning_of_month
			if ldc_resource_amt.present?
				else
				ldc_resource_amt = 0
			end
			ls_pass = "F"


# 			//Check for adjustments that should be deducted from the resource
 			ldc_adj = 0
 			ldc_adj = adjustments(ldb_resource_id, ld_resource_date, ls_pass)
 			ldc_resource_amt = ldc_resource_amt - ldc_adj
 			if ldc_resource_amt < 0
 			   ldc_resource_amt = 0
 			end


			lds_resource_disregards = Resource.get_resource_disregard(ldb_resource_id,@idb_rule_id)

 			if  lds_resource_disregards.present?
 				lds_resource_disregards.each do |disregard|
 					ls_use_code = disregard.resource_use_code

# 					//These uses will only cause a disregard if at least one owner who refuses to sell is
# 					//not active in the budget unit.
 					if ls_use_code == 3890 || ls_use_code == 3883
 						ls_active_mem = all_active_members(ldb_resource_id, ll_num_owners)
 					end



 					if ls_active_mem != "AC"
 						ls_disregard_amt = disregard.disregard_value

 						#If the disregard_amt is equal to "Full" make resources zero
 						if ls_disregard_amt == "00"
 							ldc_resource_amt = 0
 						end
 					end
 					ls_active_mem = "IN"
 				end
 			end

				ls_sep_spouse = "N"


 			if ls_sep_spouse == "N"
 				ldc_percent = joint_ownership(ls_resource_type, ll_num_owners, ldb_resource_id, ldb_client_id)
 				ldc_resource_amt = ldc_resource_amt * ldc_percent
 			else
 				ldc_percent = 1
 			end

# 			//401K, IRA, and Keogh Plan do not count for members with an Active-None status
             @istr_budget.str_months[0].str_client.each do |li_cnt2|

 				if ldb_client_id == li_cnt2.client_id
 					if li_cnt2.client_status == 4473 &&
 						(ls_resource_type == 2435 || ls_resource_type == 2463 || ls_resource_type == 2465)
 						ldc_resource_amt = 0
 					end
 				end
 			end

            #To be implemented
 			if ls_resource_used == "P"
   			@istr_joint_resources[@ii_used_res_id].percent_counted = @istr_joint_resources[@ii_used_res_id].percent_counted + (ldc_percent * 100)
 			@istr_joint_resources[@ii_used_res_id].client_id[@ii_client_own_cnt] = ldb_client_id
 		else
 			 @l_str_resource_object.resource_id = ldb_resource_id
 			 @l_str_resource_object.percent_counted = ldc_percent * 100
 			 @l_str_resource_object.client_id[@ii_client_own_cnt] = ldb_client_id

 			 @istr_joint_resources << @l_str_resource_object


 			# @istr_joint_resources[@ii_res_id_cnt].resource_id = ldb_resource_id
 			# @istr_joint_resources[@ii_res_id_cnt].percent_counted = ldc_percent * 100
 			# @istr_joint_resources[@ii_res_id_cnt].client_id[@ii_client_own_cnt] = ldb_client_id
 			@ii_res_id_cnt= @ii_res_id_cnt + 1
 		end

 			write_member_details(ls_resource_type, ldc_resource_amt, ldb_client_id)
 		else
 			ldc_resource_amt = 0
 		end

# 		//Calculate the Resource Total
 		ldc_asset_total = ldc_asset_total + ldc_resource_amt
 	end
 end



 return ldc_asset_total

 end


def self.resource_used(arg_resource_id, arg_client_id);
	li_res_cnt = 0
	li_client_cnt = 0
    ls_resource_used = "N"
    if @istr_joint_resources.size > 0


		 @istr_joint_resources.each do |li_res_cnt|

		 	if arg_resource_id == li_res_cnt.resource_id
		 		if li_res_cnt.percent_counted > 99
		 			ls_resource_used = "Y"

		 		else
		 			if li_res_cnt.percent_counted > 0

		 			   li_res_cnt.client_id.each do |li_client_cnt|

							if arg_client_id == li_client_cnt
								ls_resource_used = "Y"

							end
						end #Do
						ls_resource_used = "P"
						@ii_used_res_id = li_res_cnt
						@ii_client_own_cnt = li_res_cnt.client_id.size + 1

					end

		 		end
		 	end
	end
 end

 return ls_resource_used

end

def self.adjustments(arg_resource_detail_id, arg_resource_date, arg_value_ind)

 # long		ll_rows
 # long		ll_cnt
 # str_pass	lstr_pass
 # string	ls_adj_type
 # string	ls_allow_code
 # string	ls_count
 # date		ld_begin_date
 # date		ld_end_date
 # date		ld_date_received
 # date		ld_future_date
 # integer	li_num_months
 # decimal {2}	ldc_tot_adj = 0
 # decimal {2} ldc_adj_amt = 0




 lds_adj = ResourceAdjustment.get_resource_adjustment_for_a_detail(arg_resource_detail_id)

ldc_tot_adj = 0

if lds_adj.present?

	lds_adj.each do |adj|

 		ld_begin_date = adj.adj_begin_date
 		ld_end_date = adj.adj_end_date

 		if @id_budget_month >= ld_begin_date && (ld_end_date.blank? || @id_budget_month <= ld_end_date)
 			ldc_adj_amt = adj.resource_adj_amt
 			ld_date_received = adj.receipt_date
 			li_num_months = adj.adj_num_of_months
 			ls_adj_type = adj.reason_code

 			ls_allow_code = valid_adjustment(ls_adj_type)

 			case ls_allow_code
 				when 'AL'		#Allowed
 					ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
 				when 'BD'		#Allow the Begin Date/Month Only
 					if @id_budget_month.month == ld_begin_date.month  && @id_budget_month.year == ld_begin_date.year
 						if as_value_ind == "F" 		#If value is based on the first of month
 							if ld_date_received <= @id_budget_month
 								ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
 							end
 						else
 							ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
 						end
 					end
				when 'NM'		#Allow for a certain Number of Months
					if li_num_months.blank? || li_num_months == 0
						#//Don't count
					else
						ld_future_date = ld_begin_date + li_num_months.months

						if @id_budget_month.year <= ld_future_date.year
							if @id_budget_month.year == ld_future_date.year
								if ad_resource_date <= ld_future_date
									ls_count = "Y"
								else
									ls_count = "N"
								end
							else
								ls_count = "Y"
							end
						else
							ls_count = "N"
						end

						if ls_count == "Y"
							ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
						end
					end
				when '2M'		#Allow for a maximum of two months
					ld_future_date = ld_date_received +  1.month
					if (@id_budget_month.month == ld_date_received.month && @id_budget_month.year == ld_date_received.year)
						ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
					else
						if (@id_budget_month.month == ld_future_date.month && @id_budget_month.year == ld_future_date.year)
							ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
						end
					end
				when '02'		#Allow for two months from receipt
					ld_future_date = ld_date_received +  2.month
					if @id_budget_month <= ld_future_date
						ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
					end
				when '03'		#Allow for three months
					ld_future_date = ld_date_received +  3.month
					if @id_budget_month <= ld_future_date
						ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
					end
				when '06'		#Allow for six months
					ld_future_date = ld_date_received +  6.month
					if @id_budget_month <= ld_future_date
						ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
					end
				when '09'		#Allow for nine months
					ld_future_date = ld_date_received +  9.month
					if @id_budget_month <= ld_future_date
						ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
					end
				when '18'		#Allow for eighteen months
					ld_future_date = ld_date_received +  18.month
					if @id_budget_month <= ld_future_date
						ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
					end
				when '30'		#Allow for 30 days
					ld_future_date = ld_date_received +  30.days
					if @id_budget_month <= ld_future_date
						ldc_tot_adj = ldc_tot_adj + ldc_adj_amt
					end
				when 'NA'		#Not allowed
					#Do nothing, adjustment not allowed
 			end
 		end
	end
 end


return ldc_tot_adj


 end



def self.valid_adjustment(arg_adj_type)

	 case arg_adj_type
		when 4515,4517,4535,4537,4538,4551,4555,4558,4559,4568,4569,4570,4571
			ls_return = 'BD'
		when 4520,4521,4523,4524,4525,4554,4456,4457
			ls_return = 'NA'
		when arg_adj_type = 4549
			ls_return = '30'
		when arg_adj_type = 4550
			ls_return = '18'
		else
			ls_return = 'AL'
 		end
 	return ls_return
end

def self.all_active_members(arg_resource_id, arg_num_owners);
	lds_active_owners = ProgramBenefitMember.get_active_members_in_run_id_with_resources(@idb_run_id,@idb_month_id,arg_resource_id)
	 if lds_active_owners.pressent?

	    return ls_active_owners
	else
		return 0
	 end

end


def self.write_member_details(arg_resource_type, arg_resource_amt, arg_client_ind )

  ls_bmd_row_ind = "R"

	if arg_client_ind == 0   #// a client level function called this.
	# 	//Get the Budget Member ID for ids_client_info (clientstatus)
	 	ldb_member_id = @istr_budget.str_months[0].str_client[0].member_id #Assumption only one run
	else

	    @istr_budget.str_months[0].str_client.each do |client|

	 		 if client.present? && arg_client_ind == client.client_id
	 			ldb_member_id = client.member_id
		   		break
	 		 end
	 	end

	 end

	unless @istr_budget.screening == true
	    program_member_detail = ProgramMemberDetail.new
	    program_member_detail.run_id = @idb_run_id
		program_member_detail.month_sequence = @idb_month_id
		program_member_detail.member_sequence = ldb_member_id
		program_member_detail.bdm_row_indicator = ls_bmd_row_ind
		program_member_detail.item_type = arg_resource_type
		program_member_detail.dollar_amount = arg_resource_amt
		program_member_detail.b_details_sequence = @idb_b_details_id

		unless program_member_detail.save
			Rails.logger.debug("benefit_calculator.det_ckga_amt errored out on program_member_detail.save")
		end
	end
	@idb_b_details_id = @idb_b_details_id + 1
 return 1

end


def self.determ_veh_for_tea()

ldc_vehicle_tot = 0
lds_veh_tea = ClientResource.get_resource_vehicle_details_for_clients(@idb_valid_clients,@idt_first_of_Month,@idt_last_of_Month)
li_cnt = 1
 lds_veh_tea.each do |vehicle|

 	ls_resource_type =  vehicle.resource_type
 	ldb_client_id = vehicle.client_id
 	ldb_resource_id = vehicle.resource_detail_id
 	ll_num_owners = vehicle.amount_owned_on_resource
 	@ii_client_own_cnt = 0
 	ls_resource_used = resource_used(ldb_resource_id, ldb_client_id)
 	if ls_resource_used != "Y"

 		if li_cnt == 1
 			ldc_vehicle_value = 0
 		else
 			ldc_vehicle_value = vehicle.first_of_month_value
 		end
 		ld_resource_date = vehicle.resource_valued_date.beginning_of_month
# 		//Check for adjustments that should be deducted from the resource
 		ldc_adj = 0
 		ldc_adj = adjustments(ldb_resource_id, ld_resource_date, "F")
 		ldc_vehicle_value = ldc_vehicle_value - ldc_adj
 		if ldc_vehicle_value < 0
 			ldc_vehicle_value = 0
 		end

 		ldc_percent = joint_ownership(ls_resource_type, ll_num_owners, ldb_resource_id, ldb_client_id)
 		ldc_vehicle_value = ldc_vehicle_value * ldc_percent

 		if ls_resource_used == "P"
   			@istr_joint_resources[@ii_used_res_id].percent_counted = @istr_joint_resources[@ii_used_res_id].percent_counted + (ldc_percent * 100)
 			@istr_joint_resources[@ii_used_res_id].client_id[@ii_client_own_cnt] = ldb_client_id
 		else
 			 @l_str_resource_object.resource_id = ldb_resource_id
 			 @l_str_resource_object.percent_counted = ldc_percent * 100
 			 @l_str_resource_object.client_id[@ii_client_own_cnt] = ldb_client_id

 			 @istr_joint_resources << @l_str_resource_object


 			# @istr_joint_resources[@ii_res_id_cnt].resource_id = ldb_resource_id
 			# @istr_joint_resources[@ii_res_id_cnt].percent_counted = ldc_percent * 100
 			# @istr_joint_resources[@ii_res_id_cnt].client_id[@ii_client_own_cnt] = ldb_client_id
 			@ii_res_id_cnt= @ii_res_id_cnt + 1
 		end
 		write_member_details(ls_resource_type, ldc_vehicle_value, ldb_client_id)
 		ldc_vehicle_tot = ldc_vehicle_tot + ldc_vehicle_value
		li_cnt = li_cnt +1
 	end
 end

return ldc_vehicle_tot
end

def self.joint_ownership(arg_resource_type, arg_num_owners, arg_resource_id, arg_client_id)

	if arg_num_owners.present?
	else
		arg_num_owners = 1
	end

 if arg_num_owners > 1
# 	//Call function that determines if all of the owners are active in this budget
 	ls_active_owners = all_active_members(arg_resource_id, arg_num_owners)
 	ls_joint_ownership = joint_resources(arg_resource_type)

 	case ls_joint_ownership
 		when 'UP'
 			if ls_active_owners == 'IN'

		 	lds_usage_percent = get_resource_useage_percentage_for_client(idb_run_id,idb_month_id,adb_resource_id,adb_client_id)

				if lds_usage_percent.present?
					ldc_percentage = lds_usage_percent.firts.use_code
					ldc_percentage = ldc_percentage/100
				else
					ldc_percentage = 1
				end
			else
				ldc_percentage = 1
			end
		when 'NO'
			if ls_active_owners == 'IN'
			   ldc_percentage = 1/arg_num_owners
			else
				ldc_percentage = 1
			end
		when 'CA'
			ldc_percentage = 1
		 else
			ldc_percentage = 0
 	end
 else
 	ldc_percentage = 1
 end

 return ldc_percentage
end



def self.all_active_members(arg_resource_id, arg_num_owners);
	lds_active_owners = get_active_members_in_run_id_with_resources(@idb_run_id,@idb_month_id,arg_resource_id)
 	if lds_active_owners.present?
  		ll_inactive_owners = lds_active_owners.size
	end
	return ls_active_owners
end


def self.joint_resources(arg_resource_type);

 	case arg_resource_type
 			when 2435,2438,2431,2442,2428,2461,2463,2465,2477,2473,2440,2489,2492,2427,2491,2493,2430,2501
 				return 'UP'
 			when 2445,2450,2451,2453,2460,2467,2468,2471,2466,2474,2476,2479,2472,2429,2446,2481,2484,2441,2494,2502,2505,2504,2497,2500,2506,2478
 				return 'NO'
 			when 2444,2449,2426,2503
 				return 'CA'
 			else
 				return 'DI'
 		end

end


def self.burial_space()
	ldc_bs_amt = 0

li_num_clients = @idb_valid_clients.size



lds_burial_spaces = ClientResource.get_resource_burial_details_for_a_client(@idb_valid_clients,@idt_last_of_Month,@idt_first_of_Month)

if lds_burial_spaces.present?

 	if @ii_service_program ==1  ||  @ii_service_program == 4


 		ls_value_field = "first_of_month_val"
 		ls_pass = "F"

 	end



 	@ii_client_own_cnt = 1
 	li_used_cnt = 1

# 	// Disregard the first ll_num_clients Burial spots.  Count all the rest.
    lds_burial_spaces.each do |burial|


 		ldb_client_id = burial.client_id
 		ldb_resource_id = burial.resource_detail_id
 		ll_num_owners = burial.number_of_owners

# 		//Check to see if resource has been used by another client
 		ls_resource_used = resource_used(ldb_resource_id, ldb_client_id)

 		if ls_resource_used != "Y"

 			if li_used_cnt >= 2
 				ldc_burial_value = burial.resource_value
 			else
 				ldc_burial_value = 0
 			end

 			li_used_cnt = li_used_cnt + 1

 			ls_sep_spouse = "N"


 			if ls_value_field == "first_of_month_val"
 				ld_resource_date = burial.resource_valued_date.beginning_of_month

 			else
 				ld_resource_date = burial.resource_valued_date
 			end

# 			//Check for adjustments that should be deducted from the resource
 			ldc_adj = 0
 			ldc_adj = adjustments(ldb_resource_id, ld_resource_date, ls_pass)
 			ldc_burial_value = ldc_burial_value - ldc_adj
 			if ldc_burial_value < 0
 			   ldc_burial_value = 0
 			end

 			if ls_sep_spouse == "N"
 				ldc_percent = joint_ownership('BS', ll_num_owners, ldb_resource_id, ldb_client_id)
 				ldc_burial_value = ldc_burial_value * ldc_percent
 			else
 				ldc_percent = 1
 			end



 			if ls_resource_used == "P"
	   			@istr_joint_resources[@ii_used_res_id].percent_counted = @istr_joint_resources[@ii_used_res_id].percent_counted + (ldc_percent * 100)
	 			@istr_joint_resources[@ii_used_res_id].client_id[@ii_client_own_cnt] = ldb_client_id
 			else
	 			 @l_str_resource_object.resource_id = ldb_resource_id
	 			 @l_str_resource_object.percent_counted = ldc_percent * 100
	 			 @l_str_resource_object.client_id[@ii_client_own_cnt] = ldb_client_id
                 @istr_joint_resources << @l_str_resource_object
	 			# @istr_joint_resources[@ii_res_id_cnt].resource_id = ldb_resource_id
	 			# @istr_joint_resources[@ii_res_id_cnt].percent_counted = ldc_percent * 100
	 			# @istr_joint_resources[@ii_res_id_cnt].client_id[@ii_client_own_cnt] = ldb_client_id
	 			@ii_res_id_cnt= @ii_res_id_cnt + 1
 			end


 			write_member_details("BS", ldc_burial_value, ldb_client_id)
 			ldc_bs_amt = ldc_bs_amt + ldc_burial_value

 		end
 	end
end

	return ldc_bs_amt
end




def self.determine_eligibility(arg_resource_tot, ard_budget_unit_size)




			#// retrieve resource limit based on the service program id and bu size
 			ll_standards_id = 113
			lds_resource_standards = ProgramStandardDetail.get_program_limits(ll_standards_id,@idt_last_of_Month)

            if lds_resource_standards.present?
				ldc_resource_limit = lds_resource_standards.first.program_standard_limit_amount
			end



	Rails.logger.debug("Resource2#{arg_resource_tot}")
	Rails.logger.debug("Resource3#{ldc_resource_limit}")



     if arg_resource_tot.present? ||  ldc_resource_limit.present?
	 	if arg_resource_tot > ldc_resource_limit
	 		ls_eligibility = "N"
            if @istr_budget.screening == true
               @istr_budget.ineligible_codes << 6336
            else
	 		BenefitCalculator.insert_eligibility_determine_results(@idb_run_id,@idb_month_id,@iprogram_unit_id , 6336, "program_unit")
	 		end

	 	else
	 		ls_eligibility = "Y"
	 	end

	 	write_bu_mo_summary(arg_resource_tot, ls_eligibility)
 	end
end

def self.write_bu_mo_summary(arg_resource_tot, arg_eligibility_ind)

     li_return = ProgramMonthSummary.update_resource_details(@idb_run_id,@idb_month_id,arg_resource_tot,arg_eligibility_ind)
    return li_return
end



# public function decimal of_burial_insurance (datastore ads_resources)


# public function decimal of_household_to_count (datastore ads_resources)
# public function decimal of_burial_exclusion (datastore ads_resources)

# public subroutine of_determine_eligibility (decimal adc_resource_tot, integer ai_budget_unit_size)
# public function integer of_write_bu_mo_summary (decimal adc_resource_tot, string as_eligibility_ind)


# public function decimal of_get_veh_val_use (decimal adc_veh_value, decimal adc_veh_standard_ded)
# public function decimal of_get_veh_val_no_use (decimal adc_veh_value, decimal adc_veh_standard_ded, decimal adc_equity_value)

# public function string of_resource_used (double adb_resource_id, double adb_client_id)
# public function date of_future_date (date ad_date, integer ai_months)
# public function string of_same_serv_prog (double adb_client_id)
# public function decimal of_countable_rule_res ()
# public function long of_determ_standards_id (integer ai_bu_size, string as_aged)
# public function string of_joint_resources (string as_resource_type)
# public function decimal of_joint_ownership (string as_resource_type, long al_num_owners, double adb_resource_id, double adb_client_id)
# public function string of_valid_adjustment (string as_adj_type)

# public function decimal of_adjustments (double adb_resource_id, date ad_resource_date, string as_value_ind)
# public function integer of_sum_resources (str_budget astr_budget)
# end prototypes

# public function decimal of_burial_insurance (datastore ads_resources);// Disregard $1500 of Burial insurance related resources (resource types BI and PR) for each client.

# decimal ldc_burial_ins_amt = 0, ldc_burial_exclusion = 1500, ldc_burial_tot = 0
# integer li_cnt, li_rows, li_return
# string ls_resource_type
# decimal {3}	ldc_percent
# long	ll_num_owners
# double ldb_client_id
# double ldb_resource_id
# string ls_resource_used
# date	ld_resource_date
# decimal ldc_adj

# // Filter the ads_resources ds by types "BI" and "PR" for the client.
# ads_resources.SetFilter("t_asset_resource_type = 'BI' OR t_asset_resource_type = 'PR'")
# ads_resources.Filter()
# li_rows = ads_resources.RowCount()

# For li_cnt = 1 to li_rows
# 	ls_resource_type = ads_resources.GetItemString(li_cnt, "t_asset_resource_type")
# 	ldc_burial_ins_amt = ads_resources.GetItemNumber(li_cnt, "t_asset_res_detail_resource_value")
# 	ll_num_owners = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_number_of_owners")
# 	ldb_client_id = ads_resources.GetItemNumber(li_cnt, "t_client_asset_res_clientid")
# 	ldb_resource_id = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_asset_resourceid")
# 	ii_client_own_cnt = 1

# 	//Check to see if resource has been used by another client
# 	ls_resource_used = of_resource_used(ldb_resource_id, ldb_client_id)

# 	If ls_resource_used <> "Y" Then
# 		If isNull(ldc_burial_ins_amt) then ldc_burial_ins_amt = 0

# 		ld_resource_date = Date(ads_resources.GetItemDateTime(li_cnt, "t_asset_res_detail_res_valued_date"))

# 		//Check for adjustments that should be deducted from the resource
# 		ldc_adj = 0
# 		ldc_adj = of_adjustments(ldb_resource_id, ld_resource_date, "A")
# 		ldc_burial_ins_amt = ldc_burial_ins_amt - ldc_adj
# 		If ldc_burial_ins_amt < 0 Then ldc_burial_ins_amt = 0

# 		//Call function to determine percentage of resource to count
# 		ldc_percent = of_joint_ownership(ls_resource_type, ll_num_owners, ldb_resource_id, ldb_client_id)
# 		ldc_burial_ins_amt = ldc_burial_ins_amt * ldc_percent

# 		If ldc_burial_ins_amt >= ldc_burial_exclusion then
# 			ldc_burial_ins_amt = ldc_burial_ins_amt - ldc_burial_exclusion
# 			ldc_burial_exclusion = 0
# 		Else
# 			ldc_burial_exclusion = ldc_burial_exclusion - ldc_burial_ins_amt
# 			ldc_burial_ins_amt = 0
# 		End if

# 		//If resource has been partially used by another client, total the percentage and add this client to the array.
# 		If ls_resource_used = "P" Then
# 			istr_joint_resources[ii_used_res_id].percent_counted = istr_joint_resources[ii_used_res_id].percent_counted + (ldc_percent * 100)
# 			istr_joint_resources[ii_used_res_id].client_id[ii_client_own_cnt] = ldb_client_id
# 		Else
# 			istr_joint_resources[@ii_res_id_cnt].resource_id = ldb_resource_id
# 			istr_joint_resources[@ii_res_id_cnt].percent_counted = ldc_percent * 100
# 			istr_joint_resources[@ii_res_id_cnt].client_id[ii_client_own_cnt] = ldb_client_id
# 			@ii_res_id_cnt++
# 		End if

# 		li_return = of_write_bmem_details(ls_resource_type, ldc_burial_ins_amt, 0)
# 		ldc_burial_tot = ldc_burial_tot + ldc_burial_ins_amt

# 	End if
# Next

# ads_resources.SetFilter("")  // unfilter the datastore.
# ads_resources.Filter()

# Return ldc_burial_tot  // Return the burial amount to count after the $1500 exclusion.

# //***********************************************************************
# //*  Release  	Date     Task         	Author                           *
# //*  Description                                                        *
# //***********************************************************************
# //*  4.003   8/7/2000  ANSWER      J. DeVitto                           *
# //*  Created function to disregard $1500 of burial insurance resources. *
# //*  Enh. 1077.                                                         *
# //***********************************************************************
# //*  4.008		08/29/00	ANSWER			Jennifer Kelch							*
# //*  Added code to handle jointly owned resources and adjustments to 	*
# //*  resources. Enh 1077 - Phase III												*
# //***********************************************************************
# end function




# public function decimal of_household_to_count (datastore ads_resources);//****************************************************************************************
# //*  This function was created to determine the amount of the Household resources   to   *
# //*  count for each client.  $1000 of Household resources with type "PP" or "JW" can be  *
# //*  disregarded and the remainder must be counted as a resource.                        *
# //*  J. DeVitto                    Enh. 1077        												  *
# //****************************************************************************************

# decimal ldc_household_amt = 0, ldc_household_exclusion = 1000, ldc_household_tot = 0
# integer li_cnt, li_rows, li_return
# string ls_resource_type
# decimal {3} ldc_percent
# long ll_num_owners
# double ldb_client_id
# double ldb_resource_id
# string ls_resource_used
# date ld_resource_date
# decimal ldc_adj

# // Filter the ads_resources ds by types Jewelry and Personal Property for the client.
# ads_resources.SetFilter("t_asset_resource_type = 'JW' OR t_asset_resource_type = 'PP'")
# ads_resources.Filter()
# li_rows = ads_resources.RowCount()

# For li_cnt = 1 to li_rows
# 	ls_resource_type = ads_resources.GetItemString(li_cnt, "t_asset_resource_type")
# 	ldc_household_amt = ads_resources.GetItemNumber(li_cnt, "t_asset_res_detail_first_of_month_val")
# 	ll_num_owners = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_number_of_owners")
# 	ldb_client_id = ads_resources.GetItemNumber(li_cnt, "t_client_asset_res_clientid")
# 	ldb_resource_id = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_asset_resourceid")
# 	ii_client_own_cnt = 1

# 	ls_resource_used = of_resource_used(ldb_resource_id, ldb_client_id)

# 	If ls_resource_used <> "Y" Then

# 		If IsNull(ldc_household_amt) then ldc_household_amt = 0

# 		If ldc_household_amt >= ldc_household_exclusion then
# 			ldc_household_amt = ldc_household_amt - ldc_household_exclusion
# 			ldc_household_exclusion = 0
# 		Else
# 			ldc_household_exclusion = ldc_household_exclusion - ldc_household_amt
# 			ldc_household_amt = 0
# 		End if

# 		ld_resource_date = Date(ads_resources.GetItemDateTime(li_cnt, "t_asset_res_detail_res_valued_date"))

# 		//Check for adjustments that should be deducted from the resource
# 		ldc_adj = 0
# 		ldc_adj = of_adjustments(ldb_resource_id, ld_resource_date, "F")
# 		ldc_household_amt = ldc_household_amt - ldc_adj
# 		If ldc_household_amt < 0 Then ldc_household_amt = 0

# 		ldc_percent = of_joint_ownership(ls_resource_type, ll_num_owners, ldb_resource_id, ldb_client_id)
# 		ldc_household_amt = ldc_household_amt * ldc_percent

# 		If ls_resource_used = "P" Then
# 			istr_joint_resources[ii_used_res_id].percent_counted = istr_joint_resources[ii_used_res_id].percent_counted + (ldc_percent * 100)
# 			istr_joint_resources[ii_used_res_id].client_id[ii_client_own_cnt] = ldb_client_id
# 		Else
# 			istr_joint_resources[@ii_res_id_cnt].resource_id = ldb_resource_id
# 			istr_joint_resources[@ii_res_id_cnt].percent_counted = ldc_percent * 100
# 			istr_joint_resources[@ii_res_id_cnt].client_id[ii_client_own_cnt] = ldb_client_id
# 			@ii_res_id_cnt++
# 		End if

# 		li_return = of_write_bmem_details(ls_resource_type, ldc_household_amt, 0)
# 		ldc_household_tot = ldc_household_tot + ldc_household_amt

# 	End if
# Next

# ads_resources.SetFilter("")  // unfilter the datastore.
# ads_resources.Filter()

# Return ldc_household_tot  // Return the Household resource amount to count after the $1000 exclusion.

# //***********************************************************************
# //*  Release  	Date     Task         	Author                           *
# //*  Description                                                        *
# //***********************************************************************
# //*  4.003    8/7/2000       ANSWER               J. DEVITTO				*
# //*  This function was created to determine the amount of the Household *
# //*  resources to count for each client.  $1000 of Household resources 	*
# //*  with type "PP" or "JW" can be disregarded and the remainder must 	*
# //*  be counted as a resource. Enh. 1077  										*
# //***********************************************************************
# //*  4.008		08/29/00	ANSWER			Jennifer Kelch							*
# //*  Added code to handle jointly owned resources and adjustments to		*
# //*  resources. Enh 1077 - Phase III												*
# //***********************************************************************

# end function

# public function decimal of_burial_exclusion (datastore ads_resources);// Disregard $1500 (Burial exclusion) of the Burial related resources for each client.
# // There is a specific ordering in which the exclusion must be given
# // First to valid Life Insurance
# // Second to Valid irrevocable contracts
# // Third to valid prepaid revocable contracts
# // And lastly to any resources with the use = Burial


# decimal ldc_resource_amt = 0, ldc_burial_exclusion = 1500, ldc_face_tot = 0, ldc_face_value, ldc_burial_tot
# decimal ldc_ir_value
# integer li_cnt, li_rows, li_return, li_used_cnt
# string ls_resource_type
# str_pass lstr_pass, lstr_pass1, lstr_pass2
# n_ds lds_life_ins_burial, lds_res_use_burial
# decimal {3}	ldc_percent
# long	ll_num_owners
# double ldb_client_id
# string ls_resource_used = "N"
# double ldb_resource_id
# integer li_res_cnt
# string ls_filter = "t_asset_resource_type = '40' and resourceid Not In("
# str_partial_used	lstr_partial_used
# integer	li_partial_cnt = 1
# date	ld_resource_date
# decimal	ldc_adj

# //*************************************************************************************************************
# // First - LI
# // Filter the ads_resources ds by types "40" life insurance CSV.
# //************************************************************************************************************

# ads_resources.SetFilter("t_asset_resource_type = '40'")
# ads_resources.Filter()

# ads_resources.SetSort("t_asset_res_detail_res_valued_date A")
# ads_resources.Sort()

# li_rows = ads_resources.RowCount()

# If li_rows > 0 then
# 	li_used_cnt = 1
# 	For li_cnt = 1 to li_rows
# 		ls_resource_type = ads_resources.GetItemString(li_cnt, "t_asset_resource_type")
# 		ldb_client_id = ads_resources.GetItemNumber(li_cnt, "t_client_asset_res_clientid")
# 		ldb_resource_id = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_asset_resourceid")

# 		//J Kelch 8/29/00 - Resource could have been partially used by another client.
# 		ls_resource_used = of_resource_used(ldb_resource_id, ldb_client_id)

# 		If ls_resource_used <> "Y" Then

# 			ldc_face_value = ads_resources.GetItemNumber(li_cnt, "t_asset_res_detail_res_ins_face_value")
# 			lstr_pass.db[li_used_cnt] = ads_resources.GetItemNumber(li_cnt, "t_asset_res_detail_asset_res_dtl_id")
# 			ld_resource_date = Date(ads_resources.GetItemDateTime(li_cnt, "t_asset_res_detail_res_valued_date"))
# 			ld_resource_date = Date(String(Month(ld_resource_date), "00") + "-01-" + String(Year(ld_resource_date), "0000"))

# 			//Check for adjustments that should be deducted from the resource
# 			ldc_adj = 0
# 			ldc_adj = of_adjustments(ldb_resource_id, ld_resource_date, "F")
# 			ldc_face_value = ldc_face_value - ldc_adj
# 			If ldc_face_value < 0 Then ldc_face_value = 0

# 			li_used_cnt ++

# 			//J Kelch 8/29/00
# 			ldc_percent = of_joint_ownership(ls_resource_type, ll_num_owners, ldb_resource_id, ldb_client_id)
# 			ldc_face_value = ldc_face_value * ldc_percent

# 			//If resource has been partially used, store the resource id, and indexes of where the resource is located
# 			If ls_resource_used = "P" Then
# 				lstr_partial_used.resource_id[li_partial_cnt] = ldb_resource_id
# 				lstr_partial_used.res_id_cnt[li_partial_cnt] = ii_used_res_id
# 				lstr_partial_used.client_own_cnt[li_partial_cnt] = ii_client_own_cnt
# 				li_partial_cnt ++
# 			End if

# 			If isNull(ldc_face_value) then ldc_face_value = 0

# 			ldc_Face_tot = ldc_face_tot + ldc_face_value
# 		Else
# 			//Filter out resources that have been used by a previous client
# 			If li_cnt = li_rows Then
# 				ls_filter = ls_filter + String(ldb_resource_id)
# 			Else
# 				ls_filter = ls_filter + String(ldb_resource_id) + ","
# 			End if
# 		End if
# 		ls_resource_used = "N"
# 	Next

# 	ii_client_own_cnt = 1

# 	If ls_filter <> "t_asset_resource_type = '40' and resourceid Not In(" Then
# 		ls_filter = ls_filter + ")"
# 		ads_resources.SetFilter(ls_filter)
# 		ads_resources.Filter()
# 	End if

# 	If ldc_face_tot <= ldc_burial_exclusion then

# 		ldc_burial_exclusion = ldc_burial_exclusion - ldc_face_tot
# 		ldc_burial_tot = 0
# 		li_return = of_write_bmem_details(ls_resource_type, ldc_burial_tot, 0)

# 		li_used_cnt --		//Set cnt back to last used index

# 		For li_cnt = 1 to li_used_cnt
# 			ldb_client_id = ads_resources.GetItemNumber(li_cnt, "t_client_asset_res_clientid")
# 			ldb_resource_id = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_asset_resourceid")

# 			//Check to see if this resource has been partially used
# 			For li_partial_cnt = 1 to UpperBound(lstr_partial_used.resource_id[])
# 				If lstr_partial_used.resource_id[li_partial_cnt] = ldb_resource_id Then
# 					ii_used_res_id = lstr_partial_used.res_id_cnt[li_partial_cnt]
# 					ii_client_own_cnt = lstr_partial_used.client_own_cnt[li_partial_cnt]

# 					istr_joint_resources[ii_used_res_id].percent_counted = istr_joint_resources[ii_used_res_id].percent_counted + (ldc_percent * 100)
# 					istr_joint_resources[ii_used_res_id].client_id[ii_client_own_cnt] = ldb_client_id
# 					Exit
# 				End if
# 			Next

# 			//If it hasn't already been partially used, store as a new resource
# 			If li_partial_cnt = UpperBound(lstr_partial_used.resource_id[]) + 1 Then
# 				istr_joint_resources[@ii_res_id_cnt].resource_id = ldb_resource_id
# 				istr_joint_resources[@ii_res_id_cnt].percent_counted = ldc_percent * 100
# 				istr_joint_resources[@ii_res_id_cnt].client_id[ii_client_own_cnt] = ldb_client_id
# 				@ii_res_id_cnt ++
# 			End if

# 		Next
# 		//J Kelch 10/31/00 Took out the ElseIf for defect 1994
# 	End if
# End if

# ads_resources.SetFilter("")  // unfilter the datastore.
# ads_resources.Filter()


# //************************************************************************************************************
# //*  Second - Irrevocable Contracts  types "PI" Prepaid irrevocable and "RO" Irrevocable owned by other      *
# //************************************************************************************************************

# ads_resources.SetFilter("t_asset_resource_type = 'PI' OR t_asset_resource_type = 'RO'")
# ads_resources.Filter()
# li_rows = ads_resources.RowCount()

# For li_cnt = 1 to li_rows
# 	ls_resource_type = ads_resources.GetItemString(li_cnt, "t_asset_resource_type")
# 	ldc_ir_value = ads_resources.GetItemNumber(li_cnt, "t_asset_res_detail_first_of_month_val")
# 	ldb_client_id = ads_resources.GetItemNumber(li_cnt, "t_client_asset_res_clientid")
# 	ldb_resource_id = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_asset_resourceid")
# 	ll_num_owners = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_number_of_owners")

# 	//J Kelch 8/29/00 - Resource could have been partially used by another client.
# 	ls_resource_used = of_resource_used(ldb_resource_id, ldb_client_id)

# 	If ls_resource_used <> "Y" Then
# 		If isNull(ldc_ir_value) then ldc_ir_value = 0

# 		ld_resource_date = Date(ads_resources.GetItemDateTime(li_cnt, "t_asset_res_detail_res_valued_date"))
# 		ld_resource_date = Date(String(Month(ld_resource_date), "00") + "-01-" + String(Year(ld_resource_date), "0000"))

# 		//Check for adjustments that should be deducted from the resource
# 		ldc_adj = 0
# 		ldc_adj = of_adjustments(ldb_resource_id, ld_resource_date, "F")
# 		ldc_ir_value = ldc_ir_value - ldc_adj
# 		If ldc_ir_value < 0 Then ldc_ir_value = 0

# 		ldc_percent = of_joint_ownership(ls_resource_type, ll_num_owners, ldb_resource_id, ldb_client_id)
# 		ldc_ir_value = ldc_ir_value * ldc_percent

# 		If ldc_ir_value >= ldc_burial_exclusion then
# 			ldc_burial_exclusion = 0
# 		Else
# 			ldc_burial_exclusion = ldc_burial_exclusion - ldc_ir_value
# 		End if

# 		ldc_resource_amt = 0 // Never count irrevocable contract as a resource.
# 		li_return = of_write_bmem_details(ls_resource_type, ldc_resource_amt, 0)

# 		//If resource has been partially used by another client, total up percentage used, and add this client to the array
# 		If ls_resource_used = "P" then
# 			istr_joint_resources[ii_used_res_id].percent_counted = istr_joint_resources[ii_used_res_id].percent_counted + (ldc_percent * 100)
# 			istr_joint_resources[ii_used_res_id].client_id[ii_client_own_cnt] = ldb_client_id
# 		Else
# 			istr_joint_resources[@ii_res_id_cnt].resource_id = ldb_resource_id
# 			istr_joint_resources[@ii_res_id_cnt].percent_counted = ldc_percent * 100
# 			istr_joint_resources[@ii_res_id_cnt].client_id[ii_client_own_cnt] = ldb_client_id
# 			@ii_res_id_cnt++
# 		End if

# 	End if
# 	ls_resource_used = "N"
# Next

# ii_client_own_cnt = 1

# ads_resources.SetFilter("")  // unfilter the datastore.
# ads_resources.Filter()

# //******************************************************************************************************************
# //*  Third - Revocable Contracts - type "PR"																								 *
# //******************************************************************************************************************

# ads_resources.SetFilter("t_asset_resource_type = 'PR'")
# ads_resources.Filter()
# li_rows = ads_resources.rowcount()

# For li_cnt = 1 to li_rows
# 	ls_resource_type = ads_resources.GetItemString(li_cnt, "t_asset_resource_type")
# 	ldc_resource_amt = ads_resources.GetItemNumber(li_cnt, "t_asset_res_detail_first_of_month_val")
# 	ll_num_owners = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_number_of_owners")
# 	ldb_client_id = ads_resources.GetItemNumber(li_cnt, "t_client_asset_res_clientid")
# 	ldb_resource_id = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_asset_resourceid")

# 	//J Kelch 8/29/00 - Resource could have been partially used by another client.
# 	ls_resource_used = of_resource_used(ldb_resource_id, ldb_client_id)

# 	If ls_resource_used <> "Y" Then

# 		If isNull(ldc_resource_amt) then ldc_resource_amt = 0

# 		ld_resource_date = Date(ads_resources.GetItemDateTime(li_cnt, "t_asset_res_detail_res_valued_date"))
# 		ld_resource_date = Date(String(Month(ld_resource_date), "00") + "-01-" + String(Year(ld_resource_date), "0000"))

# 		//Check for adjustments that should be deducted from the resource
# 		ldc_adj = 0
# 		ldc_adj = of_adjustments(ldb_resource_id, ld_resource_date, "F")
# 		ldc_resource_amt = ldc_resource_amt - ldc_adj
# 		If ldc_resource_amt < 0 Then ldc_resource_amt = 0

# 		ldc_percent = of_joint_ownership(ls_resource_type, ll_num_owners, ldb_resource_id, ldb_client_id)
# 		ldc_resource_amt = ldc_resource_amt * ldc_percent

# 		If ldc_resource_amt >= ldc_burial_exclusion then
# 			ldc_resource_amt = ldc_resource_amt - ldc_burial_exclusion
# 			ldc_burial_exclusion = 0
# 		Else
# 			ldc_burial_exclusion = ldc_burial_exclusion - ldc_resource_amt
# 			ldc_resource_amt = 0
# 		End if

# 		//If resource has been partially used by another client, total up percentage used, and add this client to the array
# 		If ls_resource_used = "P" Then
# 			istr_joint_resources[ii_used_res_id].percent_counted = istr_joint_resources[ii_used_res_id].percent_counted + (ldc_percent * 100)
# 			istr_joint_resources[ii_used_res_id].client_id[ii_client_own_cnt] = ldb_client_id
# 		Else
# 			istr_joint_resources[@ii_res_id_cnt].resource_id = ldb_resource_id
# 			istr_joint_resources[@ii_res_id_cnt].percent_counted = ldc_percent * 100
# 			istr_joint_resources[@ii_res_id_cnt].client_id[ii_client_own_cnt] = ldb_client_id
# 			@ii_res_id_cnt++
# 		End if

# 		li_return = of_write_bmem_details(ls_resource_type, ldc_resource_amt,0)
# 		ldc_burial_tot = ldc_burial_tot + ldc_resource_amt

# 	End if
# 	ls_resource_used = "N"
# Next

# ii_client_own_cnt = 1

# ads_resources.SetFilter("")  // unfilter the datastore.
# ads_resources.Filter()

# //*******************************************************************************************************************
# //* Last thing to do - Check all resources that have not already been processed for use = Burial                    *
# //*******************************************************************************************************************

# li_rows = ads_resources.RowCount()
# // Sort to ensure that you process the resources in the same order each time.
# ads_resources.SetSort("t_asset_resource_type A")
# ads_resources.Sort()

# If li_rows > 0 then

# lds_res_use_burial = Create ds_res_use_burial
# lds_res_use_burial.SetTransobject(SQLCA)

# For li_cnt = 1 to li_rows
# 	ls_resource_type = ads_resources.GetItemString(li_cnt, "t_asset_resource_type")
# 	ldc_resource_amt = ads_resources.GetItemNumber(li_cnt, "t_asset_res_detail_first_of_month_val")
# 	ll_num_owners = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_number_of_owners")
# 	ldb_client_id = ads_resources.GetItemNumber(li_cnt, "t_client_asset_res_clientid")
# 	ldb_resource_id = ads_resources.GetItemNumber(li_cnt, "t_asset_resource_asset_resourceid")
# 	ii_client_own_cnt = 1

# 	If isNull(ldc_resource_amt) then ldc_resource_amt = 0

# 	//J Kelch 8/29/00 - Resource could have been partially used by another client.
# 	ls_resource_used = of_resource_used(ldb_resource_id, ldb_client_id)

# 	If ls_resource_used <> "Y" then  // If resource has not already been processed then continue to process else skip to next.
# 		lstr_pass2.db[1] = ldb_resource_id
# 		lstr_pass2.db[2] = ads_resources.GetItemNumber(li_cnt, "t_asset_res_detail_asset_res_dtl_id")

# 		// This datastore will retrieve all rows with use = Burial for this detail record.
# 		li_return = gnv_data_access_service.Retrieve(lds_res_use_burial, lds_res_use_burial, "Reub_l", lstr_pass2)

#    	If li_return > 0 then  // Apply the burial exclusion.

# 			ld_resource_date = Date(ads_resources.GetItemDateTime(li_cnt, "t_asset_res_detail_res_valued_date"))
# 			ld_resource_date = Date(String(Month(ld_resource_date), "00") + "-01-" + String(Year(ld_resource_date), "0000"))

# 			//Check for adjustments that should be deducted from the resource
# 			ldc_adj = 0
# 			ldc_adj = of_adjustments(ldb_resource_id, ld_resource_date, "F")
# 			ldc_resource_amt = ldc_resource_amt - ldc_adj
# 			If ldc_resource_amt < 0 Then ldc_resource_amt = 0

# 			ldc_percent = of_joint_ownership(ls_resource_type, ll_num_owners, ldb_resource_id, ldb_client_id)
# 			ldc_resource_amt = ldc_resource_amt * ldc_percent

# 			//Do not count 401K, IRA, or Keogh Plan for clients with a status of Active-None.
# 			If istr_budget.str_months[ii_m_cnt].str_client[ii_c_cnt].client_status = "06" And &
# 				(ls_resource_type = "4K" Or ls_resource_type = "IR" Or ls_resource_type = "KP") Then
# 				ldc_percent = 1
# 				ldc_resource_amt = 0
# 			End if

# 			If ldc_resource_amt >= ldc_burial_exclusion then
# 				ldc_resource_amt = ldc_resource_amt - ldc_burial_exclusion
# 				ldc_burial_exclusion = 0
# 			Else
# 				ldc_burial_exclusion = ldc_burial_exclusion - ldc_resource_amt
# 				ldc_resource_amt = 0
# 			End if

# 			//If resource has been partially used by another client, total up percentage used, and add this client to the array
# 			If ls_resource_used = "P" then
# 				istr_joint_resources[ii_used_res_id].percent_counted = istr_joint_resources[ii_used_res_id].percent_counted + (ldc_percent * 100)
# 				istr_joint_resources[ii_used_res_id].client_id[ii_client_own_cnt] = ldb_client_id
# 			Else
# 				istr_joint_resources[@ii_res_id_cnt].resource_id = ldb_resource_id
# 				istr_joint_resources[@ii_res_id_cnt].percent_counted = ldc_percent * 100
# 				istr_joint_resources[@ii_res_id_cnt].client_id[ii_client_own_cnt] = ldb_client_id
# 				@ii_res_id_cnt++
# 			End if

# 			li_return = of_write_bmem_details(ls_resource_type, ldc_resource_amt, 0)
# 			ldc_burial_tot = ldc_burial_tot + ldc_resource_amt

# 		End if
# 	End if
# 	ls_resource_used = "N"

# Next

# Destroy lds_res_use_burial

# ads_resources.SetFilter("")  // unfilter the datastore.
# ads_resources.Filter()

# End if

# Return ldc_burial_tot

# //***********************************************************************
# //*  Release  	Date     Task         	Author                           *
# //*  Description                                                        *
# //***********************************************************************
# //*  4.003   8/7/2000  ANSWER      J. DeVitto                           *
# //*  Created function to which burial related resources to disregard    *
# //*  for the AABD service programs.  Enh. 1077.                         *
# //***********************************************************************
# //*  4.008		08/29/00	ANSWER			Jennifer Kelch							*
# //*  Added code to handle jointly owned resources, adjustments to 		*
# //*  resources, and the disregard of certain resources for clients with	*
# //*  a status of Active-None. Enh 1077 - Phase III								*
# //***********************************************************************
# //*  4.010   10/31/2000	ANSWER			Jennifer Kelch							*
# //*  Took out the ElseIf for step one of the process.  Life insurance	*
# //*  policies should only be used in step one if the total face value	*
# //*  of all resources of type Life Insurance CSV is less than $1500.		*
# //*  If the total is over $1500, the only way these policies will be		*
# //*  used for the exclusion is if the policy has a use of burial.	These	*
# //*  will be used in step four of the process.  Defect 1994					*
# //***********************************************************************
# end function



#


# public function decimal of_get_veh_val_use (decimal adc_veh_value, decimal adc_veh_standard_ded);decimal ldc_resource_value

# If adc_veh_value > adc_veh_standard_ded then
# 	ldc_resource_value = adc_veh_value - adc_veh_standard_ded
# Else
# 	ldc_resource_value = 0
# End if


# Return ldc_resource_value

# //***********************************************************************
# //*  Release  	Date     Task         	Author                           *
# //*  Description                                                        *
# //***********************************************************************
# //*  4.003   8/7/2000  ANSWER      J. DeVitto                           *
# //*  Created function to determine the vehicle value to count if there 	*
# //*  is a valid use. This is called from the of_det_veh_fs function. 	*
# //*  Enh. 1077.               														*
# //***********************************************************************
# end function

# public function decimal of_get_veh_val_no_use (decimal adc_veh_value, decimal adc_veh_standard_ded, decimal adc_equity_value);decimal ldc_resource_value


# ldc_resource_value = adc_veh_value - adc_veh_standard_ded
# If ldc_resource_value > adc_equity_value then
# Else
# 	ldc_resource_value = adc_equity_value
# End if

# Return ldc_resource_value

# //***********************************************************************
# //*  Release  	Date     Task         	Author                           *
# //*  Description                                                        *
# //***********************************************************************
# //*  4.003   8/7/2000  ANSWER      J. DeVitto                           *
# //*  Created function to determine the vehicle value to count if there	*
# //*  is no valid use.  This is called from the of_det_veh_fs function. 	*
# //*  Enh. 1077.                                       						*
# //***********************************************************************
# end function





# public function date of_future_date (date ad_date, integer ai_months);date		ld_future_date
# string 	ls_date
# integer	li_month
# integer	li_day
# n_cst_datetime	lnv_datetime

# ld_future_date = f_future_date(ad_date, "M", ai_months)

# li_day = Day(ad_date)
# li_month = Month(ld_future_date)

# Choose Case li_month
# 	Case 4, 6, 9, 11
# 		If li_day > 30 Then li_day = 30
# 	Case 2
# 		If lnv_datetime.of_isLeapYear(ld_future_date) = True Then
# 			If li_day > 29 Then li_day = 29
# 		Else
# 			If li_day > 28 Then li_day = 28
# 		End if
# End Choose

# ls_date = String(li_month, "00") + "-" + String(li_day, "00") + "-" + String(Year(ld_future_date), "0000")
# ld_future_date = Date(ls_date)

# Return ld_future_date

# //***********************************************************************
# //*  Release  	Date     Task         	Author                           *
# //*  Description                                                        *
# //***********************************************************************
# //*  4.008		09/08/00	ANSWER			Jennifer Kelch							*
# //*  New function added to return a future date to the day.  So, if		*
# //*  6/9/2000 and 6 is passed in, this function will return 12/9/2000.	*
# //*  In the case where a date such as 8/31/2000 and 3 is passed in, the	*
# //*  day will set back to 11/30/2000. Enhancement 1077 - Phase III		*
# //***********************************************************************
# end function

# public function string of_same_serv_prog (double adb_client_id);n_ds		lds_client_bu
# str_pass	lstr_pass
# long		ll_rows
# string	ls_return
# string	ls_filter

# lds_client_bu = Create ds_client_bu
# lds_client_bu.SetTransObject(SQLCA)

# lstr_pass.db[1] = adb_client_id

# ll_rows = gnv_data_access_service.Retrieve(lds_client_bu, lds_client_bu, "Clbu_l", lstr_pass)

# If ll_rows > 0 Then
# 	ls_filter = "t_budget_unit_service_program_id = " + String(ii_service_program) + " And t_budget_unit_part_participation_stat in ('01', '02')"
# 	lds_client_bu.SetFilter(ls_filter)
# 	lds_client_bu.Filter()
# 	ll_rows = lds_client_bu.RowCount()

# 	If ll_rows > 0 Then
# 		ls_return = "Y"
# 	Else
# 		ls_return = "N"
# 	End if
# End if

# Destroy lds_client_bu

# Return ls_return

# //***********************************************************************
# //*  Release  	Date     Task         	Author                           *
# //*  Description                                                        *
# //***********************************************************************
# //*  4.008		09/08/00	ANSWER			Jennifer Kelch							*
# //*  New function added to determine if the given client has applied for*
# //*  or is receiving benefits in a different budget unit but of the same*
# //*  service program.  Enhancement 1077 - Phase III							*
# //***********************************************************************
# end function



















 end