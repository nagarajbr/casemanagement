class CostCentersController < AttopAncestorController

	def index
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@cost_centers = CostCenter.all.page(params[:page]).per(l_records_per_page)
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("CostCentersController","index",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
			redirect_to_back
	end

	def new
		@cost_center = CostCenter.new
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("CostCentersController","new",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid cost center."
			redirect_to_back
	end

	def create
		@cost_center = CostCenter.new(param_values)
		if @cost_center.save
		 redirect_to cost_centers_path, notice: "Cost center information saved."
		else
		 render :new
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("CostCentersController","create",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when creating cost center."
			redirect_to_back
	end

	def show
		@cost_center = CostCenter.find(params[:id])
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("CostCentersController","show",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Failed to find cost center."
			redirect_to_back
	end

	def edit
		@cost_center = CostCenter.find(params[:id])
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("CostCentersController","edit",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid cost center."
			redirect_to_back
	end

	def update
		@cost_center = CostCenter.find(params[:id])
		if @cost_center.update(param_values)
		 redirect_to cost_center_path(@cost_center.id), notice: "Client score saved."
		else
		 render :edit
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("CostCentersController","update",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when updating cost center."
			redirect_to_back
	end

	def destroy
		@cost_center = CostCenter.find(params[:id])
		@cost_center.destroy
		redirect_to cost_centers_path, alert: "Cost Center information deleted"
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("CostCentersController","destroy",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error while deleting cost center."
			redirect_to_back
	end

	private

		def param_values
			params.require(:cost_center).permit(:service_program_group, :cost_center, :internal_order, :gl_account, :service_type)
		end

end
