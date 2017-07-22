module CommonUtil

	def self.first_of_given_month(arg_date)
		arg_date.at_beginning_of_month.strftime("%Y-%m-%d")
	end

	def self.first_of_month
		Date.today.at_beginning_of_month.strftime("%Y-%m-%d")
	end

	def self.get_age(arg_dob)
		age = Date.today.year - arg_dob.year
    	age -= 1 if Date.today < arg_dob + age.years
    	return age
	end

	def self.format_db_date(arg_date)
		# mm/dd/yyyy
		if arg_date.present?
			arg_date.strftime("%m/%d/%Y")
		end
	end

	def self.get_comma_seperated_string_for_a_structure(arg_struct)
		result = ""
		count = 1
  	    arg_struct.each do |f|
           if arg_struct.count == 1
           	result = CodetableItem.get_short_description(f.to_i)
           elsif count == arg_struct.count
            result = result + ", and " + CodetableItem.get_short_description(f.to_i)
           elsif count == arg_struct.count - 1
             result = result + CodetableItem.get_short_description(f.to_i)
           else
             result = result + CodetableItem.get_short_description(f.to_i) + ", "
           end
           count = count + 1
        end
        return result
	end

	# Manoj Patil 10/29/2014
	# Common code to insert records into error table
	def self.write_to_attop_error_log_table(arg_object_name,arg_method_name,arg_exception,arg_logged_in_user)
		l_attop_error_object = AttopErrorLog.new
		l_attop_error_object.object_name = arg_object_name
		l_attop_error_object.method_name = arg_method_name
		l_attop_error_object.error_message = arg_exception.message.to_s.length > 255 ? arg_exception.message.strip[0, 255] : arg_exception.message.to_s
		l_attop_error_object.trace_details = Rails.backtrace_cleaner.clean(arg_exception.backtrace).to_s
		l_attop_error_object.created_by = arg_logged_in_user
		l_attop_error_object.save
		return l_attop_error_object
	end

	def self.write_to_attop_error_log_table_without_trace_details(arg_object_name,arg_method_name,arg_error_message,arg_additional_error_details_message,arg_logged_in_user)
		l_attop_error_object = AttopErrorLog.new
		l_attop_error_object.object_name = arg_object_name
		l_attop_error_object.method_name = arg_method_name
		l_attop_error_object.error_message = arg_error_message.length > 255 ? arg_error_message.strip[0, 255] : arg_error_message
		l_attop_error_object.trace_details = arg_additional_error_details_message.to_s.length > 255 ? arg_additional_error_details_message.strip[0, 255] : arg_additional_error_details_message.to_s
		l_attop_error_object.created_by = arg_logged_in_user
		l_attop_error_object.save
		return l_attop_error_object
	end

	def self.valid_string_of_length_255(arg_value)
		ls_return_value = ""
		if arg_value.present?
			ls_return_value = arg_value
			if ls_return_value.length > 255
				ls_return_value = ls_return_value.strip[0, 255]
			end
		end
		return ls_return_value

	end

end