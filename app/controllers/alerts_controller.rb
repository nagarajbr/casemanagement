class AlertsController < AttopAncestorController
	# Manoj Patil 04/23/2015
	#
	def index

		l_records_per_page = SystemParam.get_pagination_records_per_page

		#Business Alerts

		# Capture from work_tasks table due_date = Table - Add entry into alerts table.
		# Manoj 10/12/2015 - revisit this code later



		# Get the alerts for the logged in user which are not complete.
		# @business_alerts =  Alert.get_business_alerts_for_user(@current_user.uid).page(params[:page]).page(params[:business]).per(l_records_per_page)
		@business_alerts_information_only =  Alert.get_business_alerts_for_user_information_only(current_user.uid).page(params[:page]).page(params[:information_only]).per(l_records_per_page)
		# System Alerts
		@general_information_alerts = Alert.get_general_information_alerts().page(params[:page]).page(params[:general_information]).per(l_records_per_page)
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("AlertsController","index",err,current_user)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid alert."
		redirect_to_back
	end


	def acknowledge
		alert_object = Alert.find(params[:alert_id])
		alert_object.status = 6341
		alert_object.save
		redirect_to alerts_path
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("AlertsController","acknowledge",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid alert."
		redirect_to_back
	end

end
