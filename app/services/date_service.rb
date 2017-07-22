require 'date'

class DateService
	# Author : Manoj Patil
	#Description: If Date is present then check it is valid or Not.
    # 	          If Date is not present then the function should return true, hence this
    #             function can be called for all for all date fields in the Model - which makes sure valid date is after 1900.
	#1.
	def self.valid_date?(arg_model,arg_date,arg_field_name)

		if arg_date.present?
			if  arg_date < Date.civil(1900, 1, 1)
			  arg_model.errors[:base] << "#{arg_field_name} must be after 01/01/1900."
			  return false
			else
				return true
			end
		else
			return true
		end

	end

	#2.
	#check begin date cannot be greater than end date only if both dates are valid.
	# This method needs to be called after calling each date valid_date?(arg_model,arg_date,arg_field_name)
	def self.begin_date_cannot_be_greater_than_end_date?(arg_model,arg_begin_date,arg_end_date,arg_begin_date_field_name,arg_end_date_field_name)
	   if arg_end_date.present? && arg_end_date >  Date.civil(1900, 1, 1) && arg_begin_date.present? && arg_begin_date >  Date.civil(1900, 1, 1)
	        if  (arg_begin_date > arg_end_date)
	            local_message = "#{arg_begin_date_field_name} cannot be greater than  #{arg_end_date_field_name}."
	            arg_model.errors[:base] << local_message
	            return false
	        else
	            return true
	        end
	   else
	    return true
	  end
	end

	#2.
	#check begin date cannot be greater than end date only if both dates are valid.
	# This method needs to be called after calling each date valid_date?(arg_model,arg_date,arg_field_name)
	def self.begin_date_cannot_be_greater_than_end_date_with_no_message?(arg_model,arg_begin_date,arg_end_date)
	   if arg_end_date.present? && arg_end_date >  Date.civil(1900, 1, 1) && arg_begin_date.present? && arg_begin_date >  Date.civil(1900, 1, 1)
	        if  (arg_begin_date > arg_end_date)
	           return false
	        else
	            return true
	        end
	   else
	    return true
	  end
	end



	#3.
	def self.valid_date_before_today?(arg_model,arg_date,arg_field_name)

		if arg_date.present?
			# Rule - valid date is after 1900/01/01 and less than equal to today
			# invalid condition
			if  arg_date < Date.civil(1900, 1, 1) || arg_date > DateTime.now.to_date
			  arg_model.errors[:base] << "#{arg_field_name} must be after 01/01/1900 and can not be future date."
			  return false
			else
				return true
			end
		else
			return true
		end

	end

	#4.
	def self.validate_start_time_and_end_time(arg_model,arg_start_time,arg_end_time,arg_start_time_field_name,arg_end_time_field_name)
      if arg_end_time.present?
        if arg_start_time > arg_end_time
            arg_model.errors[:base] << "#{arg_end_time_field_name} should be greater than #{arg_start_time_field_name}."
            return false
        else
            return true
          end
      else
      	return true
      end
    end

    #5.
	def self.validate_start_time_and_end_time_and_day(arg_model,arg_day,arg_start_time,arg_end_time,arg_start_time_field_name,arg_end_time_field_name)

      if arg_day.present? && arg_end_time.present?
        if arg_start_time > arg_end_time
            arg_model.errors[:base] << "#{arg_end_time_field_name} should be greater than #{arg_start_time_field_name}."
            return false
        else
            return true
          end
      else
      	return true
      end



    end

	def self.f_future_date(arg_date_to_convert, arg_increase_component_type, arg_increase_component)
		new_date = arg_date_to_convert
		case arg_increase_component_type
		when 'Y'
			new_date = arg_date_to_convert + arg_increase_component.years
		when 'M'
			new_date = arg_date_to_convert + arg_increase_component.months
		else
			new_date = arg_date_to_convert + arg_increase_component.days
		end
		# 		function date f_future_date (date date_to_convert, string increase_component, integer increase_amount);
		# date ld_mmddyyyy
		# integer li_month
		# integer li_year
		# integer li_day
		# integer li_remainder

		# li_month = month(date_to_convert)
		# li_year = year(date_to_convert)
		# li_day = day(date_to_convert)

		# CHOOSE CASE (increase_component)
		# CASE "Y"
		#      li_year = increase_amount + li_year
		#      ld_mmddyyyy = date(li_year,li_month,li_day)
		# CASE "M"
		#      li_year = li_year + truncate(increase_amount/12,0)
		#      li_remainder = MOD(increase_amount,12)
		#      li_month = li_month + li_remainder
		#      if li_month > 12 then
		#         li_month = li_month - 12
		# 		  //J Kelch 11/12/99 Added so that year will increment correctly.
		#    	  li_year ++
		# 	  end if
		# 	  CHOOSE CASE (li_month)
		#      CASE 1,3,5,7,8,10,12
		#           li_day = 31
		#      CASE 2
		# 	       li_remainder = mod(li_year,4)
		# 	       if li_remainder < 1 then
		#              li_day = 29
		#           else
		#              li_day = 28
		#           end if
		#      CASE ELSE
		# 	       li_day = 30
		#      END CHOOSE
		#      ld_mmddyyyy = date(li_year,li_month,li_day)
		# CASE "D"
		#      ld_mmddyyyy = RelativeDate(date_to_convert,increase_amount)
		# END CHOOSE

		# return ld_mmddyyyy
		# //***********************************************************************
		# //*  Release  Date     Task         Author                              *
		# //*  Description                                                        *
		# //***********************************************************************
		# //*  1        06/01/94 WINGS            Gonos                           *
		# //*  Created routine to return a future date based on a begin date      *
		# //*  and an increase increment                                          *
		# //***********************************************************************
		# //*  1        06/01/97 SMART        Gonos                               *
		# //*  Standardized logic to conform to Human Services Standards.         *
		# //***********************************************************************
		# //*  3.008    11/12/99 ANSWER			Jennifer Kelch								*
		# //*  Added line to increment year correctly when increasing month. 		*
		# //***********************************************************************


		# end function
	end


	def self.date_of_next(day, arg_date)
		days_of_week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
		day_index = days_of_week.index(day)
		arg_date_index = days_of_week.index(arg_date.strftime("%A"))
		if day_index > arg_date_index
			next_required_day = arg_date + (day_index - arg_date_index)
		else
			next_required_day = arg_date + (day_index + 7 - arg_date_index)
		end
	  	return next_required_day
	end

	def self.date_of_previous(day, arg_date)
		days_of_week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
		day_index = days_of_week.index(day)
		arg_date_index = days_of_week.index(arg_date.strftime("%A"))
		if day_index > arg_date_index
			prev_required_day = arg_date - ( arg_date_index + 7 - day_index)
		else
			prev_required_day = arg_date - (day_index + arg_date_index)
		end
	  	return prev_required_day
	end

	def get_remaining_number_of_days_in_the_week_for_frquency_type_daily(arg_start_date)
		days_of_week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
		7 - days_of_week.index(arg_start_date.strftime("%A"))
	end

	def get_remaining_number_of_days_in_the_week_for_frquency_type_weekly(arg_start_date, arg_days_selected)
		days_of_week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
		index = days_of_week.index(arg_start_date.strftime("%A"))
		count = 0
		while index < 7
			if arg_days_selected.include?(days_of_week[index])
				count = count + 1
			end
			index = index + 1
		end
		return count
	end

	def self.valid_future_date?(arg_model,arg_date,arg_field_name)

		if arg_date.present?
			# Rule - valid date is future date
			# invalid condition
			if   arg_date < DateTime.now.to_date
			  arg_model.errors[:base] << "#{arg_field_name} must be future date."
			  return false
			else
				return true
			end
		else
			return true
		end

	end

	def self.get_start_date_of_reporting_month(arg_date)
		start_date = ""
		days_of_week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
		min_end_day = arg_date.end_of_month.day - 3
		if (arg_date.day < 4) && (days_of_week.index(arg_date.beginning_of_month.strftime("%A")) > 3)
			if days_of_week.index(arg_date.strftime("%A")) == 0
				start_date = arg_date
			elsif days_of_week.index(arg_date.strftime("%A")) > 3
				arg_date = (arg_date.beginning_of_month - 1).beginning_of_month
			end
		elsif (arg_date.day > min_end_day) && (days_of_week.index(arg_date.end_of_month.strftime("%A")) < 3)
			if days_of_week.index(arg_date.strftime("%A")) == 0
				start_date = arg_date
			elsif days_of_week.index(arg_date.strftime("%A")) == 6
				arg_date = arg_date.beginning_of_month
			else
				start_date = date_of_previous("Sunday", arg_date)
			end
		else
			arg_date = arg_date.beginning_of_month
		end
		if start_date.blank?
			index = days_of_week.index(arg_date.strftime("%A"))
			if index == 0
				start_date = arg_date
			else
				if index < 4
					start_date = date_of_previous("Sunday", arg_date)
				else
					start_date = date_of_next("Sunday", arg_date)
				end
			end
		end
		return start_date
	end

	def self.get_end_date_of_reporting_month(arg_date)
		end_date = ""
		days_of_week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
		index = days_of_week.index(arg_date.strftime("%A"))
		min_end_day = arg_date.end_of_month.day - 3
		# Rails.logger.debug("arg_date = #{arg_date}")
		# Rails.logger.debug("index = #{index}")
		# Rails.logger.debug("min_end_day = #{min_end_day}")
		if (arg_date.day < 4) && (days_of_week.index(arg_date.beginning_of_month.strftime("%A")) > 3)
			if days_of_week.index(arg_date.strftime("%A")) == 6
				end_date = arg_date
			elsif days_of_week.index(arg_date.strftime("%A")) == 0
				arg_date = arg_date.end_of_month
			else
				end_date = date_of_next("Saturday", arg_date)
			end
		elsif (arg_date.day > min_end_day) && (days_of_week.index(arg_date.end_of_month.strftime("%A")) < 3)

			if days_of_week.index(arg_date.strftime("%A")) == 6
				end_date = arg_date
			elsif days_of_week.index(arg_date.strftime("%A")) > 3
				end_date = date_of_next("Saturday", arg_date)
			else
				arg_date = (arg_date.end_of_month + 1).end_of_month
			end
		else
			arg_date = arg_date.end_of_month
		end
		# Rails.logger.debug("-->arg_date = #{arg_date}")
		if end_date.blank?
			index = days_of_week.index(arg_date.strftime("%A"))
			if index == 6
				end_date = arg_date
			else
				if index < 3
					end_date = date_of_previous("Saturday", arg_date)
				else
					end_date = date_of_next("Saturday", arg_date)
				end
			end
		end
		return end_date
	end

	# def self.get_start_date_of_reporting_month(arg_date)
	# 	start_date = ""
	# 	days_of_week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
	# 	index = days_of_week.index(arg_date.strftime("%A"))
	# 	if index == 0
	# 		start_date = arg_date
	# 	else
	# 		if index < 4
	# 			start_date = date_of_previous("Sunday", arg_date)
	# 		else
	# 			start_date = date_of_next("Sunday", arg_date)
	# 		end
	# 	end
	# 	return start_date
	# end

	# def self.get_end_date_of_reporting_month(arg_date)
	# 	end_date = ""
	# 	days_of_week = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
	# 	index = days_of_week.index(arg_date.strftime("%A"))
	# 	if index == 6
	# 		end_date = arg_date
	# 	else
	# 		if index < 3
	# 			end_date = date_of_previous("Saturday", arg_date)
	# 		else
	# 			end_date = date_of_next("Saturday", arg_date)
	# 		end
	# 	end
	# 	return end_date
	# end

	def self.get_number_of_reporting_months(arg_start_date,arg_end_date)
		# Rails.logger.debug("******************************************")
		# Rails.logger.debug("--> arg_start_date = #{arg_start_date}")
		# Rails.logger.debug("--> arg_end_date = #{arg_end_date}")
		start_date = get_start_date_of_reporting_month(arg_start_date)
		end_date = get_end_date_of_reporting_month(arg_end_date)
		# Rails.logger.debug("--> start_date = #{start_date}")
		# Rails.logger.debug("--> end_date = #{end_date}")
		# fail
		reporting_month_count = 0
		while start_date < end_date
			# Rails.logger.debug("------start_date = #{start_date}")
			start_date = get_end_date_of_reporting_month(start_date + 10.days)+1
			reporting_month_count += 1
		end
		# Rails.logger.debug("reporting_month_count = #{reporting_month_count}")
		# fail
		return reporting_month_count
	end

	def self.get_reporting_month_start_date_prior_to_given_months(arg_date, arg_num_of_months)
		arg_date = get_start_date_of_reporting_month(arg_date)
		reporting_month_count = 0
		while reporting_month_count < arg_num_of_months
			arg_date = get_start_date_of_reporting_month(arg_date - 1)
			reporting_month_count += 1
		end
		return arg_date
	end

	def self.selected_date_should_be_between_current_month_and_following_month(arg_date)
		current_month = Date.today.at_beginning_of_month
		next_month =    Date.today.at_end_of_month.next_month
		if (current_month..next_month).cover?(arg_date)
			result = true
		else
			result = "should be between #{current_month.strftime("%m/%d/%Y")} - #{next_month.strftime("%m/%d/%Y")}."
		end
		return result

    end



	def self.program_unit_close_date_validation(arg_status_date,arg_date)
        # Program unit closure should be after program unit activation date or current month (whichever is later) and last of next month
		beginning_of_the_month  = Date.today.at_beginning_of_month
			if arg_status_date.present? and arg_status_date < beginning_of_the_month
				current_month = beginning_of_the_month
				next_month =    Date.today.at_end_of_month.next_month
			else
				current_month = arg_status_date
				next_month =    Date.today.at_end_of_month.next_month
			end

			if (current_month..next_month).cover?(arg_date)
				result = true
			else
				result = "should be between #{current_month.strftime("%m/%d/%Y")} - #{next_month.strftime("%m/%d/%Y")}."
			end

			return result

    end

end