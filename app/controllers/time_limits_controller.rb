class TimeLimitsController < AttopAncestorController
	# Author : Manoj Patil
	#  Date: 08/21/2014
	def index
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID])
			@time_limits = @client.time_limits#.order("payment_month DESC")
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("TimeLimitsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

end
