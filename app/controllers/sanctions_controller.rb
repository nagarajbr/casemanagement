class SanctionsController < AttopAncestorController
	# Author : Manoj Patil
	# Date : 08/21/2014
	# Description: CRUD operation for Model - Sanctions
	before_action :set_id, only: [:show,:edit,:update,:destroy]
	def new
		@client = Client.find(session[:CLIENT_ID])
		@service_program_list = ServiceProgram.get_sanctioned_tanf_service_programs
		@benefit_reducing_sanctions_list = CodetableItem.get_benefit_reducing_sanction_types
        @sanction = @client.sanctions.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when creating sanction details."
		redirect_to_back
	end

	def create
		@client = Client.find(session[:CLIENT_ID])
		@service_program_list = ServiceProgram.get_sanctioned_tanf_service_programs
		@benefit_reducing_sanctions_list = CodetableItem.get_benefit_reducing_sanction_types
		@sanction = @client.sanctions.new(params_values)
		if @sanction.valid?
			ls_msg = SanctionService.create_client_sanction_and_notes(@sanction,session[:CLIENT_ID],params[:notes])
			if ls_msg == "SUCCESS"
			 	redirect_to sanctions_path, notice: "Sanction created."
			else
				flash[:notice] = ls_msg
				render :new
			end

		else
			 render :new
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving sanction details."
		redirect_to_back
	end

	def index
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID])
			@sanctions = @client.sanctions

		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def show
		@client = Client.find(session[:CLIENT_ID])
		@sanction_details_present = Sanction.is_sanction_details_present(@sanction.id)
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6489,@sanction.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
		@is_it_progressive_sanction = Sanction.check_for_progressive_sanction(@sanction.sanction_type)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid sanction record."
		redirect_to_back
	end

	def edit
		@client = Client.find(session[:CLIENT_ID])
		@service_program_list = ServiceProgram.get_sanctioned_tanf_service_programs
		@benefit_reducing_sanctions_list = CodetableItem.get_benefit_reducing_sanction_types
		@sanction.updated_by = current_user.uid
		@notes = nil #NotesService.get_notes(6150,session[:CLIENT_ID],6489,@sanction.id)
		@sanction_details_present = SanctionDetail.get_sanction_details_by_sanction_id(@sanction.id)
		@sanction_details_present.each do |sanction_details|
			if sanction_details.present?
			@regular_payment_present_for_sanction_month = SanctionDetail.is_payment_month_present_for_sanction_details(sanction_details.sanction_month,sanction_details.sanction_id)
		    end
	    end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing sanction details."
		redirect_to_back
	end

	def update
		@service_program_list = ServiceProgram.get_sanctioned_tanf_service_programs
		@benefit_reducing_sanctions_list = CodetableItem.get_benefit_reducing_sanction_types
		@sanction.assign_attributes(params_values)
		if @sanction.valid?
			ls_msg = SanctionService.update_client_sanction_and_notes(@sanction,session[:CLIENT_ID],params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Sanction saved."
				redirect_to sanction_path(@sanction.id)
			else
				flash[:notice] = ls_msg
				render :edit
			end
		else
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating sanction record."
		redirect_to_back
	end

	def destroy
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6489,@sanction.id)
		ls_msg = SanctionService.delete_client_sanction_and_notes(@sanction,session[:CLIENT_ID],@notes)
		if ls_msg == "SUCCESS"
			flash[:notice] = "Sanction deleted."
			redirect_to sanctions_path
		else
			flash[:notice] = ls_msg
			render :show
		end
		# @sanction.destroy
		# If there is any pending work tasks/ alerts delete them

		# redirect_to sanctions_path, alert: "Sanction information deleted"
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting sanction details."
		redirect_to_back
	end


	private

	 def params_values
	  	params.require(:sanction).permit(:service_program_id,:sanction_type,:description,:infraction_begin_date,:infraction_end_date,
	  									   :mytodolist_indicator)
	  end

    def set_id
		 @sanction = Sanction.find(params[:id])
	 end




end
