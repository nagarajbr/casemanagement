class ProgramUnitTransfersController < AttopAncestorController
	before_action :set_values, only: [:new,:create]
	def index
		@logged_in_user = current_user.uid
		@household = Household.find(session[:HOUSEHOLD_ID])
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@program_units_for_user = ProgramUnit.get_logged_in_user_active_program_units(current_user.uid,session[:HOUSEHOLD_ID].to_i).page(params[:page]).per(l_records_per_page).order("id  desc")
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitTransfersController","index",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when getting cases related to the user."
			redirect_to_back
	end

	def new
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitTransfersController","new",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when creating."
			redirect_to_back
	end

	def create
		open_action_plans = ActionPlan.is_program_unit_having_open_actions(params[:program_unit_id].to_i)
		if open_action_plans
			flash[:alert] = "Close open employment plans within program unit prior to transfer."
			redirect_to program_unit_transfer_path
		else
			if params[:program_unit_id].present? and params[:local_office].present?
				ls_msg = ProgramUnit.transfer_program_unit_to_different_local_office(params[:program_unit_id],params[:local_office])
				if ls_msg == "SUCCESS"
					flash[:notice] = "Case transfer is successful."
					redirect_to program_unit_transfer_path
				else
					flash[:notice] = ls_msg
					redirect_to program_unit_transfer_path
				end
			else
				@program_unit.errors[:base] << "Local office is required."
				render :new
			end
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitTransfersController","create",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when creating."
			redirect_to_back
	end

	private

	def set_values
		@program_unit = ProgramUnit.find(params[:program_unit_id])
		@all_user_local_office_list = CodetableItem.item_list(2,"Local office list")
	end
end