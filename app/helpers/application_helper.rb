module ApplicationHelper
    #Author: Kiran
	#Date: 07/02/2014
	#Description: method used to format the date field across the application, if the input arg is nill we will return empty string.
	STYLE_FOR_WARNING = "style= 'color: red'" #FFDE00
	def format_date(arg_date)
		if arg_date.to_s == ""
        return ""
      	else
		arg_date.to_s.in_time_zone(ActiveSupport::TimeZone.new(" Central Time (US & Canada)")).strftime("%m/%d/%Y %r")
		end
	end

	def format_db_date(arg_date)
		# mm/dd/yyyy
		if arg_date.present?
			arg_date.strftime("%m/%d/%Y")
		end

	end

	# def format_db_date_YYYY_Month_dd(arg_date)
	# 	if arg_date.present?
	# 		arg_date.strftime("%Y/%B/%d")
	# 	end

	# end

	# outputform 2014/08 ( yyyy/mm)
	def format_db_date_YYYY_MM(arg_date)
		if arg_date.present?
			arg_date.strftime("%Y/%m")
		end

	end

	def format_db_date_MM_YYYY(arg_date)
		if arg_date.present?
			arg_date.strftime("%m/%Y")
		end

	end

	def set_subheader(arg_header)
		# output = "<h4 class="
		# output = output + "subheader"
		# output = output + "> #{arg_header} </h4>"
		# output = output.html_safe
		if arg_header.present?
			output = content_tag(:h4,arg_header ,class:"subheader")
			output = output + content_tag(:hr)
		end
	end
