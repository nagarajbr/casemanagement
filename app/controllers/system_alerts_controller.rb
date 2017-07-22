class SystemAlertsController <  AttopAncestorController

  	def new

		@alerts = Alert.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SystemAlertsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Failed to save new alert information."
		redirect_to_back
	end

	def create
		@alerts = Alert.new(params_values)
		@alerts.alert_category = 6347
		if @alerts.save
    	 redirect_to system_alerts_index_path, notice: "Alert information saved."
		else
		 render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SystemAlertsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to create alert information."
		redirect_to_back
	end

	def index
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@general_information_alert = Alert.get_general_information_alerts()
		@general_information_expired = Alert.get_general_information_expired().page(params[:page]).per(l_records_per_page)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SystemAlertsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to access alert information."
		redirect_to_back
	end

	def show
		 @alerts = Alert.find(params[:alert_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SystemAlertsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid alert information."
		redirect_to_back
	end

	def edit
		@alerts = Alert.find(params[:alert_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SystemAlertsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to update alert information."
		redirect_to_back
	end

	def update
		@alerts = Alert.find(params[:alert_id])
		if @alerts.update(params_values)
		 redirect_to system_alerts_show_path(@alerts.id), notice: "Alert is saved."
		else
		 render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SystemAlertsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to update alert information."
		redirect_to_back
	end

	def destroy
		@alerts = Alert.find(params[:id])
		@alerts.destroy
		redirect_to system_alerts_index_path, alert: "Alert information deleted"
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SystemAlertsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -Failed to delete alert information."
		redirect_to_back
	end

	private


	 def params_values
	  	params.require(:alert).permit(:alert_text,:expiration_date)
	  end




end
