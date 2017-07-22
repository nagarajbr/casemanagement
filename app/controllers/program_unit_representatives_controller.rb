class ProgramUnitRepresentativesController < AttopAncestorController
	before_action :set_program_unit, only: [:index,:new,:create,:show,:edit,:update,:destroy]
	before_action :get_program_unit_representative, only: [:show,:edit,:update,:destroy]
	before_action :get_program_unit_members, only: [:new,:create,:edit,:update]
	before_action :get_program_unit_members_for_representatives, only: [:new,:create,:edit,:update]

	def index
		@client = Client.find(session[:CLIENT_ID])
		@program_unit_representatives = ProgramUnitRepresentative.get_all_program_unit_representatives_for_program_unit(session[:PROGRAM_UNIT_ID].to_i)
        @program_unit_id = session[:PROGRAM_UNIT_ID].to_i
        @show_hyperlink = true
	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","index",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid program unit representative."
			redirect_to_back
	end

	def new
		@client = Client.find(session[:CLIENT_ID])
		@program_unit_representative = ProgramUnitRepresentative.new
		@program_unit_representative.program_unit_id = session[:PROGRAM_UNIT_ID]
		@program_unit_id = session[:PROGRAM_UNIT_ID]
	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","new",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when attempting to create new program unit representative."
			redirect_to_back
	end

	def create

		msg = nil
		@client = Client.find(session[:CLIENT_ID])
		@program_unit_id = session[:PROGRAM_UNIT_ID]
		@program_unit_representative = ProgramUnitRepresentative.new(params_values)
		@program_unit_representative.program_unit_id = session[:PROGRAM_UNIT_ID]
		@program_unit_representative.status = 6223
		if @program_unit_representative.valid?
			begin
	            ActiveRecord::Base.transaction do
	            	common_action_argument_object = CommonEventManagementArgumentsStruct.new
	            	common_action_argument_object.logged_in_user_id = current_user.uid
	            	common_action_argument_object.event_id = 818 # "ProgramUnitRepresentativesController - Save"
			        common_action_argument_object.client_id = @program_unit_representative.client_id
			        common_action_argument_object.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
			        @program_unit_representative.save!

			        msg = EventManagementService.process_event(common_action_argument_object)
	        	end
            msg = "SUCCESS"
	        rescue => err
	        	error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","create",err,current_user.uid)
	        	msg = "Failed to add representative - for more details refer to rrror ID: #{error_object.id}."
	    	end
			if msg == "SUCCESS"
				redirect_to program_unit_representatives_index_path(@selected_program_unit), notice: "Program unit representative saved."
			else
				flash.now[:alert] = msg
				render :new
			end
		else
			render :new
		end

	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","create",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when saving program unit representative."
			redirect_to_back
	end

	def show
		@client = Client.find(session[:CLIENT_ID])
		 @program_unit_id = session[:PROGRAM_UNIT_ID]
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","show",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when showing program unit representative."
			redirect_to_back
	end

	def edit
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","edit",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when editing program unit representative."
			redirect_to_back

	end

	def update
		if @program_unit_representative.update(edit_params_values)
			 redirect_to program_unit_representatives_show_path(@program_unit_representative.id), notice: "Program unit representative saved"
		else
			render :edit
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","update",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when updating program unit representative."
			redirect_to_back
	end
	def program_unit_representative_deactivated
		msg = nil
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		@program_unit_representative = ProgramUnitRepresentative.find(params[:id])
		@program_unit_members_collection = ProgramUnitMember.sorted_program_unit_members(session[:PROGRAM_UNIT_ID])
		@program_unit_members_collection_for_representatives = ProgramUnitMember.get_clients_for_representative_selection(session[:PROGRAM_UNIT_ID])
        @program_unit_representative.end_date = Date.today
        begin
            ActiveRecord::Base.transaction do
            	common_action_argument_object = CommonEventManagementArgumentsStruct.new
            	common_action_argument_object.logged_in_user_id = current_user.uid
            	common_action_argument_object.event_id = 678 # "ProgramUnitRepresentativesController - Deactivate"
		        common_action_argument_object.client_id = @program_unit_representative.client_id
		        common_action_argument_object.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
		        @program_unit_representative.save!
		        msg = EventManagementService.process_event(common_action_argument_object)
        	end
        rescue => err
        	error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","program_unit_representative_deactivated",err,AuditModule.get_current_user.uid)
        	msg = "Failed to deactivate representative - for more details refer to error ID: #{error_object.id}."
    	end
    	if msg == "SUCCESS"
    		redirect_to program_unit_representatives_show_path(@program_unit_representative.id), notice: "Program unit representative deactivated."
    	else
    		flash.now[:alert] = msg
    		render :show
        end

       rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","program_unit_representative_deactivated",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when deactivating program unit representative."
			redirect_to_back

	end

	def destroy
		@program_unit_representative.destroy
		redirect_to program_unit_representatives_index_path(@selected_program_unit), alert: "Program unit representative deleted"
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","destroy",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when deleting program unit representative."
			redirect_to_back
	end

	def ebt_representative
		@client = Client.find(session[:CLIENT_ID])
		instances_for_ebt_representative
		@program_unit_representative = ProgramUnitRepresentative.new
	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","ebt_representative",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when attempting to create new EBT representative."
			redirect_to_back
	end

	def add_ebt_representative
		@client = Client.find(session[:CLIENT_ID])
		if params[:add].present?
			save_ebt_representative("add")
		else
			if params[:program_unit_representative][:client_id].present? || params[:program_unit_representative][:representative_type].present?
				save_ebt_representative("next")
			elsif ProgramUnitRepresentative.get_all_program_unit_representatives_for_program_unit(params[:program_unit_id].to_i).blank?
				instances_for_ebt_representative
				@program_unit_representative = ProgramUnitRepresentative.new
				flash.now[:notice] = "Please add atleast one EBT representative."
				render :ebt_representative
			else
				program_wizard = ProgramWizardService.by_pass_program_wizard_and_run_ed(params[:program_unit_id].to_i)
				redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,program_wizard.id)
			end
		end
	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitRepresentativesController","add_ebt_representative",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when adding EBT representative."
			redirect_to_back
	end



	private

	def params_values
		params.require(:program_unit_representative).permit(:client_id,:representative_type,:start_date,:end_date)
	end
	def edit_params_values
		params.require(:program_unit_representative).permit(:client_id,:representative_type,:status,:start_date,:end_date)
	end
	def set_program_unit
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
	end
	def get_program_unit_representative
		@program_unit_representative = ProgramUnitRepresentative.find(params[:id])
	end
	def get_program_unit_members
		@program_unit_members_collection = ProgramUnitMember.sorted_program_unit_members(session[:PROGRAM_UNIT_ID])
	end
	def get_program_unit_members_for_representatives
		@program_unit_members_collection_for_representatives = ProgramUnitMember.get_clients_for_representative_selection(session[:PROGRAM_UNIT_ID])
	end

	def instances_for_ebt_representative
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		@program_unit_representatives = ProgramUnitRepresentative.get_all_program_unit_representatives_for_program_unit(params[:program_unit_id].to_i)
		case @selected_program_unit.case_type
		when 6046,6047
			# @program_unit_members_collection_for_representatives = ProgramUnitMember.get_clients_for_representative_selection(params[:program_unit_id].to_i)
			@program_unit_members_collection_for_representatives = ProgramUnitService.get_parent_list_for_the_program_unit(params[:program_unit_id].to_i)
			if @program_unit_representatives.present?
				client_ids = @program_unit_representatives.select("program_unit_representatives.client_id")
				@program_unit_members_collection_for_representatives = @program_unit_members_collection_for_representatives.where("program_unit_members.client_id not in (?)", client_ids)
			end
		when 6048,6049
			@program_unit_members_collection_for_representatives = HouseholdMember.get_all_members_in_the_household(session[:HOUSEHOLD_ID])
			if @program_unit_representatives.present?
				client_ids = @program_unit_representatives.select("program_unit_representatives.client_id")
				@program_unit_members_collection_for_representatives = @program_unit_members_collection_for_representatives.where("household_members.client_id not in (?)", client_ids)
			end
		end


	end

	def save_ebt_representative(arg_save_type)
		@program_unit_representative = ProgramUnitRepresentative.new(params_values)
		@program_unit_representative.status = 6223
		@program_unit_representative.program_unit_id = params[:program_unit_id].to_i
		if @program_unit_representative.valid?
			@program_unit_representative.save
			if arg_save_type == "add"
				redirect_to ebt_representative_path(params[:program_unit_id].to_i)
			else
				program_wizard = ProgramWizardService.by_pass_program_wizard_and_run_ed(params[:program_unit_id].to_i)
				redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,program_wizard.id)
			end
		else
			instances_for_ebt_representative
			render :ebt_representative
		end
	end
end
