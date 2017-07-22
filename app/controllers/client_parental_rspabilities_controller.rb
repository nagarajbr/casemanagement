class ClientParentalRspabilitiesController < AttopAncestorController
	# Author : Manoj Patil
	# Date : 08/26/2014
	# Description: form with Two Models.

	def new
		@client = Client.find(session[:CLIENT_ID])
		@parent_rspability = ClientParentalRspability.new
		#  Parent drop down.
		@parent_dropdown_values = ClientRelationship.get_parent_collection_for_child(@client.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientParentalRspabilitiesController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when creating new parent responsibility record."
		redirect_to_back
	end

	def create
		@client = Client.find(session[:CLIENT_ID])
		#  Parent drop down.
		@parent_dropdown_values = ClientRelationship.get_parent_collection_for_child(@client.id)
		@parent_rspability = ClientParentalRspability.new(parent_params)
		if @parent_rspability.valid?
			ls_msg = ParentalResponsibilityService.create_client_parental_responsibility(@parent_rspability,session[:CLIENT_ID],params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Parental responsibility information saved."
				if session[:NAVIGATE_FROM].blank?
					redirect_to client_parental_rspability_path(@parent_rspability.id)
				else
					# Manoj 09/18/2014 - after correcting data elemnents go back to Application screening if you have come from application screening page.
					navigate_back_to_called_page()
				end
			else
				flash[:alert] = ls_msg
				render :new
			end
		else
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientParentalRspabilitiesController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving parent responsibility record."
		redirect_to_back
	end

	def edit
		# Edit responsibility record.
		@client = Client.find(session[:CLIENT_ID])
		@absent_parent_rspability =  ClientParentalRspability.find(params[:id])
		@parent_dropdown_values = ClientRelationship.get_parent_collection_for_child(@client.id)
		@notes = nil # NotesService.get_notes(6150,session[:CLIENT_ID],6490,@absent_parent_rspability.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientParentalRspabilitiesController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing parent responsibility record."
		redirect_to_back
	end

	def update
		@client = Client.find(session[:CLIENT_ID])
		@absent_parent_rspability =  ClientParentalRspability.find(params[:id])
		@parent_dropdown_values = ClientRelationship.get_parent_collection_for_child(@client.id)
		@absent_parent_rspability.client_relationship_id = parent_params[:client_relationship_id]
		@absent_parent_rspability.deprivation_code = parent_params[:deprivation_code]
		@absent_parent_rspability.good_cause = parent_params[:good_cause]
		@absent_parent_rspability.child_support_referral = parent_params[:child_support_referral]
		@absent_parent_rspability.married_at_birth = parent_params[:married_at_birth]
		@absent_parent_rspability.paternity_established = parent_params[:paternity_established]
		@absent_parent_rspability.court_order_number = parent_params[:court_order_number]
		@absent_parent_rspability.court_ordered_amount = parent_params[:court_ordered_amount]
		@absent_parent_rspability.amount_collected = parent_params[:amount_collected]
		@absent_parent_rspability.parent_status = parent_params[:parent_status]
		if @absent_parent_rspability.valid?
			ls_msg = ParentalResponsibilityService.update_client_parental_responsibility(@absent_parent_rspability,session[:CLIENT_ID],params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Parenatal Responsibility information saved"
				redirect_to client_parental_rspability_path(@absent_parent_rspability.id)
			else
				flash[:alert] = ls_msg
				render :edit
			end
		else
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientParentalRspabilitiesController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when Updating Parent Responsibility record"
		redirect_to_back
	end

	def index
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID])
			# get parent responsibility list for the focus client.
			@client_resp_list = ClientParentalRspability.get_parenatl_responsibility_list_for_client(@client.id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientParentalRspabilitiesController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def show
		# show for selected responsibility record.
		@client = Client.find(session[:CLIENT_ID])
		@absent_parent_rspability =  ClientParentalRspability.find(params[:id])
		@absent_parent_relationship = @absent_parent_rspability.client_relationship
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6490,@absent_parent_rspability.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientParentalRspabilitiesController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid parent Rresponsibility record."
		redirect_to_back
	end

private

	def parent_params
		params.require(:client_parental_rspability).permit(:client_relationship_id,:deprivation_code,:good_cause,
			                                               :child_support_referral,:married_at_birth,
			                                               :paternity_established,:court_order_number,
			                                               :court_ordered_amount,:amount_collected,:parent_status
										  				  )
	end







end

