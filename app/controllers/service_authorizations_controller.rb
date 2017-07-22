class ServiceAuthorizationsController < AttopAncestorController
# Author : Manojkumar Patil
# Date ; 12/11/2014
	def service_authorizations_index

		# List of Service Authorizations for Focus Client and Focus Program Unit.
		# if session[:CLIENT_ID].present?
			session[:PROGRAM_UNIT_ID] = params[:program_unit_id]
			# session[:ACTION_PLAN_ID] = params[:action_plan_id]
			# session[:ACTION_PLAN_ID_DETAILS_ID] = params[:action_plan_detail_id]

			if session[:PROGRAM_UNIT_ID].present?
				@focus_client_id = session[:CLIENT_ID]
				@focus_program_unit_id = session[:PROGRAM_UNIT_ID]
				# @focus_action_plan_id = session[:ACTION_PLAN_ID]
				@focus_client = Client.find(@focus_client_id)
				@focus_program_unit = ProgramUnit.find(@focus_program_unit_id)
				# @action_plan = ActionPlan.find(@focus_action_plan_id)
				# @action_plan_detail = ActionPlanDetail.find(session[:ACTION_PLAN_ID_DETAILS_ID].to_i)
				# @service_authorizations = ServiceAuthorization.get_service_authorization_list_for_client_id_and_program_unit_id(@focus_client_id,@focus_program_unit_id)
				# @service_authorizations = ServiceAuthorization.get_supportive_service_for_action_plan_id(session[:ACTION_PLAN_ID_DETAILS_ID].to_i)
				@service_authorizations = ServiceAuthorization.get_all_supportive_services_for_the_program_unit(session[:PROGRAM_UNIT_ID].to_i)
				# Rails.logger.debug("@service_authorizations = #{@service_authorizations.inspect}")
				# Rails.logger.debug("activity_type = #{@service_authorizations.first.activity_type}")
				# fail
				# selected_activity_detail()
			end
		# end
	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","service_authorizations_index",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid program unit."
	# 	redirect_to_back
	end


	def new_service_authorization_wizard_initialize

		@focus_client_id = session[:CLIENT_ID]
		@focus_program_unit_id = session[:PROGRAM_UNIT_ID]
		@focus_client = Client.find(@focus_client_id)
		@focus_program_unit = ProgramUnit.find(@focus_program_unit_id)
		session[:SERVICE_AUTHORIZATION_ID] = session[:SERVICE_AUTHORIZATION_STEP] = session[:NAVIGATED_FROM] = nil
		redirect_to start_service_authorization_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","new_service_authorization_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end



	def start_service_authorization
		 @view_mode = false
		if session[:DISTANCE].present?
			estimated_service_cost = ServiceAuthorizationLineItem.get_estimated_service_cost_details(session[:SERVICE_AUTHORIZATION_ID])
			if estimated_service_cost.present?
				@averge_service_cost = estimated_service_cost.average(:estimated_cost).to_f
				@total_service_cost = estimated_service_cost.sum(:estimated_cost).to_f
			end
		end

		@focus_client_id = session[:CLIENT_ID]
		@focus_program_unit_id = session[:PROGRAM_UNIT_ID]
		@focus_client = Client.find(@focus_client_id)
		@focus_program_unit = ProgramUnit.find(@focus_program_unit_id)
		session[:NAVIGATED_FROM] = nil
		# creating New Application by WIZARD
		# Multi step form - wizard
		#Initialise session[:SERVICE_AUTHORIZATION_STEP]
      	if session[:SERVICE_AUTHORIZATION_STEP].blank?
      	 	session[:SERVICE_AUTHORIZATION_STEP] = nil
      	end

      	# Populate instance variables for wizard step objects
      	# step 1
      	if session[:SERVICE_AUTHORIZATION_ID].present?
      		# @edit_mode = true
      		# @display_text = "Editing "
      		@service_authorization = ServiceAuthorization.find(session[:SERVICE_AUTHORIZATION_ID].to_i)
      		# @transportation_barrier_id = @service_authorization.barrier_id

      		if @averge_service_cost.present?
      			@service_authorization.distance = session[:DISTANCE]
      			@service_authorization.average_service_cost = @averge_service_cost
      			@service_authorization.total_service_cost = @total_service_cost
      		end
      	 	#step 2
      	 	# if session[:SERVICE_AUTHORIZATION_STEP] == "service_authorizations_details_second"
      	 		# DEFAULT ADDRESS STATE TO Arkansas
      	 		@approved_providers = Provider.providers_with_approved_agreement_for_service_type_date_range(@service_authorization.service_type,@service_authorization.service_start_date,@service_authorization.service_end_date,@service_authorization.program_unit_id)
      			@service_authorization.trip_start_address_state = 5793 if @service_authorization.trip_start_address_state.blank?
      			@service_authorization.trip_end_address_state = 5793 if @service_authorization.trip_end_address_state.blank?
      	 	# end

      	 	# if session[:SERVICE_AUTHORIZATION_STEP] == "service_authorizations_schedule_third"
      	 		# Step 3
	      		@service_schedules = ServiceSchedule.get_schedules_sorted_by_id(@service_authorization.id)
      	 	# end

      	 	# if session[:SERVICE_AUTHORIZATION_STEP] == "service_authorizations_review_last"
      	 		@service_authorization_line_items = @service_authorization.service_authorization_line_items.order("id ASC")
      	 		if @service_authorization.trip_start_address_zip.present?
      	 			@approved_providers_zip = Provider.providers_with_approved_agreement_for_service_type_date_range_zip(@service_authorization.service_type,@service_authorization.service_start_date,@service_authorization.service_end_date,@service_authorization.trip_start_address_zip)
      	 		end
      	 	# end

	   	else
	   		if  session["CHECK_TS_NTS_PARAMS"].present?
				l_params_from_session = session["CHECK_TS_NTS_PARAMS"]
				# @transportation_barrier_id = l_params_from_session["barrier_id"]
				@transportation_ss_notes = l_params_from_session["notes"]
				@transportation_service_date = l_params_from_session["service_date"]
			end

      		@service_authorization = ServiceAuthorization.new
      		@service_authorization.program_unit_id = @focus_program_unit_id.to_i
      		@service_authorization.notes = @transportation_ss_notes
      		@service_authorization.service_start_date = @transportation_service_date.to_date
      		# @service_authorization.barrier_id = @transportation_barrier_id

      	end

      	#  @client_application.current_step is used in view template to show correct step page.
      	@service_authorization.current_step = session[:SERVICE_AUTHORIZATION_STEP]
      	selected_activity_detail()
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","start_service_authorization",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when initializing service authorization."
		redirect_to_back

	end


    # Application wizard - processing
	def process_service_authorization

		# Multi step form create - wizard
	    #  Rule1 - Processing takes place only when "NEXT" button is clicked.
	    #  Rule2 - When "BACK" button is clicked just navigate to previous step - NO PROCESSING needed.

	    # Instantiate client_application object
	    @focus_client_id = session[:CLIENT_ID]
	    @focus_program_unit_id = session[:PROGRAM_UNIT_ID]
	    selected_activity_detail()
	    @focus_client = Client.find(@focus_client_id)
	    @focus_program_unit = ProgramUnit.find(@focus_program_unit_id)



	    # populate instance variables
	    if session[:SERVICE_AUTHORIZATION_ID].blank?
	    	 if  session["CHECK_TS_NTS_PARAMS"].present?
				l_params_from_session = session["CHECK_TS_NTS_PARAMS"]
				# @transportation_barrier_id = l_params_from_session["barrier_id"]
				@transportation_ss_notes = l_params_from_session["notes"]
				@transportation_service_date = l_params_from_session["service_date"]
			end
	    	@service_authorization = ServiceAuthorization.new
	    	# @service_authorization.barrier_id = @transportation_barrier_id.to_i
	    	@service_authorization.notes = @transportation_ss_notes
	    	@service_authorization.service_start_date = @transportation_service_date.to_date
	    	@update_operation = false
		else
			@update_operation = true
	        @service_authorization = ServiceAuthorization.find(session[:SERVICE_AUTHORIZATION_ID].to_i)
	        # @transportation_barrier_id = @service_authorization.barrier_id
	        @approved_providers = Provider.providers_with_approved_agreement_for_service_type_date_range(@service_authorization.service_type,@service_authorization.service_start_date,@service_authorization.service_end_date,@service_authorization.program_unit_id)
	        @service_schedules = ServiceSchedule.get_schedules_sorted_by_id(@service_authorization.id)
		end

		@service_authorization.current_step = session[:SERVICE_AUTHORIZATION_STEP]
		 # manage steps
		if params[:back_button].present?
		         @service_authorization.previous_step
		elsif @service_authorization.last_step?
		       # reached final step - no changes to step - this is needed, so that we don't increment to next step
		else
			@service_authorization.next_step
		end
		session[:SERVICE_AUTHORIZATION_STEP] = @service_authorization.current_step

		# what step to process?
		if @service_authorization.get_process_object == "service_authorizations_details_first" && params[:next_button].present?
		   local_params = params_service_details_step
		    #  6160 - Incomplete
		   #  6161 - Complete
		    @service_authorization.program_unit_id = @focus_program_unit_id
		    @service_authorization.client_id = @focus_client_id
		    @service_authorization.status = 6160 # Incomplete.
		    # @service_authorization.barrier_id = local_params[:barrier_id]
		     # @service_authorization.barrier_id = @transportation_barrier_id
		    @service_authorization.notes = local_params[:notes]
		    @service_authorization.supportive_service_flag = "Y"

			# MANOJ 01/05/2015
	        # THis will be obtained from client_activity_services table. - CHANGE IT LATER WHEN THOSE SCREENS ARE BUILT.
	        # @service_authorization.activity_service_id = local_params[:activity_service_id]
	        @service_authorization.action_plan_detail_id = session[:ACTION_PLAN_ID_DETAILS_ID].to_i
	        @service_authorization.service_type = 6215 # Transportation
	        dates_changed = false
	        if @update_operation == true
	        	if  ( @service_authorization.service_start_date != local_params[:service_start_date].to_date ||  @service_authorization.service_end_date != local_params[:service_end_date].to_date)
	        		dates_changed = true
					# service date is changed - so delete the existing schedules for previous date range.
					# ServiceAuthorization.delete_service_schedules(@service_authorization.id)
				end
	        end
		    @service_authorization.service_start_date = local_params[:service_start_date]
		    @service_authorization.service_end_date = local_params[:service_end_date]
		    if @service_authorization.valid?
		    	@service_authorization.save
		    	if dates_changed
		    		ServiceAuthorization.delete_service_schedules(@service_authorization.id)
		    	end
		                   # Initialize Session Variable - start - Manoj 10/09/2014
                session[:SERVICE_AUTHORIZATION_ID] = @service_authorization.id
                 # Initialize Session Variable - End - Manoj 10/09/2014
                redirect_to start_service_authorization_path
		    else
               # go back to previous step
                @service_authorization.previous_step
		        session[:SERVICE_AUTHORIZATION_STEP] = @service_authorization.current_step
                render :start_service_authorization
		    end
		elsif @service_authorization.get_process_object == "service_authorizations_details_second" && params[:next_button].present?
			# start Address and End Address step
			l_params = params_service_details_second_step
	        if @service_authorization.update(l_params)
	        	redirect_to start_service_authorization_path
	        else
	        	@service_authorization.previous_step
		        session[:SERVICE_AUTHORIZATION_STEP] = @service_authorization.current_step
	        	render :start_service_authorization
	        end
		elsif @service_authorization.get_process_object == "service_authorizations_schedule_third" && params[:next_button].present?
		    # check if schedule added?
		    if @service_authorization.service_schedules.count >= 1
		       	if params[:arg_distance].present?
		       		session[:DISTANCE] = params[:arg_distance]
		       	end
		       	if params[:arg_distance].present?
		       		params[:arg_distance] = params[:arg_distance][0..params[:arg_distance].length-3].to_f
		       		ls_message = ServiceAuthorization.authorize_service_and_create_invoice_line_items(@service_authorization.id, params[:arg_distance])
			       	if ls_message == "SUCCESS"
			       		alert_message = "SUCCESS"
				    else
				    	session[:SERVICE_AUTHORIZATION_STEP] = @service_authorization.current_step
				    	alert_message = "Failed to compute trip cost - #{ls_message}"
				    end
		       	else
		       		session[:SERVICE_AUTHORIZATION_STEP] = @service_authorization.current_step
			        alert_message =   "Trip distance not available for cost estimation."

		       	end
		       	if alert_message != "SUCCESS"
		       		flash[:alert] = alert_message
		        end
		       	redirect_to start_service_authorization_path
		    else
		        # go back to previous step and show flash message as error message
		        @service_authorization.previous_step
		        session[:SERVICE_AUTHORIZATION_STEP] = @service_authorization.current_step
		        flash[:alert] = "Minimum one service schedule entry is needed to proceed to next step."
		        redirect_to start_service_authorization_path
		    end

		elsif @service_authorization.current_step == "service_authorizations_review_last"
		    @service_authorization.status = 6161

      	 	@approved_providers_zip = Provider.providers_with_approved_agreement_for_service_type_date_range_zip(@service_authorization.service_type,@service_authorization.service_start_date,@service_authorization.service_end_date,@service_authorization.trip_start_address_zip)

		    l_params = params_transportation_service_last_step
		    # if l_params[:provider_id].blank?
		    # 	 session[:SERVICE_AUTHORIZATION_STEP] = @service_authorization.current_step
		    #     flash[:alert] = "Provider is required"
		    #     redirect_to start_service_authorization_path
		    # else
		    	@service_authorization.provider_id = l_params[:provider_id]
		    # end
	    	if @service_authorization.save
		        flash[:notice] = "Service authorization completed successfully."
		        session[:SERVICE_AUTHORIZATION_ID] = session[:SERVICE_AUTHORIZATION_STEP] = nil
		        session["CHECK_TS_NTS_PARAMS"] = nil
		        redirect_to show_service_authorization_path( @service_authorization.id)
		    else
		        session[:SERVICE_AUTHORIZATION_STEP] = @service_authorization.current_step
	        	render :start_service_authorization
		    end
		else
            # previous button is clicked.
            redirect_to start_service_authorization_path
		end

	rescue => err
	                # take the user to New action and write error to table.
	                error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","process_service_authorization",err,current_user.uid)
	                flash[:alert] = "Error ID: #{error_object.id} - Error when creating service authorization."
	                redirect_to_back

	end



	# Edit Link on Application show page will call this action.
	def edit_service_authorization_wizard
		@focus_client_id = session[:CLIENT_ID]
		@focus_program_unit_id = session[:PROGRAM_UNIT_ID]
		session[:SERVICE_AUTHORIZATION_STEP] = session[:NAVIGATED_FROM] = nil
		session[:SERVICE_AUTHORIZATION_ID] =  params[:service_authorization_id]
		selected_activity_detail()
      	# redirect to New action which manages application wizard functionality.
      	redirect_to start_service_authorization_path
      	rescue => err
            error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","edit_service_authorization_wizard",err,current_user.uid)
            flash[:alert] = "Error ID: #{error_object.id} - Error when editing service authorization."
            redirect_to_back
	end

	#  Add service_authorization_schedule functionality start
	def new_service_authorization_schedule
		selected_activity_detail()
		@service_authorization = ServiceAuthorization.find(session[:SERVICE_AUTHORIZATION_ID].to_i)
		session[:NAVIGATED_FROM] = start_service_authorization_path
		activity_scheduled = Schedule.get_schedule_for_action_plan_detail(@service_authorization.action_plan_detail_id)
		@service_schedule = ServiceSchedule.new
		@arg_days_final = get_days_drop_down(@service_authorization.id,@service_authorization.service_start_date,@service_authorization.service_end_date,activity_scheduled)
	   	rescue => err
            error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","new_service_authorization_schedule",err,current_user.uid)
            flash[:alert] = "Error ID: #{error_object.id} - Error when new service authorization scheduled."
            redirect_to_back

	end



	def create_service_authorization_schedule
		selected_activity_detail()
		@service_authorization = ServiceAuthorization.find(session[:SERVICE_AUTHORIZATION_ID].to_i)
		activity_scheduled = Schedule.get_schedule_for_action_plan_detail(@service_authorization.action_plan_detail_id)
		@arg_days_final = get_days_drop_down(@service_authorization.id,@service_authorization.service_start_date,@service_authorization.service_end_date,activity_scheduled)
		l_params = service_schedule_params
		@service_schedule = ServiceSchedule.new
		# set values
		l_pickup_time = l_params["trip_pick_up_time(5i)"]
		@service_schedule.service_authorization_id = @service_authorization.id
		@service_schedule.trip_day = l_params["trip_day"]
		@service_schedule.trip_pick_up_time = l_pickup_time
		if l_params["return_trip_pick_up_time(5i)"].present?
			l_return_pickup_time = l_params["return_trip_pick_up_time(5i)"]
			@service_schedule.return_trip_pick_up_time = l_return_pickup_time
		end
	        if params[:save_and_add].present?
					# Handle save and add here
					if @service_schedule.save
						redirect_to new_service_authorization_schedule_path
					else
						render :new_service_authorization_schedule
					end
			end

			if params[:save_and_exit].present?
					# Handle save and add exit
					if @service_schedule.save
					   redirect_to start_service_authorization_path
					else
						render :new_service_authorization_schedule
					end
			end
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","create_service_authorization_schedule",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to creating service schedule."
		redirect_to_back
	end

	def destroy_service_schedule
		selected_activity_detail()
		service_schedule = ServiceSchedule.find(params[:id])
		service_schedule.destroy
		flash[:alert] = "Service Schedule deleted successfully."
		redirect_to start_service_authorization_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","destroy_service_schedule",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to delete service schedule."
		redirect_to_back

	end
	#  Add service_authorization_schedule functionality end


	# Select Link on Applications Index will call this action to show the details of selected Application.
	def show_service_authorization
			@view_mode = true
			@focus_client_id = session[:CLIENT_ID]
			@focus_program_unit_id = session[:PROGRAM_UNIT_ID]
			selected_activity_detail()
			@focus_client = Client.find(@focus_client_id)
			@focus_program_unit = ProgramUnit.find(@focus_program_unit_id)
			# Initialize Session Variable - start - Manoj 10/09/2014
			session[:SERVICE_AUTHORIZATION_ID] = params[:service_authorization_id].to_i
			# Initialize Session Variable - End - Manoj 10/09/2014
			@service_authorization = ServiceAuthorization.find(session[:SERVICE_AUTHORIZATION_ID].to_i)
			if @service_authorization.service_type == 6215
				# Transportation

				estimated_service_cost = ServiceAuthorizationLineItem.get_estimated_service_cost_details(@service_authorization.id)
				if estimated_service_cost.present?
					@service_authorization.distance = estimated_service_cost.first.quantity
					@service_authorization.average_service_cost = estimated_service_cost.average(:estimated_cost).to_f
					@service_authorization.total_service_cost = estimated_service_cost.sum(:estimated_cost).to_f
				end

	      	 	@service_schedules = ServiceSchedule.get_schedules_sorted_by_id(@service_authorization.id)
	      	 	@can_authorize = ServiceAuthorization.can_authorize_service(@service_authorization.id)
	      	 	@service_authorization_line_items = @service_authorization.service_authorization_line_items.order("id ASC")
	      	else
	      		redirect_to non_transportation_srvc_show_path(@service_authorization.id)
	      	end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","show_service_authorization",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid service authorization."
		redirect_to_back
	end


	def srvc_management_select_program_unit
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			# @client_program_units = ProgramUnit.get_client_program_units(@client.id)
			@client_program_units = ProgramUnit.get_open_client_program_units(@client.id)
		end
	end


	def destroy_service_authorization
		# destroy service schedule
		# destroy service authorization
		@focus_client_id = session[:CLIENT_ID]
		@focus_program_unit_id = session[:PROGRAM_UNIT_ID]
		selected_activity_detail()
		@focus_client = Client.find(@focus_client_id)
		@focus_program_unit = ProgramUnit.find(@focus_program_unit_id)
		# Initialize Session Variable - start - Manoj 10/09/2014
		session[:SERVICE_AUTHORIZATION_ID] = params[:service_authorization_id].to_i
		# Initialize Session Variable - End - Manoj 10/09/2014
		@service_authorization = ServiceAuthorization.find(session[:SERVICE_AUTHORIZATION_ID].to_i)
		@service_authorization.destroy
		# redirect_to service_authorizations_index_path(session[:ACTION_PLAN_ID].to_i,session[:ACTION_PLAN_ID_DETAILS_ID].to_i ,@focus_program_unit_id)
		redirect_to service_authorizations_index_path(@focus_program_unit_id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","destroy_service_authorization",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting service authorization."
		redirect_to_back
	end



	def authorize_service_authorization
		@focus_client_id = session[:CLIENT_ID]
		@focus_program_unit_id = session[:PROGRAM_UNIT_ID]
		selected_activity_detail()
		@service_authorization = ServiceAuthorization.find(params[:service_authorization_id].to_i)
		# ls_message = ServiceAuthorization.authorize_service_and_create_invoice_line_items(@service_authorization.id)
		@service_authorization.status = 6162 # Authorized
		if @service_authorization.save
			flash[:notice] = "Successfully authorized service plan."
			# redirect_to service_authorizations_index_path(session[:ACTION_PLAN_ID].to_i,session[:ACTION_PLAN_ID_DETAILS_ID].to_i,@focus_program_unit_id)
			redirect_to service_authorizations_index_path(@focus_program_unit_id)
		else
			flash[:alert] = "Failed to authorize service plan."
			redirect_to show_service_authorization_path(@service_authorization.id)
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","authorize_service_authorization",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when authorizing service authorization."
		redirect_to_back
	end

	def authorize_non_transport_service_authorization
		@focus_client_id = session[:CLIENT_ID]
		@focus_program_unit_id = session[:PROGRAM_UNIT_ID]
		selected_activity_detail()
		@service_authorization = ServiceAuthorization.find(params[:service_authorization_id].to_i)
		# ls_message = ServiceAuthorization.authorize_service_and_create_invoice_line_items(@service_authorization.id)
		@service_authorization.status = 6162 # Authorized
		if @service_authorization.save
			# msg = ServiceAuthorization.create_non_transport_service_line_items(@service_authorization.id)
			# if msg == "SUCCESS"
				flash[:notice] = "Successfully authorized service plan."
				# redirect_to service_authorizations_index_path(session[:ACTION_PLAN_ID].to_i,session[:ACTION_PLAN_ID_DETAILS_ID].to_i,@focus_program_unit_id)
				redirect_to service_authorizations_index_path(@focus_program_unit_id)
			# else
			# 	flash[:alert] = "Failed to Authorize Service Plan."
			# 	redirect_to non_transportation_srvc_show_path(@service_authorization.id)
			# end
		else
			flash[:alert] = "Failed to authorize service plan."
			redirect_to non_transportation_srvc_show_path(@service_authorization.id)
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","authorize_service_authorization",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when authorizing service authorization."
		redirect_to_back
	end


	def check_ts_or_nts_supportive_service
		# Check Transport supportive service or Non Transport Supportive Service
		# barriers - barriers for action_plan_detail_id
		@client = Client.find(session[:CLIENT_ID])
		# selected_activity_detail()
		@check_supportive_service_ts_nts = ServiceAuthorization.new
		@check_supportive_service_ts_nts.check_ts_nts = "Y"
		populate_drop_downs_check_ts_nts()
	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","check_ts_or_nts_supportive_service",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Error when adding supportive services."
	# 	redirect_to_back
	end


	def check_ts_or_nts_supportive_service_post
		# Post event for check_ts_or_nts_supportive_service
		@client = Client.find(session[:CLIENT_ID])
		# selected_activity_detail()
		populate_drop_downs_check_ts_nts()

		l_params =  params_check_ts_nts
		@check_supportive_service_ts_nts = ServiceAuthorization.new(l_params)
		# Rails.logger.debug("@check_supportive_service_ts_nts.action_plan_detail_id = #{@check_supportive_service_ts_nts.action_plan_detail_id}")
		# fail
		@check_supportive_service_ts_nts.check_ts_nts = "Y"
		# @check_supportive_service_ts_nts.action_plan_detail_id = session["ACTION_PLAN_ID_DETAILS_ID"]
		@check_supportive_service_ts_nts.errors[:action_plan_detail_id] << " is required" if @check_supportive_service_ts_nts.action_plan_detail_id.blank?
		if @check_supportive_service_ts_nts.valid?
			action_plan_detail = ActionPlanDetail.find_by_id(@check_supportive_service_ts_nts.action_plan_detail_id)
			session["CHECK_TS_NTS_PARAMS"] = l_params
			session[:ACTION_PLAN_ID] = action_plan_detail.action_plan_id
			session[:ACTION_PLAN_ID_DETAILS_ID] = action_plan_detail.id
			# Rails.logger.debug("session[:ACTION_PLAN_ID] = #{session[:ACTION_PLAN_ID]}")
			# Rails.logger.debug("session[:ACTION_PLAN_ID_DETAILS_ID] = #{session[:ACTION_PLAN_ID_DETAILS_ID]}")
			# fail
			# if l_params[:service_type] == "6215" && l_params[:barrier_id] == "27"
			if l_params[:service_type] == "6215" #&& l_params[:barrier_id] == "27"
				# Transportation Barrier and Transportation Supportive Service
				redirect_to new_service_authorization_wizard_initialize_path
			else
				# Non Transportation Service
				redirect_to non_transportation_srvc_new_path
			end
		else
			# @check_supportive_service_ts_nts.errors[:action_plan_detail_id] = " is required" if params[:service_authorization][:action_plan_detail_id].blank?
			render :check_ts_or_nts_supportive_service
		end

	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","check_ts_or_nts_supportive_service_post",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Error when adding supportive services."
	# 	redirect_to_back
	end


	def check_ts_or_nts_ss_show
		l_service_authorization_id = params[:service_authorization_id]
		service_authorization_object = ServiceAuthorization.find(l_service_authorization_id)
		if service_authorization_object.service_type == 6215
			# Transportation Service
			redirect_to show_service_authorization_path(l_service_authorization_id)
		else
			# Non Transportation Service
			redirect_to non_transportation_srvc_show_path(l_service_authorization_id)
		end
		# get actin plan detail_id
		action_plan_detail_object = ActionPlanDetail.find(service_authorization_object.action_plan_detail_id)
		# set session
		session[:ACTION_PLAN_ID_DETAILS_ID] = action_plan_detail_object.id
		# get action plan
		session[:ACTION_PLAN_ID] = action_plan_detail_object.action_plan_id
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","check_ts_or_nts_ss_show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when showing supportive services."
		redirect_to_back
	end


	def non_transportation_srvc_new
		@client = Client.find_by_id(session[:CLIENT_ID])
		@non_transport_authorization = ServiceAuthorization.new
		l_params_from_session = session["CHECK_TS_NTS_PARAMS"]
		# @barrier_id = l_params_from_session["barrier_id"]
		@supportive_service_type = l_params_from_session["service_type"]
		@non_transport_authorization.notes =  l_params_from_session["notes"]
		@service_date =l_params_from_session["service_date"].to_date
		@non_transport_service_provider = Provider.providers_with_approved_agreement_for_start_date_and_service_type(l_params_from_session["service_date"].to_date ,@supportive_service_type)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","non_transportation_srvc_new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when new supportive services added."
		redirect_to_back

	end

	def non_transportation_srvc_create
		@non_transport_authorization = ServiceAuthorization.new

		@non_transport_authorization.client_id = session["CLIENT_ID"]
		@non_transport_authorization.program_unit_id = session["PROGRAM_UNIT_ID"]
		@non_transport_authorization.action_plan_detail_id = session["ACTION_PLAN_ID_DETAILS_ID"]

		l_params = non_transportation_params
		l_params_from_session = session["CHECK_TS_NTS_PARAMS"]
		# @barrier_id = l_params_from_session["barrier_id"]
		@supportive_service_type = l_params_from_session["service_type"]
		@service_date =l_params_from_session["service_date"].to_date

		@non_transport_service_provider = Provider.providers_with_approved_agreement_for_start_date_and_service_type(@service_date,@supportive_service_type)

		# @non_transport_authorization.barrier_id = @barrier_id

		@non_transport_authorization.service_type = @supportive_service_type
		@non_transport_authorization.service_date = @service_date

		@non_transport_authorization.notes = l_params["notes"]
		@non_transport_authorization.provider_id = l_params["provider_id"]


		@non_transport_authorization.status = 6161
		@non_transport_authorization.supportive_service_flag = "Y"
		@non_transport_authorization.non_transport_service = "Y"

		if @non_transport_authorization.save
			session["CHECK_TS_NTS_PARAMS"] = nil
			# redirect_to service_authorizations_index_path(session[:ACTION_PLAN_ID].to_i,session[:ACTION_PLAN_ID_DETAILS_ID].to_i,session[:PROGRAM_UNIT_ID])
			redirect_to service_authorizations_index_path(session[:PROGRAM_UNIT_ID])
		else
			@client = Client.find_by_id(session[:CLIENT_ID])
			render :non_transportation_srvc_new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","non_transportation_srvc_create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving supportive services."
		redirect_to_back
	end

	def non_transportation_srvc_show
		@non_transport_authorization = ServiceAuthorization.find(params[:service_authorization_id])
		@client = Client.find(session[:CLIENT_ID])
		selected_activity_detail()
	 rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","non_transportation_srvc_show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when showing supportive services."
		redirect_to_back

	end

	def non_transportation_srvc_edit
		@client = Client.find(session[:CLIENT_ID])
		selected_activity_detail()
		@non_transportation_barrier_collection = ServiceAuthorization.get_non_transport_supportive_service_barriers(session[:ACTION_PLAN_ID_DETAILS_ID].to_i)
		@non_transportation_supportive_service_collection = ServiceAuthorization.get_non_transport_supportive_services()
		@non_transport_service_provider = Provider.get_non_transport_provider_with_open_agreement()
		@non_transport_authorization = ServiceAuthorization.find(params[:service_authorization_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","non_transportation_srvc_edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing supportive services."
		redirect_to_back
	end

	def non_transportation_srvc_update

		@non_transport_authorization = ServiceAuthorization.find(params[:service_authorization_id])
		@non_transport_authorization.non_transport_service = "Y"
		@client = Client.find(session[:CLIENT_ID])
		selected_activity_detail()
		@non_transportation_barrier_collection = ServiceAuthorization.get_non_transport_supportive_service_barriers(session[:ACTION_PLAN_ID_DETAILS_ID].to_i)
		@non_transportation_supportive_service_collection = ServiceAuthorization.get_non_transport_supportive_services()
		@non_transport_service_provider = Provider.get_non_transport_provider_with_open_agreement()

		l_params = non_transportation_params_edit

		if @non_transport_authorization.update(l_params)

			flash[:notice] = "Supportive Service saved"
			 redirect_to service_authorizations_index_path(session[:PROGRAM_UNIT_ID].to_i)
		else

		 render :non_transportation_srvc_edit
		end
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","non_transportation_srvc_update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating supportive services."
		redirect_to_back
	end

	def non_transportation_srvc_delete
		selected_activity_detail()
		@non_transport_authorization = ServiceAuthorization.find(params[:service_authorization_id])
		@non_transport_authorization.destroy
		flash[:notice] = "Supportive Service Deleted."
		redirect_to service_authorizations_index_path(session[:PROGRAM_UNIT_ID].to_i)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","non_transportation_srvc_delete",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting supportive services."
		redirect_to_back
	end

	def service_approval_index
		l_program_unit_id = params[:program_unit_id]
		@service_approval_pending_collection = ServiceAuthorization.services_pending_approval(l_program_unit_id)
		@selected_program_unit = ProgramUnit.find(l_program_unit_id)
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","service_approval_index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when listing service approval."
		redirect_to_back
	end

	def service_approval_show
		@client = Client.find(session[:CLIENT_ID].to_i)

		# render TS_show
		# render NTS_show
		# render NSS_show
		l_service_authorization_id = params[:service_authorization_id]
		@service_authorization_object = ServiceAuthorization.find(l_service_authorization_id)

		if @service_authorization_object.supportive_service_flag == 'N'
			# render
			@action_plan_detail = ActionPlanDetail.find(@service_authorization_object.action_plan_detail_id)
			@action_plan = ActionPlan.find(@action_plan_detail.action_plan_id)

			@schedule = Schedule.get_schedule_for_action_plan_detail(@action_plan_detail.id)
  			selected_days = @schedule.day_of_week
  			@action_plan_detail.days_of_week = selected_days
			render 'service_approval_show_non_supportive_service'
		else
			if @service_authorization_object.service_type == 6215 # Transportation

				# render
				@focus_client_id = session[:CLIENT_ID]
				@focus_client = Client.find(session[:CLIENT_ID])
				@focus_program_unit_id = session[:PROGRAM_UNIT_ID]
				@focus_program_unit = ProgramUnit.find(@focus_program_unit_id)

				@service_authorization = @service_authorization_object
				@action_plan_detail = ActionPlanDetail.find(@service_authorization_object.action_plan_detail_id)

				@activity_detail_object =ServiceAuthorization.get_activity_detail(@service_authorization.action_plan_detail_id)

				@action_plan = ActionPlan.find(@action_plan_detail.action_plan_id)
				# @transportation_barrier_collection = ServiceAuthorization.get_transportation_barriers(@service_authorization.action_plan_detail_id)
				estimated_service_cost = ServiceAuthorizationLineItem.get_estimated_service_cost_details(@service_authorization.id)
				if estimated_service_cost.present?
					@service_authorization.distance = estimated_service_cost.first.quantity
					@service_authorization.average_service_cost = estimated_service_cost.average(:estimated_cost).to_f
					@service_authorization.total_service_cost = estimated_service_cost.sum(:estimated_cost).to_f
				end

				@service_schedules = ServiceSchedule.get_schedules_sorted_by_id(@service_authorization.id)
				@can_authorize = ServiceAuthorization.can_authorize_service(@service_authorization.id)
				@service_authorization_line_items = @service_authorization.service_authorization_line_items.order("id ASC")

				render 'service_approval_show_supportive_service_transportation'
			else
				# render
				@non_transport_authorization = ServiceAuthorization.find(params[:service_authorization_id])
				@client = Client.find(session[:CLIENT_ID])
				@action_plan_detail = ActionPlanDetail.find(@non_transport_authorization.action_plan_detail_id)

				@action_plan = ActionPlan.find(@action_plan_detail.action_plan_id)

				@activity_detail_object =ServiceAuthorization.get_activity_detail(@non_transport_authorization.action_plan_detail_id)

				render 'service_approval_show_supportive_service_non_transportation'
			end
		end
		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","service_approval_show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when showing service approval."
		redirect_to_back

	end

	def service_approval_approve
		# set the status to authorized.
		@service_authorization_object = ServiceAuthorization.find(params[:service_authorization_id].to_i)
		# ls_message = ServiceAuthorization.authorize_service_and_create_invoice_line_items(@service_authorization.id)
		@service_authorization_object.status = 6162 # Authorized
		if @service_authorization_object.save
			# if @service_authorization_object.supportive_service_flag == 'N'
			# 	# render
			# 	@action_plan_detail = ActionPlanDetail.find(@service_authorization_object.action_plan_detail_id)
			# 	@action_plan = ActionPlan.find(@action_plan_detail.action_plan_id)
			# 	schedule = Schedule.get_schedule_for_action_plan_detail(@action_plan_detail.id)
	  # 			selected_days = schedule.day_of_week
	  # 			@action_plan_detail.days_of_week = selected_days
			# 	# render 'service_approval_show_non_supportive_service'
			# else
			# 	if @service_authorization_object.service_type == 6215 # Transportation
			# 		# render
			# 	else
			# 		# render
			# 	end
			# end
			flash[:notice] = "Successfully authorized service plan."
			redirect_to service_approval_show_path(@service_authorization_object.id)
		else
			flash[:alert] = "Failed to authorize service plan."
			redirect_to service_approval_show_path(@service_authorization_object.id)
		end
		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","service_approval_approve",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when  approving the service."
		redirect_to_back

	end

	private

   		def populate_drop_downs_check_ts_nts()
			@supportive_services_barriers = ServiceAuthorization.get_supportive_service_barriers(session[:ACTION_PLAN_ID_DETAILS_ID].to_i)
			@supportive_service_types = CodetableItem.item_list(168,"Supportive Services")
			@open_activities = ActionPlanDetail.get_all_open_activities_for_program_unit(session[:PROGRAM_UNIT_ID])
			# Rails.logger.debug("@open_activities = #{@open_activities.inspect}")
			# fail
		end

		def params_check_ts_nts
			params.require(:service_authorization).permit(:action_plan_detail_id,:service_type,:service_date,:notes)
		end

		def non_transportation_params
			params.require(:service_authorization).permit(:provider_id,:service_date,:notes)
		end

		def non_transportation_params_edit
			params.require(:service_authorization).permit(:provider_id,:service_date,:service_type,:notes)
		end

		def params_service_details_step
			params.require(:service_authorization).permit(:service_start_date,:service_end_date,:notes)
		end

		def params_service_details_second_step
			params.require(:service_authorization).permit(:trip_start_address_line1,:trip_start_address_line2,:trip_start_address_city,
				                                          :trip_start_address_state,:trip_start_address_zip,:trip_end_address_line1,
				                                          :trip_end_address_line2,:trip_end_address_city,:trip_end_address_state,
				                                          :trip_end_address_zip)
		end

		def service_schedule_params
			params.require(:service_schedule).permit(:trip_day,:trip_pick_up_time,:return_trip_pick_up_time)
		end

		def params_transportation_service_last_step
			params.require(:service_authorization).permit(:provider_id)
		end



		def get_days_drop_down(arg_srvc_auth_id,arg_srvc_start_date,arg_srvc_end_date,activity_scheduled)
			days_array = Array.new
			ldt_service_start_date = arg_srvc_start_date
			ldt_service_end_date = arg_srvc_end_date
			if (ldt_service_end_date - ldt_service_start_date) >= 7
				# 7 days service so all days can ve shown
				days_dropdown =  CodetableItem.item_list_order_by_id(153,"Week days")
			else
				ldt_service_date = ldt_service_start_date
				while ldt_service_date <=  ldt_service_end_date
					 ls_day_name = ldt_service_date.strftime("%^A")
					  	case ls_day_name
					        when "SUNDAY"
					          l_trip_day = 6142
					        when "MONDAY"
					           l_trip_day = 6143
					        when "TUESDAY"
					           l_trip_day = 6144
					        when "WEDNESDAY"
					           l_trip_day = 6145
					        when "THURSDAY"
					           l_trip_day = 6146
					        when "FRIDAY"
					           l_trip_day = 6147
					        when "SATURDAY"
					           l_trip_day = 6148
				        end
				        days_array << l_trip_day
					 ldt_service_date = ldt_service_date + 1
				end
				days_dropdown =  CodetableItem.items_to_include_order_by_id(153,days_array,"few days of week")

			end
			#keerthana - filter the activity schedule days from total number of days
			#begin
			if activity_scheduled.present?
            	days_scheduled_for_activity = activity_scheduled.day_of_week
            	scheduled_activity_days =  CodetableItem.items_to_include_order_by_id(153,days_scheduled_for_activity,"few days of week")
            end
            # intersection of days_dropdown and days_dropdown_from_scheduled_activity
            days_dropdown_for_service_schedule = days_dropdown & scheduled_activity_days
            if days_dropdown_for_service_schedule.blank?
               flash[:notice] = "No activity schedule found."
            end
			#end
			# If day is already picked it should be removed from Arrays.
			arg_days_final = Array.new
			schedule_days_collection = ServiceSchedule.get_distinct_schedule_days(arg_srvc_auth_id)
			if schedule_days_collection.present?
				trip_day_array = Array.new
				schedule_days_collection.each do |arg_trip_day|
					trip_day_array << arg_trip_day.trip_day
				end
				supportive_service_schedules = CodetableItem.items_to_include(153,trip_day_array,"days in the database")
				# Final collection  = Total days - days in the database
				arg_days_final = days_dropdown_for_service_schedule - supportive_service_schedules
			else
				arg_days_final = days_dropdown_for_service_schedule
			end
			return arg_days_final
		end

	def selected_activity_detail()
		@action_plan = ActionPlan.find(session[:ACTION_PLAN_ID].to_i)
		@activity_detail_object =ServiceAuthorization.get_activity_detail(session[:ACTION_PLAN_ID_DETAILS_ID].to_i)
		@transportation_barrier_collection = ServiceAuthorization.get_transportation_barriers(session[:ACTION_PLAN_ID_DETAILS_ID].to_i)
	end


end