# Sheri keerthana
# Date Modified : 10/31/2014
#Description : This helper method should be used along with date_select field.
    # def attop_date_settings
   	#  l_hash = {:order => [:month,:day, :year], :start_year => 1900, :prompt => { :day => 'Day', :month => 'Month', :year => 'Year' }}
   	#  return l_hash
   	# end

   	def provider_name(arg_object)
   		if arg_object.present?
   			"#{arg_object.provider_name}"
   		end
   	end



	def client_full_name(arg_object)
		if arg_object.present?
        	"#{arg_object.last_name}, #{arg_object.first_name} #{arg_object.middle_name} #{arg_object.suffix}"
        end

	end
	 def employer_name(arg_id)
	 	ls_employer = " "
	 	if arg_id.present?
        	ls_employer = Employer.get_employer_name(arg_id)
        	if ls_employer.blank?
        		ls_employer = " "
    	    else
    			ls_employer = ls_employer.first.employer_name
        	end
        end
        return ls_employer
	 end

	def get_user_name(arg_uid)
		if arg_uid.present?
			# user_object = User.find(arg_user_id)
			users_collection = User.where("uid = ?",arg_uid)
			if users_collection.present?
				user_object = users_collection.first
				ls_out = user_object.name
			else
				ls_out = " "
			end

		else
			ls_out = " "
		end

		return ls_out
	end

	# Author: Manoj Patil
	# Description : shows description for dropdown value. Use this function in all the show pages.
	def drop_down_value_description(arg_id)

		if arg_id.present?
			ls_out = CodetableItem.get_short_description(arg_id)
			if ls_out.blank?
				ls_out = " "
			end
		else
			ls_out = " "
		end

		return ls_out
	end
	def drop_down_value_long_description(arg_id)

		if arg_id.present?
			ls_out = CodetableItem.get_long_description(arg_id)
			if ls_out.blank?
				ls_out = " "
			end
		else
			ls_out = " "
		end

		return ls_out
	end

	def drop_down_value_long_description(arg_id)

		if arg_id.present?
			ls_out = CodetableItem.get_long_description(arg_id)
			if ls_out.blank?
				ls_out = " "
			end
		else
			ls_out = " "
		end

		return ls_out
	end

	# Author : Manoj Patil
	# shows description for system param description for id.
	# use it in show page where description needs to be displayed instead of number.
	def system_param_value_description(arg_id)

		if arg_id.present?
			ls_out = SystemParam.description(arg_id)
			if ls_out.blank?
				ls_out = " "
			end
		else
			ls_out = " "
		end

		return ls_out
	end

	# def system_param_description_from_key_value(arg_key, arg_value)

	# 	if arg_id.present?
	# 		ls_out = SystemParam.get_description_from_key_and_value(arg_key, arg_value)
	# 		if ls_out.blank?
	# 			ls_out = " "
	# 		else
	# 			ls_out = ls_out.first
	# 		end
	# 	else
	# 		ls_out = " "
	# 	end

	# 	return ls_out
	# end


	# pluralize_without_count(@employment.count,"Employer","")
	# output = @employment.count = 1 then output Employer
	#          @employment.count > 1 then output Employers
	# <%= pluralize_without_count(item.categories.count, 'Category', ':') %>
	def pluralize_without_count(count, noun, text = nil)
	  if count != 0
	    count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
	  end
	end


	# Author : Manoj Patil
	# shows name of the service program.
	# use it in show page where description needs to be displayed instead of number.
	def get_service_program_name(arg_id)

		if arg_id.present?
			ls_out = ServiceProgram.service_program_name(arg_id)
			if ls_out.blank?
				ls_out = " "
			end
		else
			ls_out = " "
		end

		return ls_out
	end

	def get_service_program_name_form_program_unit_id(arg_program_unit_id)
		service_program_id = ProgramUnit.get_service_program_id(arg_program_unit_id)
		if service_program_id.present?
			return get_service_program_name(service_program_id)
		else
			return " "
		end
	end

	# def get_service_program_long_name(arg_id)

	# 	if arg_id.present?
	# 		ls_out = ServiceProgram.service_program_description(arg_id)
	# 		if ls_out.blank?
	# 			ls_out = " "
	# 		end
	# 	else
	# 		ls_out = " "
	# 	end

	# 	return ls_out
	# end

	# Author : Manoj Patil
	#  Shows Yes - for Y, No for N, Unknown for 'U'
	def get_flag_description(arg_flag)

		if arg_flag.present?
			case arg_flag
			when "Y"
				ls_out = "Yes"
			when "N"
				ls_out = "No"
			when "U"
				ls_out = "Unknown"
			when "1"
				ls_out = "Yes"
			when "0"
				ls_out = "No"
			when "P"
				ls_out = "Pass"
			when "F"
				ls_out = "Fail"

			else
				ls_out = arg_flag
			end
		else

			ls_out = " "
		end

	 	return ls_out
	end




	def format_phone_number(arg_phone)
		# Manoj Patil 08/30/2014
		# input = 5015884057
		# output = (501)588-4057
		if arg_phone.present?
			# first 3 characters 501
			first_three=""
			first_three = arg_phone.first(3) if arg_phone.first(3).present?
			# next 3 characters - 588
			next_three = ""
			next_three =  arg_phone.from(3).to(-5)  if arg_phone.from(3).to(-5).present?
			# next 4 character - 4057
			last_four= ""
			last_four = arg_phone.from(-4) if arg_phone.from(-4).present?
			ls_out = "(#{first_three}) #{next_three}-#{last_four}"

		else
			ls_out = " "
		end

		return ls_out

	end

	def format_SSN(arg_ssn)
		# Manoj Patil 08/30/2014
		if arg_ssn.present?
			# input = SSN = 123456789
			# output = 123-45-6789
			# first 3 characters
			first_three=""
			first_three = arg_ssn.first(3) if arg_ssn.first(3).present?
			# next 2 characters - 45
			next_two = ""
			next_two =  arg_ssn.from(3).to(-5)  if arg_ssn.from(3).to(-5).present?
			# next 4 character - 4057
			last_four= ""
			last_four = arg_ssn.from(-4) if arg_ssn.from(-4).present?
			ls_out = "#{first_three}-#{next_two}-#{last_four}"

		else
			ls_out = " "
		end

		return ls_out

	end

	def format_phone_number_extn(arg_extn)
		if arg_extn.present?
			ls_out = "Extension:#{arg_extn}"
		else
			ls_out = " "
		end
		return ls_out

	end

	def get_client_full_name(arg_client_id)
		if arg_client_id.present?
        	l_count = Client.where(id: arg_client_id).count
        	if l_count > 0
        		l_object = Client.where(id: arg_client_id).first
        		last_name = l_object.last_name.downcase.camelize if l_object.last_name.present?
        		first_name = l_object.first_name.downcase.camelize if l_object.first_name.present?
        		middle_name = l_object.middle_name.downcase.camelize if l_object.middle_name.present?
        		suffix = l_object.suffix.downcase.camelize if l_object.suffix.present?
        		ls_out ="#{last_name}, #{first_name} #{middle_name} #{suffix} "
        	else
        		ls_out = " "
        	end
        else
        	ls_out = " "
        end

        return ls_out

	end

	# def get_client_first_name(arg_client_id)
	# 	if arg_client_id.present?
 #        	l_count = Client.where(id: arg_client_id).count
 #        	if l_count > 0
 #        		l_object = Client.where(id: arg_client_id).first
 #        		ls_out ="#{l_object.first_name} "
 #        	else
 #        		ls_out = " "
 #        	end
 #        else
 #        	ls_out = " "
 #        end

 #        return ls_out

	# end

	def get_primary_applicant_name(arg_application_id)
		# ls_out = " "
		# if arg_application_id.present?
		# 	l_primary_applicant_collection = ApplicationMember.get_primary_applicant(arg_application_id)
		# 	if l_primary_applicant_collection.present?
		# 		l_object = l_primary_applicant_collection.first
		# 		ls_out = get_client_full_name(l_object.client_id)
		# 	else
		# 		ls_out = " "
		# 	end
		# else
		# 	ls_out = " "
		# end

		# return ls_out
		get_primary_contact(arg_application_id, 6587)
	end

	def get_primary_beneficiary_of_program_unit(arg_program_unit_id)
		# ls_out = " "
		# if arg_program_unit_id.present?
		# 	l_primary_beneficiary_collection = ProgramUnitMember.get_primary_beneficiary(arg_program_unit_id)
		# 	if l_primary_beneficiary_collection.present?
		# 		l_object = l_primary_beneficiary_collection.first
		# 		ls_out = get_client_full_name(l_object.client_id)
		# 	else
		# 		ls_out = " "
		# 	end
		# else
		# 	ls_out = " "
		# end

		# return ls_out
		get_primary_contact(arg_program_unit_id, 6345)
	end

	def get_primary_contact(arg_reference_id, arg_reference_type)
		result = nil
		primary_contact = PrimaryContact.get_primary_contact(arg_reference_id, arg_reference_type)
		if primary_contact.present?
			result = get_client_full_name(primary_contact.client_id)
		else
			result = " "
		end

		return result
	end

	def get_household_name_from_application_id(arg_application_id)
		Household.get_household_name_from_application_id(arg_application_id)
	end

	def get_application_validation_result(arg_result)
		# Manoj - 09/18/2014
		# Used to show Valid or Missing in Application Data validation results page.
		ls_return = ""
		if arg_result
			ls_return = "Available"
		else
			 ls_return = "is unavailable"
		end
		return ls_return
	end

	def get_application_date_helper(arg_application_id)
		ldt_out = ClientApplication.get_application_date(arg_application_id)
		return ldt_out
	end


	def get_benefit_member_name(arg_run_id,arg_month_sequence,member_sequence)
		l_client_id = ProgramBenefitMember.get_client_id(arg_run_id,arg_month_sequence,member_sequence)
		return get_client_full_name(l_client_id)
	end

    def client_full_name_demographics_edit(arg_object)
		if arg_object.present?
			name = Client.find(arg_object)
			"#{name.last_name}, #{name.first_name}"
        end
    end

    def format_EIN(arg_ein)
		# Kiran Chamarthi 10/20/2014
		if arg_ein.present?
			arg_ein = arg_ein.to_s
			first_two=""
			first_two = arg_ein.first(2) if arg_ein.first(2).present?
			last_eight= ""
			last_eight = arg_ein.from(-7) if arg_ein.from(-7).present?
			ls_out = "#{first_two}-#{last_eight}"
		else
			ls_out = " "
		end
		return ls_out
	end
	def number_to_currency_br(number)
             number_to_currency(number, :unit => "$")
	end


	def number_to_percentage_br(number)
             number_to_percentage(number, :precision => 2)
	end

	def number_to_decimal(number)
		     number_with_precision(number, :precision => 2)

	end

	def get_violated_characteristics_messsage(arg_client_id)
		msg = ""
		violated_charateristics = ClientCharacteristic.get_violated_other_characteristics(arg_client_id)
		count = 0
		if violated_charateristics.present?
			violated_charateristics.each do |oc|
				msg = msg + CodetableItem.get_short_description(oc.characteristic_id)
				if count ==  violated_charateristics.size - 2
					msg = msg + " and "
				else
					msg = msg + ", "
				end
				count = count + 1
			end
			msg = msg.strip[0, msg.length-2]
		end
		msg = CodetableItem.get_short_description(6085) + (msg.present? ? ": "+ msg : "")
		msg = (count > 0 ? msg + " violations found" : msg)
		return msg
	end

	def get_ed_violated_characteristics_messsage(arg_client_id, arg_date)
		msg = ""
		count = 0
		violated_charateristics = ClientCharacteristic.get_violated_other_characteristics_ed(arg_client_id, arg_date)
		if violated_charateristics.present?
			violated_charateristics.each do |oc|
				msg = msg + CodetableItem.get_short_description(oc.characteristic_id)
				if count ==  violated_charateristics.size - 2
					msg = msg + " and "
				else
					msg = msg + ", "
				end
				count = count + 1
			end
			msg = msg.strip[0, msg.length-2]
		end
		msg = CodetableItem.get_short_description(6085) + (msg.present? ? ": "+ msg : "")
		msg = (count > 0 ? msg + " violations found" : msg)
		return msg
	end

	# def get_release_name()

	# 	ls_out = SystemParam.get_key_value(11,"RELEASE_NAME","Release name")
	# 	if ls_out.present?
	# 		return ls_out
	# 	else
	# 		return ""
	# 	end
	# end

	# Author: Manoj Patil
	# Description : shows description for dropdown value. Use this function in all the show pages.
	def get_provider_name(arg_provider_id)
		if arg_provider_id.present?
			provider_collection = Provider.where("id = ?",arg_provider_id)
			if provider_collection.present?
				provider_object = provider_collection.first
				ls_out = provider_object.provider_name
			else
				ls_out = " "
			end
		else
			ls_out = " "
		end

		return ls_out
	end

	def get_service_name(arg_provider_service_id)
		if arg_provider_service_id.present?
			provider_service = ProviderService.where("id = ? and provider_id = ?",arg_provider_service_id,session[:PROVIDER_ID])
			if provider_service.present?
				ls_out = provider_service.first
				ls_out = ls_out.service_type
				ls_out = drop_down_value_long_description(ls_out)
			else
				ls_out = " "
			end
		else
			ls_out = " "
		end
		return ls_out
	end


	def day_name_for_the_date(arg_date)
		if arg_date.present?
		 	ls_day = arg_date.strftime("%A")
		 else
		 	ls_day = " "
		 end
		 return ls_day
	end

	def get_state(arg_state_id)
		CodetableItem.get_long_description(arg_state_id)
	end

	# Manoj Patil 01/22/2014 Assessment Question helper method - start

	def display_assessment_question_control(arg_question_id,arg_assessment_id)
		assessment_question_object = AssessmentQuestion.find(arg_question_id)
		assessment_question_metedata_object = AssessmentQuestionMetadatum.get_question_metedata_object(arg_question_id)
		assessment_question_multi_response_collection = AssessmentQuestionMultiResponse.get_responses_for_question_id(arg_question_id)
		html_control = assessment_question_metedata_object.response_data_type


			if assessment_question_multi_response_collection.present?
				ls_muti_response = return_assessment_multi_response_control(arg_assessment_id,assessment_question_object,assessment_question_metedata_object,assessment_question_multi_response_collection)
				ls_content_tag = ls_muti_response
				# logger.debug("ls_content_tag after multi = #{ls_content_tag}")
			else
				if html_control == "LABEL"
					if assessment_question_metedata_object.prompt_style_class == "fi-alert"
						ls_content_tag = "<label id= #{get_comp_id(assessment_question_metedata_object)}><b class = '#{assessment_question_metedata_object.prompt_style_class}' #{STYLE_FOR_WARNING}></b>  <b>#{assessment_question_object.title}</b></label>"
					else
						ls_content_tag = "<label id= #{get_comp_id(assessment_question_metedata_object)}><b> #{assessment_question_object.title}</b></label></br>"
					end
				elsif html_control == "TEXT"
					answer_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,arg_question_id)
					if answer_collection.present?
						answer_populated = true
						ans_val = answer_collection.first.answer_value
					else
						answer_populated = false
						ans_val = ""
					end
					if assessment_question_metedata_object.response_max_lngth.present?
						max_length = assessment_question_metedata_object.response_max_lngth
					else
						max_length = 250 # because Answer value is string of 255.
					end

					if assessment_question_metedata_object.response_max_val.present?
						max_size = assessment_question_metedata_object.response_max_val
					else
						max_size = 250 # because Answer value is string of 255.
					end


					step1 = " <label id= #{get_comp_id(assessment_question_metedata_object)}>#{assessment_question_object.title}</label>"
						step2 = "#{step1} <div class = 'row' ><div class='large-5 columns'><input id= #{assessment_question_object.id} name= #{assessment_question_object.id} type='text'  maxlength = #{max_length} size=#{max_size} value= '#{ans_val}' /></div></div>"
					ls_content_tag = step2

				elsif html_control == "DATE"
					answer_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,arg_question_id)
					if answer_collection.present?
						answer_populated = true
						ans_val = answer_collection.first.answer_value
					else
						answer_populated = false
						ans_val = ""
					end
					if assessment_question_metedata_object.response_max_lngth.present?
						max_length = assessment_question_metedata_object.response_max_lngth
					else
						max_length = 250 # because Answer value is string of 255.
					end

					if assessment_question_metedata_object.response_max_val.present?
						max_size = assessment_question_metedata_object.response_max_val
					else
						max_size = 250 # because Answer value is string of 255.
					end

					if assessment_question_metedata_object.prompt_style_class == "fi-alert"
						step1 = " <label id= #{get_comp_id(assessment_question_metedata_object)}><b class = '#{assessment_question_metedata_object.prompt_style_class}' style='color: red'></b> #{assessment_question_object.title}</label>"
					else
						step1 = " <label id= #{get_comp_id(assessment_question_metedata_object)}>#{assessment_question_object.title}</label>"
					end
					step2 = "#{step1} <div class = 'row' ><div class='large-5 columns'><input id= #{assessment_question_object.id} name= #{assessment_question_object.id} type='date'  maxlength = #{max_length} size=#{max_size} value= '#{ans_val}' /></div></div>"

					ls_content_tag = step2

				elsif html_control == "TEXTAREA"
					answer_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,arg_question_id)
					if answer_collection.present?
						answer_populated = true
						ans_val = answer_collection.first.answer_value
					else
						answer_populated = false
						ans_val = ""
					end
					if assessment_question_metedata_object.response_max_lngth.present?
						max_length = assessment_question_metedata_object.response_max_lngth
					else
						max_length = 250 # because Answer value is string of 255.
					end

					if assessment_question_metedata_object.prompt_style_class == "fi-alert"
						step1 = " <label id= #{get_comp_id(assessment_question_metedata_object)}><b class = '#{assessment_question_metedata_object.prompt_style_class}' style='color: red'></b> #{assessment_question_object.title}</label>"
					else
						step1 = " <label id= #{get_comp_id(assessment_question_metedata_object)}>#{assessment_question_object.title}</label>"
					end
					step2 = "#{step1} <div class = 'row' ><div class='large-5 columns'><textarea id= #{assessment_question_object.id} name= #{assessment_question_object.id} maxlength = #{max_length} />#{ans_val}</textarea></div></div>"
					ls_content_tag = step2

				elsif html_control == "CHECKBOX"
					answer_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,arg_question_id)
					if answer_collection.present?
						answer_populated = true
						ans_val = answer_collection.first.answer_value
					else
						answer_populated = false
						ans_val = ""
					end
					if answer_populated == true
						step1 = "  <table id = table_#{assessment_question_object.id}><tr><td width='10%'><input id= #{assessment_question_object.id} name= #{assessment_question_object.id} type='checkbox' checked='checked'/></td>"
					else
						step1 = " <table id = table_#{assessment_question_object.id}><tr><td width='10%'><input id= #{assessment_question_object.id} name= #{assessment_question_object.id} type='checkbox'/></td>"
					end
					step2 = "#{step1} <td> #{assessment_question_object.title}</td></tr></table>"
					ls_content_tag = step2
				end

				# logger.debug("ls_content_tag -no multi = #{ls_content_tag}")
			end
		# logger.debug("final -ls_content_tag in display_assessment_question_control = #{ls_content_tag}")
		return ls_content_tag
	end

	def return_assessment_multi_response_control(arg_assessment_id,arg_qstn_object,arg_qstn_metadata_object,arg_qstn_multi_response_collection)
		answer_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,arg_qstn_object.id)
		if answer_collection.present?
			answer_populated = true
			ans_val = answer_collection.first.answer_value
		else
			answer_populated = false
		end

		if arg_qstn_metadata_object.response_data_type == "RADIO"
			if arg_qstn_object.question_text.present?
				text_value = arg_qstn_object.question_text
			else
				text_value = arg_qstn_object.title
			end

			step1 = "<fieldset class='radio'>"
			step1 = step1 + "<div id = div_#{arg_qstn_object.id}>"
			if arg_qstn_metadata_object.prompt_style_class == "fi-alert"
				step2 = "#{step1} <legend class='radiolegend'><b class = '#{arg_qstn_metadata_object.prompt_style_class}' #{STYLE_FOR_WARNING}></b> #{text_value}</legend>"
			else
				step2 = "#{step1} <legend class='radiolegend'>#{text_value}</legend>"
			end
			step2 = step2 + "</div>"
			step3 = "#{step2} <div class='button-group'>"
			step4 = step3
			# Manoj 02/18/2016 start
				# Rule : answer to Question 2 & 3 are always disabled , they are managed from Employment data entry
				# question 2: "Are you currently working?"
				# question 3:"(If not currently working) <br> Do you have job offer to start working within a month or next month?"

			arg_qstn_multi_response_collection.each do |arg_rsp|
				if answer_populated == true

					if arg_qstn_object.id == 2 || arg_qstn_object.id == 3
						if ans_val == arg_rsp.val
							step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button'><input checked='checked' id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' disabled='true' />#{arg_rsp.txt}</label>"
						else
							step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' disabled='true' />#{arg_rsp.txt}</label>"
						end
					else
						if ans_val == arg_rsp.val
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button'><input checked='checked' id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' />#{arg_rsp.txt}</label>"
						else
							step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' />#{arg_rsp.txt}</label>"
						end
					end



				else
					if arg_qstn_object.id == 2 || arg_qstn_object.id == 3
						if ans_val == arg_rsp.val
							step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button'><input checked='checked' id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' disabled='true' />#{arg_rsp.txt}</label>"
						else
							step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' disabled='true' />#{arg_rsp.txt}</label>"
						end
					else
						if "radio_#{arg_rsp.id}" == "radio_117" && "#{arg_rsp.val}" == "Y" && session[:CLIENT_ID].present? && EmploymentDetail.is_there_an_open_employment_for_the_client(session[:CLIENT_ID])
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button'><input checked='checked' id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' />#{arg_rsp.txt}</label>"
						elsif  "radio_#{arg_rsp.id}" == "radio_1068" && "#{arg_rsp.val}" == "Y" && session[:CLIENT_ID].present? && EmploymentDetail.is_there_an_open_full_time_employment_for_the_client(session[:CLIENT_ID])
							step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button'><input checked='checked' id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' />#{arg_rsp.txt}</label>"
						elsif  "radio_#{arg_rsp.id}" == "radio_1074" && "#{arg_rsp.val}" == "Y" && session[:CLIENT_ID].present? && EmploymentDetail.is_there_an_open_part_time_employment_for_the_client(session[:CLIENT_ID])
							step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button'><input checked='checked' id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' />#{arg_rsp.txt}</label>"
						elsif  "radio_#{arg_rsp.id}" == "radio_1070" && "#{arg_rsp.val}" == "Y" && session[:CLIENT_ID].present? && EmploymentDetail.is_there_an_open_for_the_client_with_full_insurance(session[:CLIENT_ID])
							step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button'><input checked='checked' id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' />#{arg_rsp.txt}</label>"
						else
							step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' />#{arg_rsp.txt}</label>"
						end
					end

				end



			end

			step5 =  "#{ step4} </div></fieldset>"
			ret_html = step5
		elsif arg_qstn_metadata_object.response_data_type == "RADIOGROUP"
			step1 ="<fieldset >"
			if arg_qstn_metadata_object.prompt_style_class == "fi-alert"
				step2 = "#{step1} <label id= #{get_comp_id(arg_qstn_metadata_object)}><b class = '#{arg_qstn_metadata_object.prompt_style_class}' style='color: red'></b> #{arg_qstn_object.title}</label>"
			else
				step2 = "#{step1} <label id= #{get_comp_id(arg_qstn_metadata_object)}>#{arg_qstn_object.title}</label>"
			end
        	step3 = "#{step2} <div ><table id = table_#{get_comp_id(arg_qstn_metadata_object)}>"
        	step4 = step3
        	arg_qstn_multi_response_collection.each do |arg_rsp|
        		# check if this checkbox value is present in answers table - then checkbox should be checked.
        		if answer_populated == true
        			# is this checkbox checked?
        			# ls_checked = ClientAssessmentAnswer.get_answer_collection_for_question_value(arg_assessment_id,arg_qstn_object.id,arg_rsp.val)
					if ans_val == arg_rsp.val
					# if ls_checked == true
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}><tr><td width='10%'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='radio' value='#{arg_rsp.val}' checked='checked' /></td><td>#{arg_rsp.txt}</td></tr></label>"
					else
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}><tr><td width='10%'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='radio' value='#{arg_rsp.val}' /></td><td>#{arg_rsp.txt}</td></tr></label>"
					end
        		else
        			step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}><tr><td width='10%'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='radio' value='#{arg_rsp.val}' /></td><td>#{arg_rsp.txt}</td></tr></label>"
        		end
        	end
        	step5 =  "#{ step4} </table></div></fieldset></br>"
			ret_html = step5
		elsif arg_qstn_metadata_object.response_data_type == "CHECKBOXGROUP"
			step1 ="<fieldset>"
			step1 = step1 + "<div  id= caption_#{arg_qstn_object.id}>"
			if arg_qstn_metadata_object.prompt_style_class == "fi-alert"
				step2 = "#{step1} <caption class='fontc'><b class = '#{arg_qstn_metadata_object.prompt_style_class}' style='color: red'></b> #{arg_qstn_object.title}</caption>"
			else
				step2 = "#{step1} <caption class='fontc'>#{arg_qstn_object.title}</caption>"
			end
			step2 = step2 + "</div>"
        	step3 = "#{step2} <div><table id = table_#{get_comp_id(arg_qstn_metadata_object)}>"
        	step4 = step3
        	arg_qstn_multi_response_collection.each do |arg_rsp|
        		# check if this checkbox value is present in answers table - then checkbox should be checked.
        		if answer_populated == true
        			# is this checkbox checked?
        			ls_checked = ClientAssessmentAnswer.get_answer_collection_for_question_value(arg_assessment_id,arg_qstn_object.id,arg_rsp.val)
					if ls_checked == true
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}><tr><td width='10%'><input id='checkbox_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='checkbox' value='#{arg_rsp.val}' checked='checked' /></td><td>#{arg_rsp.txt}</td></tr></label>"
					else
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}><tr><td width='10%'><input id='checkbox_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='checkbox' value='#{arg_rsp.val}' /></td><td>#{arg_rsp.txt}</td></tr></label>"
					end
        		else
        			step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}><tr><td width='10%'><input id='checkbox_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='checkbox' value='#{arg_rsp.val}' /></td><td>#{arg_rsp.txt}</td></tr></label>"
        		end
        	end
        	step5 =  "#{ step4} </table></div></fieldset>"
			ret_html = step5

		elsif arg_qstn_metadata_object.response_data_type == "DROPDOWN"
			if arg_qstn_metadata_object.prompt_style_class == "fi-alert"
				step1 ="<label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_qstn_object)} for = #{arg_qstn_object.id}><b class = '#{arg_qstn_metadata_object.prompt_style_class}' style='color: red'></b> #{arg_qstn_object.title}</label>"
			else
				step1 ="<label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_qstn_object)} for = #{arg_qstn_object.id}>#{arg_qstn_object.title}</label>"
			end
        	step2 = "#{step1} <div class = 'row' ><div class='large-5 columns'><select  id = dropdown_#{arg_qstn_object.id} name = #{arg_qstn_object.id} >"
        	step3 = step2
        	arg_qstn_multi_response_collection.each do |arg_rsp|
        		# check if this checkbox value is present in answers table - then checkbox should be checked.
        		if answer_populated == true
        			# is this checkbox checked?
        			# ls_checked = ClientAssessmentAnswer.get_answer_collection_for_question_value(arg_assessment_id,arg_qstn_object.id,arg_rsp.val)
					if ans_val == arg_rsp.val
						step3 =  "#{step3} <option selected = 'selected' value= #{arg_rsp.val}>#{arg_rsp.txt}</option>"
					else
						step3 =  "#{step3} <option value= #{arg_rsp.val}>#{arg_rsp.txt}</option>"
					end
        		else
        			step3 =  "#{step3} <option value= #{arg_rsp.val}>#{arg_rsp.txt}</option>"
        		end
        	end
        	step4 =  "#{ step3} </select></div></div>"
			ret_html = step4

		end

		return ret_html
	end

	def show_assessment_question_control(arg_question_id,arg_assessment_id)
		assessment_question_object = AssessmentQuestion.find(arg_question_id)
		assessment_question_metedata_object = AssessmentQuestionMetadatum.get_question_metedata_object(arg_question_id)
		html_control = assessment_question_metedata_object.response_data_type
		if html_control == "LABEL"
			ls_content_tag =  "<p> <b> #{assessment_question_object.title}</b> </p>"
		else
			step1 = "<p> <b> #{assessment_question_object.title}: </b>"
			answer_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,arg_question_id)
			if answer_collection.present?
				if answer_collection.size > 1
					ls_ans_values = ""
					answer_collection.each do |each_ans|
							if ls_ans_values.present?
								ls_ans_values = "#{ls_ans_values}, #{each_ans.answer_value}"
							else
								ls_ans_values = "#{each_ans.answer_value}"
							end
					end
					step2 = "#{step1} #{ls_ans_values} </p>"
				else
					ans_val = answer_collection.first.answer_value
					step2 = "#{step1} #{get_flag_value_description_assessment(ans_val)} </p>"
				end


			else
				step2 = "#{step1} </p>"
			end



			ls_content_tag = step2
		end
		return ls_content_tag


	end

	def get_flag_value_description_assessment(arg_flag)

		if arg_flag.present?
			case arg_flag
			when "Y"
				ls_out = "Yes"
			when "N"
				ls_out = "No"
			when "on"
				ls_out = "Yes"
			else
				ls_out = arg_flag
			end
		else
			ls_out = " "
		end
	 	return ls_out
	end

	def get_barrier_description(arg_barrier_id)
		barrier_object = Barrier.find(arg_barrier_id)
		return barrier_object.description
	end

	def get_benefit_member_status(arg_program_wizard_id,arg_client_id)
		benefit_member_status = nil
		each_benefit_member_collection = ProgramBenefitMember.get_benefit_member_status(arg_program_wizard_id,arg_client_id)
		if each_benefit_member_collection.present?
			if each_benefit_member_collection.first.member_status.present?
				benefit_member_status = each_benefit_member_collection.first.member_status
			end

		end
		return benefit_member_status

	end


	# Manoj 02/21/2015
	def get_action_detail_hours_per_week(arg_hours_per_day,arg_day_of_week)
		l_days_in_week_schedule_count = arg_day_of_week.size
		l_hours_per_week = l_days_in_week_schedule_count * arg_hours_per_day
		return l_hours_per_week

	end

	def check_primary_member_flag(arg_program_wizard_id,arg_client_id)
		ls_return = ""
		program_wizard_object = ProgramWizard.find(arg_program_wizard_id)
		# program_unit_member_collection = ProgramUnitMember.where("program_unit_id = ? and client_id = ?",program_wizard_object.program_unit_id,arg_client_id)
		# if program_unit_member_collection.present?
		# 	program_unit_member_object = program_unit_member_collection.first
		# 	if program_unit_member_object.primary_beneficiary == "Y"
		# 		ls_return = "Y"
		# 	else
		# 		ls_return = "N"
		# 	end
		# end
		is_the_client_primary_contact(program_wizard_object.program_unit_id, 6345, arg_client_id)
	end

	def is_the_client_primary_contact(arg_reference_id, arg_reference_type, arg_client_id)
		primary_contact = PrimaryContact.get_primary_contact(arg_reference_id, arg_reference_type)
		if primary_contact.present? && primary_contact.client_id == arg_client_id
			ls_return = "Y"
		else
			ls_return = "N"
		end
		return ls_return
	end

	def get_school_name(arg_id)
		if arg_id.present?
			school_name = School.get_school_name(arg_id)
			if school_name.blank?
				school_name = " "
			end
		else
			school_name = " "
		end

		return school_name
	end

	def validate_authorization(arg_element_id)
		AccessRight.user_authorized_to_access(arg_element_id)
	end

	def get_comp_id(arg_obj)
		return "#{arg_obj.assessment_question_id.to_s}_#{arg_obj.id.to_s}"
	end

	def get_ind_comp_id(arg_obj1, arg_obj2)
		return "#{get_comp_id(arg_obj1)}_#{arg_obj2.id.to_s}"
	end

	def get_client_gender(arg_client_id)
		return Client.find(arg_client_id).gender
	end


	def get_client_full_name_with_id(arg_client_id)
		if arg_client_id.present?
        	l_count = Client.where(id: arg_client_id).count
        	if l_count > 0
        		l_object = Client.where(id: arg_client_id).first
        		ls_out ="#{l_object.last_name}, #{l_object.first_name} #{l_object.middle_name} #{l_object.suffix}"
        	else
        		ls_out = " "
        	end
        else
        	ls_out = " "
        end

        return ls_out

	end


	# Prescreening  Assessment. start

	def display_assessment_question_control_for_pre_screening(arg_question_id,arg_prescreen_household_id)
		assessment_question_object = AssessmentQuestion.find(arg_question_id)
		assessment_question_metedata_object = AssessmentQuestionMetadatum.get_question_metedata_object(arg_question_id)
		assessment_question_multi_response_collection = AssessmentQuestionMultiResponse.get_responses_for_question_id(arg_question_id)
		html_control = assessment_question_metedata_object.response_data_type


			if assessment_question_multi_response_collection.present?
				ls_muti_response = return_assessment_multi_response_control_for_pre_screening(arg_prescreen_household_id,assessment_question_object,assessment_question_metedata_object,assessment_question_multi_response_collection)
				ls_content_tag = ls_muti_response
				# logger.debug("ls_content_tag after multi = #{ls_content_tag}")
			else
				if html_control == "LABEL"
					if assessment_question_metedata_object.prompt_style_class == "fi-alert"
						ls_content_tag = "<label id= #{get_comp_id(assessment_question_metedata_object)}><b class = '#{assessment_question_metedata_object.prompt_style_class}' #{STYLE_FOR_WARNING}></b>  <b>#{assessment_question_object.title}</b></label>"
					else
						ls_content_tag = "<label id= #{get_comp_id(assessment_question_metedata_object)}><b> #{assessment_question_object.title}</b></label></br>"
					end
				elsif html_control == "TEXT"
					answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,arg_question_id)
					if answer_collection.present?
						answer_populated = true
						ans_val = answer_collection.first.answer_value
					else
						answer_populated = false
						ans_val = ""
					end
					if assessment_question_metedata_object.response_max_lngth.present?
						max_length = assessment_question_metedata_object.response_max_lngth
					else
						max_length = 250 # because Answer value is string of 255.
					end

					if assessment_question_metedata_object.response_max_val.present?
						max_size = assessment_question_metedata_object.response_max_val
					else
						max_size = 250 # because Answer value is string of 255.
					end


					step1 = " <label id= #{get_comp_id(assessment_question_metedata_object)}>#{assessment_question_object.title}</label>"
						step2 = "#{step1} <div class = 'row' ><div class='large-5 columns'><input id= #{assessment_question_object.id} name= #{assessment_question_object.id} type='text'  maxlength = #{max_length} size=#{max_size} value= '#{ans_val}' /></div></div>"
					ls_content_tag = step2

				elsif html_control == "DATE"
					answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,arg_question_id)
					if answer_collection.present?
						answer_populated = true
						ans_val = answer_collection.first.answer_value
					else
						answer_populated = false
						ans_val = ""
					end
					if assessment_question_metedata_object.response_max_lngth.present?
						max_length = assessment_question_metedata_object.response_max_lngth
					else
						max_length = 250 # because Answer value is string of 255.
					end

					if assessment_question_metedata_object.response_max_val.present?
						max_size = assessment_question_metedata_object.response_max_val
					else
						max_size = 250 # because Answer value is string of 255.
					end

					if assessment_question_metedata_object.prompt_style_class == "fi-alert"
						step1 = " <label id= #{get_comp_id(assessment_question_metedata_object)}><b class = '#{assessment_question_metedata_object.prompt_style_class}' style='color: red'></b> #{assessment_question_object.title}</label>"
					else
						step1 = " <label id= #{get_comp_id(assessment_question_metedata_object)}>#{assessment_question_object.title}</label>"
					end
					step2 = "#{step1} <div class = 'row' ><div class='large-5 columns'><input id= #{assessment_question_object.id} name= #{assessment_question_object.id} type='date'  maxlength = #{max_length} size=#{max_size} value= '#{ans_val}' /></div></div>"

					ls_content_tag = step2

				elsif html_control == "TEXTAREA"
					answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,arg_question_id)
					if answer_collection.present?
						answer_populated = true
						ans_val = answer_collection.first.answer_value
					else
						answer_populated = false
						ans_val = ""
					end
					if assessment_question_metedata_object.response_max_lngth.present?
						max_length = assessment_question_metedata_object.response_max_lngth
					else
						max_length = 250 # because Answer value is string of 255.
					end

					if assessment_question_metedata_object.prompt_style_class == "fi-alert"
						step1 = " <label id= #{get_comp_id(assessment_question_metedata_object)}><b class = '#{assessment_question_metedata_object.prompt_style_class}' style='color: red'></b> #{assessment_question_object.title}</label>"
					else
						step1 = " <label id= #{get_comp_id(assessment_question_metedata_object)}>#{assessment_question_object.title}</label>"
					end
					step2 = "#{step1} <div class = 'row' ><div class='large-5 columns'><textarea id= #{assessment_question_object.id} name= #{assessment_question_object.id} maxlength = #{max_length} />#{ans_val}</textarea></div></div>"
					ls_content_tag = step2

				elsif html_control == "CHECKBOX"
					answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,arg_question_id)
					if answer_collection.present?
						answer_populated = true
						ans_val = answer_collection.first.answer_value
					else
						answer_populated = false
						ans_val = ""
					end
					if answer_populated == true
						step1 = "  <table id = table_#{assessment_question_object.id}><tr><td width='10%'><input id= #{assessment_question_object.id} name= #{assessment_question_object.id} type='checkbox' checked='checked'/></td>"
					else
						step1 = " <table id = table_#{assessment_question_object.id}><tr><td width='10%'><input id= #{assessment_question_object.id} name= #{assessment_question_object.id} type='checkbox'/></td>"
					end
					step2 = "#{step1} <td> #{assessment_question_object.title}</td></tr></table>"
					ls_content_tag = step2
				end

				# logger.debug("ls_content_tag -no multi = #{ls_content_tag}")
			end
		# logger.debug("final -ls_content_tag in display_assessment_question_control = #{ls_content_tag}")
		return ls_content_tag
	end


	def return_assessment_multi_response_control_for_pre_screening(arg_prescreen_household_id,arg_qstn_object,arg_qstn_metadata_object,arg_qstn_multi_response_collection)
		answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,arg_qstn_object.id)
		if answer_collection.present?
			answer_populated = true
			ans_val = answer_collection.first.answer_value
		else
			answer_populated = false
		end

		if arg_qstn_metadata_object.response_data_type == "RADIO"
			if arg_qstn_object.question_text.present?
				text_value = arg_qstn_object.question_text
			else
				text_value = arg_qstn_object.title
			end

			step1 = "<fieldset class='radio'>"
			step1 = step1 + "<div id = div_#{arg_qstn_object.id}>"
			if arg_qstn_metadata_object.prompt_style_class == "fi-alert"
				step2 = "#{step1} <legend class='radiolegend'><b class = '#{arg_qstn_metadata_object.prompt_style_class}' #{STYLE_FOR_WARNING}></b> #{text_value}</legend>"
			else
				step2 = "#{step1} <legend class='radiolegend'>#{text_value}</legend>"
			end
			step2 = step2 + "</div>"
			step3 = "#{step2} <div class='button-group'>"
			step4 = step3
			arg_qstn_multi_response_collection.each do |arg_rsp|
				if answer_populated == true
					if ans_val == arg_rsp.val
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button' for='#{arg_rsp.id}'><input checked='checked' id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' />#{arg_rsp.txt}</label>"
					else
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button' for='#{arg_rsp.id}'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' />#{arg_rsp.txt}</label>"
					end
				else
					step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)} class='radio-button' for='#{arg_rsp.id}'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}' type='radio' value='#{arg_rsp.val}' />#{arg_rsp.txt}</label>"
				end
			end
			step5 =  "#{ step4} </div></fieldset>"
			ret_html = step5
		elsif arg_qstn_metadata_object.response_data_type == "RADIOGROUP"
			step1 ="<fieldset >"
			if arg_qstn_metadata_object.prompt_style_class == "fi-alert"
				step2 = "#{step1} <label id= #{get_comp_id(arg_qstn_metadata_object)}><b class = '#{arg_qstn_metadata_object.prompt_style_class}' style='color: red'></b> #{arg_qstn_object.title}</label>"
			else
				step2 = "#{step1} <label id= #{get_comp_id(arg_qstn_metadata_object)}>#{arg_qstn_object.title}</label>"
			end
        	step3 = "#{step2} <div ><table id = table_#{get_comp_id(arg_qstn_metadata_object)}>"
        	step4 = step3
        	arg_qstn_multi_response_collection.each do |arg_rsp|
        		# check if this checkbox value is present in answers table - then checkbox should be checked.
        		if answer_populated == true
        			# is this checkbox checked?
        			# ls_checked = ClientAssessmentAnswer.get_answer_collection_for_question_value(arg_prescreen_household_id,arg_qstn_object.id,arg_rsp.val)
					if ans_val == arg_rsp.val
					# if ls_checked == true
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}  for='#{arg_rsp.id}'><tr><td width='10%'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='radio' value='#{arg_rsp.val}' checked='checked' /></td><td>#{arg_rsp.txt}</td></tr></label>"
					else
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}  for='#{arg_rsp.id}'><tr><td width='10%'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='radio' value='#{arg_rsp.val}' /></td><td>#{arg_rsp.txt}</td></tr></label>"
					end
        		else
        			step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}  for='#{arg_rsp.id}'><tr><td width='10%'><input id='radio_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='radio' value='#{arg_rsp.val}' /></td><td>#{arg_rsp.txt}</td></tr></label>"
        		end
        	end
        	step5 =  "#{ step4} </table></div></fieldset></br>"
			ret_html = step5
		elsif arg_qstn_metadata_object.response_data_type == "CHECKBOXGROUP"
			step1 ="<fieldset>"
			step1 = step1 + "<div  id= caption_#{arg_qstn_object.id}>"
			if arg_qstn_metadata_object.prompt_style_class == "fi-alert"
				step2 = "#{step1} <caption class='fontc'><b class = '#{arg_qstn_metadata_object.prompt_style_class}' style='color: red'></b> #{arg_qstn_object.title}</caption>"
			else
				step2 = "#{step1} <caption class='fontc'>#{arg_qstn_object.title}</caption>"
			end
			step2 = step2 + "</div>"
        	step3 = "#{step2} <div><table id = table_#{get_comp_id(arg_qstn_metadata_object)}>"
        	step4 = step3
        	arg_qstn_multi_response_collection.each do |arg_rsp|
        		# check if this checkbox value is present in answers table - then checkbox should be checked.
        		if answer_populated == true
        			# is this checkbox checked?
        			ls_checked = PrescreenAssessmentAnswer.get_answer_collection_for_question_value(arg_prescreen_household_id,arg_qstn_object.id,arg_rsp.val)
					if ls_checked == true
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}  for='#{arg_rsp.id}'><tr><td width='10%'><input id='checkbox_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='checkbox' value='#{arg_rsp.val}' checked='checked' /></td><td>#{arg_rsp.txt}</td></tr></label>"
					else
						step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}  for='#{arg_rsp.id}'><tr><td width='10%'><input id='checkbox_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='checkbox' value='#{arg_rsp.val}' /></td><td>#{arg_rsp.txt}</td></tr></label>"
					end
        		else
        			step4 =  "#{step4} <label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_rsp)}  for='#{arg_rsp.id}'><tr><td width='10%'><input id='checkbox_#{arg_rsp.id}' name='#{arg_rsp.assessment_question_id}[]' type='checkbox' value='#{arg_rsp.val}' /></td><td>#{arg_rsp.txt}</td></tr></label>"
        		end
        	end
        	step5 =  "#{ step4} </table></div></fieldset>"
			ret_html = step5

		elsif arg_qstn_metadata_object.response_data_type == "DROPDOWN"
			if arg_qstn_metadata_object.prompt_style_class == "fi-alert"
				step1 ="<label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_qstn_object)} for = #{arg_qstn_object.id}><b class = '#{arg_qstn_metadata_object.prompt_style_class}' style='color: red'></b> #{arg_qstn_object.title}</label>"
			else
				step1 ="<label id= #{get_ind_comp_id(arg_qstn_metadata_object,arg_qstn_object)} for = #{arg_qstn_object.id}>#{arg_qstn_object.title}</label>"
			end
        	step2 = "#{step1} <div class = 'row' ><div class='large-5 columns'><select  id = dropdown_#{arg_qstn_object.id} name = #{arg_qstn_object.id} >"
        	step3 = step2
        	arg_qstn_multi_response_collection.each do |arg_rsp|
        		# check if this checkbox value is present in answers table - then checkbox should be checked.
        		if answer_populated == true
        			# is this checkbox checked?
        			# ls_checked = ClientAssessmentAnswer.get_answer_collection_for_question_value(arg_prescreen_household_id,arg_qstn_object.id,arg_rsp.val)
					if ans_val == arg_rsp.val
						step3 =  "#{step3} <option selected = 'selected' value= #{arg_rsp.val}>#{arg_rsp.txt}</option>"
					else
						step3 =  "#{step3} <option value= #{arg_rsp.val}>#{arg_rsp.txt}</option>"
					end
        		else
        			step3 =  "#{step3} <option value= #{arg_rsp.val}>#{arg_rsp.txt}</option>"
        		end
        	end
        	step4 =  "#{ step3} </select></div></div>"
			ret_html = step4

		end

		return ret_html
	end


	# def show_prescreen_assessment_question_control(arg_question_id,arg_prescreen_household_id)
	# 	Rails.logger.debug("arg_question_id = #{arg_question_id}")
	# 	ls_content_tag = " "
	# 	answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,arg_question_id)
	# 	if answer_collection.present?
	# 		logger.debug("in method show_prescreen_assessment_question_control")
	# 		assessment_question_object = AssessmentQuestion.find(arg_question_id)
	# 		assessment_question_multi_response_collection = AssessmentQuestionMultiResponse.get_responses_for_question_id(arg_question_id)
	# 			if assessment_question_multi_response_collection.present?
	# 				logger.debug("assessment_question_multi_response_collection.present? is true")
	# 				ls_muti_response = show_prescreen_assessment_multi_response(arg_prescreen_household_id,assessment_question_object,assessment_question_multi_response_collection)
	# 				ls_content_tag = ls_muti_response
	# 			else
	# 				# logger.debug("assessment_question_multi_response_collection.present? is true")
	# 				assessment_question_metedata_object = AssessmentQuestionMetadatum.get_question_metedata_object(arg_question_id)
	# 				html_control = assessment_question_metedata_object.response_data_type
	# 				answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,arg_question_id)

	# 				if html_control == "LABEL"
	# 					if answer_collection.present?
	# 						ls_content_tag = content_tag(:b,assessment_question_object.title)
	# 					end
	# 				elsif html_control =="TEXT"
	# 					# answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,arg_question_id)
	# 					if answer_collection.present?
	# 						answer_populated = true
	# 						ans_val = answer_collection.first.answer_value
	# 					else
	# 						answer_populated = false
	# 						ans_val = ""
	# 					end
	# 					if ans_val.present?
	# 						step1 = "<p> <b> #{assessment_question_object.title}: </b>"
	# 						step2 = "#{step1} #{ans_val} </p>"
	# 						ls_content_tag = step2
	# 					end
	# 				elsif html_control =="TEXTAREA"
	# 					# answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,arg_question_id)
	# 					if answer_collection.present?
	# 						answer_populated = true
	# 						ans_val = answer_collection.first.answer_value
	# 					else
	# 						answer_populated = false
	# 						ans_val = ""
	# 					end
	# 					if ans_val.present?
	# 						step1 = "<p> <b> #{assessment_question_object.title}: </b>"
	# 						step2 = "#{step1} #{ans_val} </p>"
	# 						ls_content_tag = step2
	# 					end

	# 				elsif html_control == "CHECKBOX"
	# 					# answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,arg_question_id)
	# 					if answer_collection.present?
	# 						answer_populated = true
	# 						ans_val = answer_collection.first.answer_value
	# 						if ans_val.present?
	# 							if ans_val == "on"
	# 								ans_val = "Yes"
	# 							end
	# 						end

	# 					else
	# 						answer_populated = false
	# 						ans_val = " "
	# 					end

	# 					step1 = "<p> <b> #{assessment_question_object.title}: </b>"
	# 					step2 = "#{step1} #{ans_val} </p>"
	# 					ls_content_tag = step2
	# 				end

	# 				# logger.debug("ls_content_tag -no multi = #{ls_content_tag}")
	# 			end
	# 		# logger.debug("final -ls_content_tag in display_assessment_question_control = #{ls_content_tag}")
	# 	end
	# 	return ls_content_tag
	# end

	# def show_prescreen_assessment_multi_response(arg_prescreen_household_id,arg_qstn_object,arg_qstn_multi_response_collection)
	# 	step3 = " "
	# 	answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,arg_qstn_object.id)
	# 	if answer_collection.present?
	# 		answer_populated = true
	# 		ans_val = answer_collection.first.answer_value
	# 	else
	# 		answer_populated = false
	# 	end

	# 	if arg_qstn_object.question_text.present?
	# 		text_value = arg_qstn_object.question_text
	# 	else
	# 		text_value = arg_qstn_object.title
	# 	end

	# 	if answer_populated == true
	# 		step1 = "<p> <b> #{text_value}: </b>"
	# 		step2 = step1
	# 	end
	# 	arg_qstn_multi_response_collection.each do |arg_rsp|
	# 		Rails.logger.debug("arg_rsp = #{arg_rsp.inspect}")
	# 		if answer_populated == true
	# 			if answer_collection.size > 1
	# 				# Multi select - One question has multiple answers like - work interests - can be
	# 				# working alone,working with ideas, .... - checkbox group user interface
	# 				ls_answers = ""
	# 				Rails.logger.debug("answer_collection = #{answer_collection.inspect}")
	# 				ls_checked = PrescreenAssessmentAnswer.get_answer_collection_for_question_value(arg_prescreen_household_id,arg_qstn_object.id,arg_rsp.val)
	# 				if ls_checked == true
	# 					ls_answers = "#{ls_answers},#{arg_rsp.val} "
	# 				end
	# 				# answer_collection.each do |each_answer|
	# 				# 	Rails.logger.debug("each_answer = #{each_answer.inspect}")
	# 				# 	ls_answers = "#{ls_answers},#{each_answer.answer_value} "
	# 				# end
	# 				step2 = "#{step2} #{ls_answers}  "
	# 			else
	# 				if ans_val == arg_rsp.val
	# 					step2 = "#{step2} #{get_flag_value_description_assessment(ans_val)}"
	# 				else
	# 					step2 = "#{step2}  "
	# 				end
	# 			end

	# 		# else
	# 		# 	step2 = "#{step2}  "
	# 		end
	# 	end



	# 	step3 = "#{step2} </p>"
	# 	return step3
	# end






	def get_self_of_program_unit_from_queue(arg_queue_id)
		ls_self_of_program_unit = WorkQueue.get_self_of_program_unit_for_a_given_queue(arg_queue_id)
    	if ls_self_of_program_unit.present?
			return ls_self_of_program_unit
		else
			return " "
		end
	end

	def get_self_of_program_unit_name(arg_program_unit_id)
		ProgramUnitMember.get_primary_beneficiary_name(arg_program_unit_id)
	end

	def get_ed_worker_name(arg_queue_id)
		# This is called from Queue
		queue_object = WorkQueue.find(arg_queue_id)
		program_unit_object = ProgramUnit.find(queue_object.reference_id)
		ls_ed_worker_name = get_user_name(program_unit_object.eligibility_worker_id)
		return ls_ed_worker_name
	end

	def can_logged_in_user_edit?(arg_entity_type,arg_entity_id)
		lb_return = false
		user_object = User.where("uid = ?",current_user.uid).first
		#Rails.logger.debug("user_object = #{user_object.inspect}")

		# Rule: User responsible for the entity will be able to edit.
		# User can assign the task to themself by assigning queue record to themself.
		case arg_entity_type
		when "CLIENT_APPLICATION"
			client_application_object = ClientApplication.find(arg_entity_id)
			if client_application_object.intake_worker_id == user_object.uid
				lb_return = true
			end
		when "PROGRAM_UNIT"
			program_unit_object = ProgramUnit.find(arg_entity_id)
			if  program_unit_object.eligibility_worker_id == user_object.uid
				lb_return = true
			end
		when "EMPLOYMENT_PLANNING"
			program_unit_object = ProgramUnit.find(arg_entity_id)
			if  program_unit_object.case_manager_id == user_object.uid
				lb_return = true
			end

		# when "ASSESSMENT"
		# 	if ClientAssessment.is_assessment_used_in_planning?(arg_entity_id,user_object.uid) == true
		# 		lb_return = true
		# 	end
			# program_unit_object = ProgramUnit.find(arg_entity_id)
			# if  program_unit_object.case_manager_id == user_object.uid
			# 	lb_return = true
			# end
		when "REQUEST_TO_APPROVE_CPP"
			# cpp_object = CareerPathwayPlan.find(arg_entity_id)
			# if cpp_object.supervisor_signature == user_object.uid
			# 	lb_return = true
			# end

			program_unit_object = ProgramUnit.find(arg_entity_id)
			program_task_owners = ProgramUnitTaskOwner.where("program_unit_id = ?
				                                              and ownership_type = 6619
				                                              and ownership_user_id = ?",arg_entity_id,user_object.uid)

			if program_task_owners.present?
				lb_return = true
			end

		when "REQUEST_TO_APPROVE_BENEFIT_AMOUNT"
			program_unit_object = ProgramUnit.find(arg_entity_id)
			program_task_owners = ProgramUnitTaskOwner.where("program_unit_id = ?
				                                              and ownership_type = 6620
				                                              and ownership_user_id = ?",arg_entity_id,user_object.uid)
			if program_task_owners.present?
				lb_return = true
			end

		when "SANCTION"
			 sanction_object = Sanction.find(arg_entity_id)
			if sanction_object.compliance_office_id == user_object.uid
				lb_return = true
			end
		when "MASTER_CLIENT_MANAGEMENT"
			# is the passed client in Open program unit, then either case manager /ED worker of that case should be able to make change to it.
			# OR let this be access rights driven - and alerts are sent to case manager/ed worker when somebody front desk specialist changes the data.


		end
		return lb_return

	end

	def get_household_member_name(arg_household_member_id)
		hh_member_object = HouseholdMember.find(arg_household_member_id)
		client_object = Client.find(hh_member_object.client_id)
		return client_object.get_full_name
	end

	def get_run_month_summary_eligibility_info(arg_program_wizard)
		result = ""
		program_month_summary_collection = ProgramMonthSummary.get_program_month_summary_collection(arg_program_wizard.run_id,arg_program_wizard.month_sequence)
		if program_month_summary_collection.present?
			result = get_flag_description(program_month_summary_collection.first.budget_eligible_ind)
		end
		return result
	end

	def get_age(arg_client_id)
		age = Client.get_age(arg_client_id)
		if age == 0
			age = Client.get_age_in_months(arg_client_id).to_i
			if age > 0
				age = pluralize(age,'Month')
			else
				age = pluralize(Client.get_age_in_days(arg_client_id).to_i,'Day')
			end
		elsif age == -1
			age = nil
		end
		return age
	end

	def get_client_type(arg_client_id)
		age = Client.get_age(arg_client_id)
		if age.present?
		    return ((age > 17) ? "Adult" : "Child")
		end
	end

	# def get_client_status(arg_family_struct, arg_client_id)
	# 	# Rails.logger.debug("arg_family_struct = #{arg_family_struct.inspect}")
	# 	# Rails.logger.debug("arg_client_id = #{arg_client_id}")
	# 	# status = nil
	# 	# if Client.get_age(arg_client_id) > 17
	# 	# 	arg_family_struct.adults_struct.each do |adult_struct|
	# 	# 		# Rails.logger.debug("adult_struct.parent_id == arg_client_id = #{adult_struct.parent_id == arg_client_id}")
	# 	# 		# Rails.logger.debug("adult_struct.caretaker_id == arg_client_id = #{adult_struct.caretaker_id == arg_client_id}")
	# 	# 		if (adult_struct.parent_id.present? && adult_struct.parent_id == arg_client_id) ||
	# 	# 			(adult_struct.caretaker_id.present? && adult_struct.caretaker_id == arg_client_id)
	# 	# 			# Rails.logger.debug("-->adult_struct = #{adult_struct.inspect}")
	# 	# 			# fail
	# 	# 			status = drop_down_value_description(adult_struct.status)
	# 	# 			break
	# 	# 		# else
	# 	# 			# Rails.logger.debug("status = Inactive Full")
	# 	# 			# fail
	# 	# 			# status = drop_down_value_description(4470)
	# 	# 		end
	# 	# 	end
	# 	# else
	# 	# 	status = drop_down_value_description(4468)
	# 	# end
	# 	drop_down_value_description(arg_family_struct.member_status[arg_client_id])
	# 	# return status
	# end

	# def get_client_status_in_program_unit(arg_program_unit_id,arg_client_id)
	# 	status = nil
	# 	program_unit_member = ProgramUnitMember.get_program_unit_member(arg_program_unit_id,arg_client_id)
	# 	status = drop_down_value_description(program_unit_members.member_status) if program_unit_member.present?
	# 	return status
	# end

	# def is_the_client_active_in_an_open_pgu(arg_client_id, arg_service_program_id)
	# 	if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_id)
	# 		return "Active"
	# 	else
	# 		program_unit = ProgramUnitMember.is_the_client_associated_with_any_program_unit_which_has_not_been_activated?(arg_client_id, arg_service_program_id)
	# 		if program_unit.present?
	# 			return "Active"
	# 		else
	# 			return "Not Active"
	# 		end
	# 	end
	# end

	def is_child(arg_client_id)
		Client.is_child(arg_client_id)
	end

	def get_ssn_with_client_id(arg_client_id)
		client_object = Client.find(arg_client_id)
		ssn = client_object.ssn

		first_three=""
		first_three = ssn.first(3) if ssn.first(3).present?
		# next 2 characters - 45
		next_two = ""
		next_two =  ssn.from(3).to(-5)  if ssn.from(3).to(-5).present?
		# next 4 character - 4057
		last_four= ""
		last_four = ssn.from(-4) if ssn.from(-4).present?
		ls_out = "#{first_three}-#{next_two}-#{last_four}"
		return ls_out
	end

	def client_race_ethnicity_choices
		array = [["Yes", "Y"], ["No", "N"], ["Unknown", "U"]]
		return  array
	end

	def get_barrier_addressed_information_in_pending_cpp(arg_client_id,arg_action_plan_id,arg_barrier_id)
		# Manoj 04/19/2016
		if CareerPathwayPlan.is_passed_barrier_addressed_in_pending_cpp?(arg_client_id,arg_action_plan_id,arg_barrier_id) == true
			return 'Yes'
		else
			return 'No'
		end
	end

	def get_barrier_addressed_information_in_approved_cpp(arg_career_pathway_plan_id,arg_barrier_id)
		# Manoj 04/19/2016
		if CareerPathwayPlan.is_passed_barrier_addressed_in_approved_cpp?(arg_career_pathway_plan_id,arg_barrier_id) == true
			return 'Yes'
		else
			return 'No'
		end
	end

end






