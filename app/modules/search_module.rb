module SearchModule

	class ClientSearch



		def search(arg_params)

			if arg_params[:ssn].present?
  				arg_params[:ssn] = arg_params[:ssn].scan(/\d/).join
  			end

		  	# Manoj 09/01/2014
		  	l_client= Client.search(arg_params)

		  	if l_client.blank?
		  		results_found = false
		  		if arg_params[:ssn].present? || arg_params[:bud_unit].present? || (arg_params[:last_name].present? &&
		  		    arg_params[:first_name].present?) ||	arg_params[:gender].present?
	 				l_msg = "No results found"
		  		else
		  			if (arg_params[:last_name].present? || arg_params[:first_name].present?) && !(arg_params[:last_name].present? && arg_params[:first_name].present?)
		  				l_msg = "Enter both last name and first name to search by name"
		  			else
		  				l_msg = "Please enter at least one search field "
		  			end
		  		end
		  	else
		  		results_found = true
		  	end

		  	if results_found == true
		  		# return client object result
		  		return l_client
		  	else
		  		# return error message -string Object
		  		return l_msg
		  	end
		end

		def search_for_add_household_member(arg_household_id,arg_params)
			if arg_params[:ssn].present?
  				arg_params[:ssn] = arg_params[:ssn].scan(/\d/).join
  			end

		  	# Manoj 09/01/2014
		  	# l_client= Client.search(arg_params)
		  	client_collection = Client.search_for_add_household_member(arg_household_id,arg_params)

		  	if client_collection.blank?
		  		results_found = false
		  		if arg_params[:ssn].present? || arg_params[:bud_unit].present? || (arg_params[:last_name].present? &&
		  		    arg_params[:first_name].present?) ||	arg_params[:gender].present?
	 				l_msg = "No results found"
		  		else
		  			if (arg_params[:last_name].present? || arg_params[:first_name].present?) && !(arg_params[:last_name].present? && arg_params[:first_name].present?)
		  				l_msg = "Enter both last name and first name to search by name"
		  			else
		  				l_msg = "Please enter at least one search field "
		  			end
		  		end
		  	else
		  		results_found = true
		  	end

		  	if results_found == true
		  		# return client object result
		  		return client_collection
		  	else
		  		# return error message -string Object
		  		return l_msg
		  	end
		end



	end


	class ProviderSearch
		def search(arg_params)
			l_provider = Provider.search(arg_params)
			if l_provider.blank?
				if arg_params[:provider_name].present? || arg_params[:tax_id_ssn].present? ||  arg_params[:local_office].present? || arg_params[:service].present?
					l_msg = "No results found"
				else
					l_msg = "Please enter at least one search field "
				end
			else
				results_found = true
			end

			if results_found == true
		  		# return provider object result
		  		return l_provider
		  	else
		  		# return error message -string Object
		  		return l_msg
		  	end
		end
	end

	class EmployerSearch
		def search(arg_params)
			l_employer = Employer.search(arg_params)
			if l_employer.blank?
				if arg_params[:employer_name].present? || arg_params[:federal_ein].present? || arg_params[:state_ein].present?
					l_msg = "No results found"
				else
					l_msg = "Please enter at least one search field "
				end
			else
				results_found = true
			end

			if results_found == true
		  		# return provider object result
		  		return l_employer
		  	else
		  		# return error message -string Object
		  		return l_msg
		  	end
		end
	end


	class SchoolSearch
		def search(arg_params)
			l_school = School.search(arg_params)
			if l_school.blank?
				if arg_params[:school_name].present?
					l_msg = "No results found"
				else
					l_msg = "Please enter school name to search"
				end
			else
				results_found = true
			end

			if results_found == true

		  		return l_school
		  	else

		  		return l_msg
		  	end
		end
	end

end

