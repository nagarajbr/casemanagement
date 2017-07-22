class PaymentLineItemsController < AttopAncestorController
	def index
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			@client_payment_line_item = PaymentLineItem.service_payments_for_client(@client.id)

		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("PaymentLineItemsController","index",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to show payments."
			redirect_to_back

	end

	def show

		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			@payment_line_item = PaymentLineItem.find(params[:id].to_i)
			@client_payment_line_item_show = PaymentLineItem.service_payments_for_client_and_payment_id(@client.id,@payment_line_item.id).first

		end
       rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("PaymentLineItemsController","show",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to show payments."
			redirect_to_back

	end
end
