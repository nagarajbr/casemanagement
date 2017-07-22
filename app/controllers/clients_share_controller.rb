class ClientsShareController < AttopAncestorController


	# Manoj -09/01/2014
	# new page for new search
	 def new_share_search

    		# Open new Modal client search window -

  		@type = params[:type]
  		@client = Client.new
  		# session[:NAVIGATED_FROM] ||= request.referer
  		# logger.debug "MNP-session[:NAVIGATED_FROM] in client share controller= #{session[:NAVIGATED_FROM] }"
  		render 'share_search'

  		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ClientsShareController","new_share_search",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to search client."
			redirect_to_back
  	end

  	def share_search

	    	# Manoj 09/01/2014
	  	# Client search from SEarch service object
	  	#  09/01/2014
	  	l_client_serach_service = SearchModule::ClientSearch.new
	  	# Client search service will return Client result object or Error Message string object
	   	return_obj = l_client_serach_service.search(params)

	  	if return_obj.class.name == "String"

	  		# flash the error message
	  		flash.now[:notice] = return_obj
	  	else

	  		# results found
	  		@clients = return_obj
	  	end

	  	rescue => err

			error_object = CommonUtil.write_to_attop_error_log_table("ClientsShareController","share_search",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to search client."
			redirect_to_back
    end



    def create_share
  		case params[:type]
				when 'income'
					if ClientIncome.where("client_id = ? and income_id = ?",params[:id],params[:type_id]).count == 0
						if ClientIncome.create(client_id: params[:id], income_id: params[:type_id])
							msg = "Income shared."
						else
							msg = "Can't share income."
						end
					else
						msg = "Income is already shared across this client."
					end
					if session["FOCUS_MENU"].present?
						@menu = session["FOCUS_MENU"]
					else
						@menu = "CLIENT"
					end
					if session[:MEMBER_FINANCE_STEP_PROCESS].present? &&  session[:MEMBER_FINANCE_STEP_PROCESS] == 'Y'
						session[:MEMBER_FINANCE_STEP_PROCESS] = nil
						redirect_to start_household_member_registration_wizard_path, notice:msg
					else
						redirect_to show_shared_income_path(@menu,params[:type_id]), notice:msg
					end

				when 'resource'
					if ClientResource.where("client_id = ? and resource_id = ?",params[:id],params[:type_id]).count == 0
						if ClientResource.create(client_id: params[:id], resource_id: params[:type_id], usage_percentage: '100.00')
							msg = "Resource shared."
						else
							msg = "Can't share resource."
						end
					else
						msg = "Resource is already shared across this client."
					end
					if session[:MEMBER_FINANCE_STEP_PROCESS].present? &&  session[:MEMBER_FINANCE_STEP_PROCESS] == 'Y'
						redirect_to start_household_member_registration_wizard_path, notice:msg
					else
						redirect_to show_shared_resource_path(params[:type_id]), notice:msg
					end
				when 'expense'
					if ClientExpense.where("client_id = ? and expense_id = ?",params[:id],params[:type_id]).count == 0
						if ClientExpense.create(client_id: params[:id], expense_id: params[:type_id])
							msg = "Expense shared."
						else
							msg = "Can't share expense."
						end
					else
						msg = "Expense is already shared across this client."
					end
					if session[:MEMBER_FINANCE_STEP_PROCESS].present? &&  session[:MEMBER_FINANCE_STEP_PROCESS] == 'Y'
						redirect_to start_household_member_registration_wizardpath, notice:msg
					else
						redirect_to show_shared_expense_path(params[:type_id]), notice:msg
					end
		end
		session[:NAVIGATED_FROM] = nil
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ClientsShareController","create_share",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to create shared details."
			redirect_to_back
  	end

  def destroy
  	case params[:type]
				when 'income'
					@client_income = ClientIncome.find_by(client_id: params[:id], income_id: params[:type_id])
					@client = Client.find(params[:id])
					@client_income.destroy
					if session["FOCUS_MENU"].present?
						@menu = session["FOCUS_MENU"]
					else
						@menu = "CLIENT"
					end
					msg = "Shared income for #{@client.get_client_name} successfully deleted."
					if session[:MEMBER_FINANCE_STEP_PROCESS].present? &&  session[:MEMBER_FINANCE_STEP_PROCESS] == 'Y'
						redirect_to start_household_member_registration_wizard_path, alert:msg
					else
						redirect_to show_shared_income_path(@menu,params[:type_id]), alert:msg
					end
				when 'resource'

					@client_resource = ClientResource.find_by(client_id: params[:id], resource_id: params[:type_id])
					@client = Client.find(params[:id])
					@client_resource.destroy
					msg = "Shared resource for #{@client.get_client_name} successfully deleted."
					if session[:MEMBER_FINANCE_STEP_PROCESS].present? &&  session[:MEMBER_FINANCE_STEP_PROCESS] == 'Y'
						redirect_to start_household_member_registration_wizard_path, alert:msg
					else
						redirect_to show_shared_resource_path(params[:type_id]), alert:msg
					end
				when 'expense'
					@client_expense = ClientExpense.find_by(client_id: params[:id], expense_id: params[:type_id])
					@client = Client.find(params[:id])
					@client_expense.destroy
					msg = "Shared expense for #{@client.get_client_name} successfully deleted."
					if session[:MEMBER_FINANCE_STEP_PROCESS].present? &&  session[:MEMBER_FINANCE_STEP_PROCESS] == 'Y'
						redirect_to start_household_member_registration_wizard_path, alert:msg
					else
						redirect_to show_shared_expense_path(params[:type_id]), alert:msg
					end
		end
		session[:NAVIGATED_FROM] = nil
  end
  rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ClientsShareController","destroy",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to delete shared details."
			redirect_to_back
end
