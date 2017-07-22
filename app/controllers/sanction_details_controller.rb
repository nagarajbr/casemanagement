class SanctionDetailsController < AttopAncestorController
	before_action :set_id, only: [:show,:edit,:update,:destroy]
	before_action :set_sanction_id, only: [:index,:new,:create,:show,:edit,:update,:destroy]
	def index
		@client = Client.find(session[:CLIENT_ID])
		@sanction_details = @sanction.sanction_details.order("sanction_month desc ")
		@is_it_progressive_sanction = Sanction.check_for_progressive_sanction(@sanction.sanction_type)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionDetailsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid sanction record."
		redirect_to_back
	end

	def new
		@client = Client.find(session[:CLIENT_ID])
		@sanction_detail = @sanction.sanction_details.new
		@sanction_indicator_list = CodetableItem.get_sanction_indicator_values(@sanction.sanction_type,@sanction.service_program_id)
		@sanction_detail.release_indicatior = "0"
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionDetailsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when new sanction detail record."
		redirect_to_back
	end

	def create
		msg = nil
		@client = Client.find(session[:CLIENT_ID])
		@sanction_detail = @sanction.sanction_details.new(params_values)
		@sanction_indicator_list = CodetableItem.get_sanction_indicator_values(@sanction.sanction_type,@sanction.service_program_id)
        @warnings = nil
		if @sanction_detail.valid?
		inspec = Date.civil(params[:sanction_detail]["sanction_month(1i)"].to_i,params[:sanction_detail]["sanction_month(2i)"].to_i,params[:sanction_detail]["sanction_month(3i)"].to_i)
		sanction_deatils = SanctionDetail.is_there_santion_detail_already_for_a_given_month_and_type(@sanction.id,@sanction.sanction_type,inspec)
			if sanction_deatils.present?
				@sanction_detail.errors[:base] << "Sanction month is already been taken."
				render :new
			else
				@warnings = @sanction_detail.add_sanction_after_checking_validations
				if (@warnings.present? && params[:skip_warnings_button].blank?)
					@sanction_detail.warning_count = @warnings.count
					render :new
				elsif (@warnings.blank? || params[:skip_warnings_button] == "Skip Warnings and save")
					if @sanction.sanction_type == 3081
						client_immunization =  SanctionDetailService.validate_immunization_sanction_details(@client.id)
						if client_immunization == "save"
							if ProgramUnit.get_open_program_unit_for_client(@client.id).present?
								run_month = Date.civil(params[:sanction_detail]["sanction_month(1i)"].to_i,params[:sanction_detail]["sanction_month(2i)"].to_i,params[:sanction_detail]["sanction_month(3i)"].to_i)
								msg = SanctionDetailService.save_sanction_details(@client.id,@sanction_detail,run_month)
							else
								@sanction_detail.save!
								msg = "SUCCESS"
							end
							if (msg == "SUCCESS" || msg.blank?)
								redirect_to sanction_sanction_details_path(@sanction.id), notice: "Sanction detail saved."
							else
								render :new
							end
						else
						@sanction_detail.errors[:base] << "#{client_immunization}"
						render :new
						end
					else
						if ProgramUnit.get_open_program_unit_for_client(@client.id).present?
							run_month = Date.civil(params[:sanction_detail]["sanction_month(1i)"].to_i,params[:sanction_detail]["sanction_month(2i)"].to_i,params[:sanction_detail]["sanction_month(3i)"].to_i)
							msg = SanctionDetailService.save_sanction_details(@client.id,@sanction_detail,run_month)
						else
							@sanction_detail.save!
							msg = "SUCCESS"
						end
						if (msg == "SUCCESS" || msg.blank?)
							redirect_to sanction_sanction_details_path(@sanction.id), notice: "Sanction detail saved."
						else
							render :new
						end
					end#@sanction.sanction_type == 3081
				end#if (@warnings.present? && params[:skip_warnings_button].blank?)
			end #if sanction_deatils.present?
		else
		   render :new
		end #if @sanction_detail.valid?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionDetailsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving sanction detail record."
		redirect_to_back
	end

	def show
			@client = Client.find(session[:CLIENT_ID])
			@is_it_progressive_sanction = Sanction.check_for_progressive_sanction(@sanction.sanction_type)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionDetailsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid sanction detail record."
		redirect_to_back
	end

	def edit

		@client = Client.find(session[:CLIENT_ID])
		@sanction_indicator_list = CodetableItem.get_sanction_indicator_values(@sanction.sanction_type,@sanction.service_program_id)
		@regular_payment_present_for_sanction_month = SanctionDetail.is_payment_month_present_for_sanction_details(@sanction_detail.sanction_month,@sanction.id)
		@sanction_detail = SanctionDetail.find(params[:id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionDetailsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing sanction detail record."
		redirect_to_back
	end

		def update
			@warnings = nil
			warning_message = nil
			@sanction_indicator_list = CodetableItem.get_sanction_indicator_values(@sanction.sanction_type,@sanction.service_program_id)
			@sanction_detail.assign_attributes(params_values)
			 if @sanction_detail.valid?
			 	if (@sanction_detail.release_indicatior == '1')
			 		@warnings = @sanction_detail.add_sanction_after_checking_validations
			 	end
				if (@warnings.present? && params[:skip_warnings_button].blank?)
					@sanction_detail.warning_count = @warnings.count
					render :edit
				elsif (@warnings.blank? || params[:skip_warnings_button] == "Skip Warnings and save")
					begin
		          		ActiveRecord::Base.transaction do
		          			common_action_argument_object = CommonEventManagementArgumentsStruct.new
					        common_action_argument_object.client_id = session[:CLIENT_ID]
					        common_action_argument_object.model_object = @sanction_detail
					        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(session[:CLIENT_ID])
					        common_action_argument_object.changed_attributes = @sanction_detail.changed_attributes().keys
					         common_action_argument_object.run_month = @sanction_detail.sanction_month
					        common_action_argument_object.is_a_new_record = @sanction_detail.new_record?
					        common_action_argument_object.sanction_type = Sanction.find(@sanction_detail.sanction_id).sanction_type
					        @sanction_detail.save!
							msg = EventManagementService.process_event(common_action_argument_object)
							program_unit_id = ProgramUnit.get_open_program_unit_for_client(session[:CLIENT_ID])
				            program_unit_object = ProgramUnit.find(program_unit_id)
				            application_date = ClientApplication.get_application_date(program_unit_object.client_application_id)
				            if (@sanction_detail.release_indicatior == '1' && @sanction_detail.sanction_served == '0' && @sanction_detail.sanction_month < Date.today.strftime("01/%m/%Y").to_date && @sanction_detail.sanction_month > application_date && program_unit_object.service_program_id == @sanction_detail.sanction.service_program_id)
				                SanctionDetail.process_supplement_payments_for_sanction_release(session[:CLIENT_ID],@sanction_detail.sanction_month)
				                warning_message = SanctionDetail.get_sanction_release_warning_message(session[:CLIENT_ID],@sanction_detail.sanction_month)
                            end
					  	end#ActiveRecord::Base.transaction do
					  	rescue => err
					  		error_object = CommonUtil.write_to_attop_error_log_table("SanctionDetailsController","update",err,AuditModule.get_current_user.uid)
					  		msg = "Error updating sanction details - for more details refer to error ID: #{error_object.id}."
			        end#begin
			        if warning_message == "SUCCESS"
			        	flash[:notice] = "Sanction detail saved."
			        else
			        	flash[:notice] = "Sanctioned payment was never applied for this month."
			        end
					redirect_to sanction_sanction_details_path(@sanction.id)

				end#if @warnings.present? && params[:skip_warnings_button].blank?
		     else
		    		@client = Client.find(session[:CLIENT_ID])
					render :edit
			 end#@sanction_detail.valid?

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionDetailsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating sanction detail record."
		redirect_to_back
	end



	def destroy
        @sanction_detail.destroy
		redirect_to sanction_sanction_details_path(@sanction.id), alert: "Sanction Detail deleted"
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SanctionDetailsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting sanction detail record."
		redirect_to_back
	end

	private

	  def params_values
	  	params.require(:sanction_detail).permit(:sanction_month,:sanction_indicator, :release_indicatior, :sanction_served)
	  end



	  def set_sanction_id
		 @sanction = Sanction.find(params[:sanction_id])
	  end

	  def set_id
	  	@sanction_detail = SanctionDetail.find(params[:id])
	  end
end
