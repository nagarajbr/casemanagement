class ActionPlanDetailsController < AttopAncestorController

	# Author : Kiran chamarthi
	# Date : 19/1/2015
	# Description: CRUD operation for Model - action_plan_details

	before_action :set_id, only: [:supportive_services, :show, :show_supportive_service,:edit,:update,:destroy, :edit_supportive_service_action_plan_detail, :edit_action_plan_detail_wizard, :show_client_activity, :close_action_plan_detail, :create_apd_outcome, :extend_action_plan_detail, :create_apd_extension, :update_activity]
	before_action :set_action_plan_id, except: [:client_activities, :show_client_activity, :assessment_activity, :create_assessment_activity]
	before_action :set_client_id
	before_action :set_custom_dropdown_values, only: [:edit,:edit_service_action_plan_detail,:edit_supportive_service_action_plan_detail]
	before_action :get_client_assessments, only: [:start_action_plan_detail_wizard]
	before_action :set_partial_instance_variables, only: [:index,:start_action_plan_detail_wizard,:show,:process_action_plan_detail_wizard]

	def index
		l_records_per_page = SystemParam.get_pagination_records_per_page
		# @action_plan_details = @action_plan.action_plan_details.where("entity_type != 6294").page(params[:page]).per(l_records_per_page)
		@scheduled_activities = ActionPlanDetail.get_all_open_activities_for_program_unit(session[:PROGRAM_UNIT_ID])
		@completed_activities = ActionPlanDetail.get_all_completed_activities_for_program_unit(session[:PROGRAM_UNIT_ID])
		@scheduled_activities = @scheduled_activities.page(params[:page]).per(l_records_per_page) if @scheduled_activities.present?
		@completed_activities = @completed_activities.page(params[:page]).per(l_records_per_page) if @completed_activities.present?

		instances = ActionPlanService.get_instances_for_active_plan_summary(session[:PROGRAM_UNIT_ID], @action_plan)
		@employment_goal = instances[:employment_goal]
		@work_participation = instances[:work_participation]
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid action plan master record."
		redirect_to_back
	end


	def new
		session[:APD_PARAMS] = {}
		session[:ENTITY_TYPE] = 6252
		redirect_to action_plan_detail_wizard_initialize_path(@action_plan)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to create new action plan detail."
		redirect_to_back
	end

	# def new_service
	# 	session[:APD_PARAMS] = {}
	# 	session[:ENTITY_TYPE] = 6253
	# 	redirect_to action_plan_detail_wizard_initialize_path(@action_plan)
	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","new_service",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Failed to create new service plan."
	# 	redirect_to_back
	# end

	def create

		@action_plan_detail = @action_plan.action_plan_details.new(params_values)
		if @action_plan_detail.entity_type = 6294 #supportive service
			@action_plan_detail.hours_per_day = 0
		end
		if @action_plan_detail.save
			create_outcome_if_required()
			redirect_to action_plan_action_plan_details_path(@action_plan), notice: "#{CodetableItem.get_short_description(@action_plan_detail.entity_type)} Created!"
		else
			set_custom_dropdown_values()
			set_barriers_drop_down()
			if @action_plan_detail.entity_type = 6294 #supportive service
				@parent_action_plan_detail = ActionPlanDetail.find(@action_plan_detail.reference_id)
			end
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving action plan details."
		redirect_to_back
	end

	def show
		@action_plan_detail.frequency_id = '2320'
		if ServiceAuthorization.can_service_be_approved?(params[:id]) == true
			@service_can_be_approved = true
		else
			@service_can_be_approved = false
		end
		outcome_collection = Outcome.get_outcome_object(@action_plan_detail.id,@action_plan_detail.entity_type)
		if outcome_collection.present?
			@outcome = outcome_collection.first
		end
		@schedule = Schedule.get_schedule_info_from_action_plan_detail_id(@action_plan_detail.id)
		@action_plan_detail.days_of_week = @schedule.day_of_week
		@schedule_extension_for_activity = ScheduleExtension.get_schedule_extension_from_schedule_id(@schedule.id)

		instances = ActionPlanService.get_instances_for_active_plan_summary(session[:PROGRAM_UNIT_ID], @action_plan)
		@employment_goal = instances[:employment_goal]
		@work_participation = instances[:work_participation]
		@can_edit = ActionPlanDetail.is_the_action_plan_detail_associated_with_client(session[:CLIENT_ID],@action_plan_detail.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Attempted to access invalid action plan detail record."
		redirect_to_back
	end

	def edit
		session[:ACTION_PLAN_DETAIL_STEP] =  nil
		session[:ACTION_PLAN_DETAIL_ID] =  params[:id]
		set_barriers_drop_down()
      	redirect_to start_action_plan_detail_wizard_path(@action_plan)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit action plan detail record."
		redirect_to_back
	end

	def edit_activity
		@action_plan = ActionPlan.find_by_id(params[:action_plan_id].to_i)
		@action_plan_detail = ActionPlanDetail.find_by_id(params[:id].to_i)
		instances_for_edit_activity
		@cancel_url = action_plan_action_plan_detail_path(@action_plan,@action_plan_detail)
		@view_page = "edit_activity"
		render :assessment_activity
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","edit_activity",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit action plan detail record."
		redirect_to_back
	end

	def update_activity
		# Rails.logger.debug("@action_plan_detail.activity_type = #{@action_plan_detail.activity_type}")
		@action_plan_detail.assign_attributes(params_values)
		# Rails.logger.debug("after @action_plan_detail.activity_type = #{@action_plan_detail.activity_type}")
		# Rails.logger.debug("@action_plan_detail.component_type = #{@action_plan_detail.component_type}")
		# fail
		component_type = params[:activity_type] == "core" ? 173 : 174
		if @action_plan_detail.activity_type.present?
      		@action_plan_detail.barrier_id =  SystemParam.get_barrier_id_for_given_activity_type(@action_plan_detail.activity_type.to_s, session[:CLIENT_ID])
      		@action_plan_detail.component_type =  SystemParam.get_component_type_for_given_activity_type(@action_plan_detail.activity_type.to_s, component_type)
      	end
		create_or_update_schedule()
		if @action_plan_detail.valid?
			case @action_plan_detail.component_type
			when 6238 # "Job Search and Job Readiness"
				@warnings = @action_plan_detail.perform_validations_for_component_type_job_serach_and_job_readiness
			when 6239,6241,6242,6243
				# 6239 On the Job Training
				# 6241 Work Experience
				# 6242 Subsidized Private Employment
				# 6243 Subsidized Public Employment
				@warnings = @action_plan_detail.perform_validations_for_component_type
			when 6240 # "Career and Technical Education"
				@warnings = @action_plan_detail.perform_validations_for_career_and_technical_education
			end
			if @warnings.present? && params[:save_button].present?
				@action_plan_detail.warning_count = @warnings.count
				instances_for_edit_activity
		 		render :assessment_activity
			else
				@action_plan_detail.save
				create_or_update_schedule()
				redirect_to action_plan_action_plan_detail_path(@action_plan,@action_plan_detail), notice: "Activity updated."
			end
		else
			instances_for_edit_activity
	 		render :assessment_activity
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","update_activity",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to update action plan detail record."
		redirect_to_back
	end

	# def edit_service_action_plan_detail
	# 	rescue => err
	# 		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","edit_service_action_plan_detail",err,current_user.uid)
	# 		flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit service action detail record."
	# 		redirect_to_back
	# end

	def update
		if @action_plan_detail.update(params_values)
			create_outcome_if_required()
			redirect_to action_plan_action_plan_detail_path(@action_plan, @action_plan_detail), notice: "#{CodetableItem.get_short_description(@action_plan_detail.entity_type)} Updated!"
		else
			set_custom_dropdown_values()
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating action plan details."
		redirect_to_back
	end

	def destroy
		@action_plan_detail.destroy
		redirect_to action_plan_action_plan_details_path(@action_plan), alert: "#{CodetableItem.get_short_description(@action_plan_detail.entity_type)} successfully deleted!"
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to delete action detail record."
		redirect_to_back
	end

	# def reopen
	# 	@action_plan_detail.activity_status = 6043
	# 	@action_plan_detail.end_date = ""
	# 	if @action_plan_detail.save
	# 		redirect_to action_plan_action_plan_detail_url(@action_plan,@action_plan_detail.id), notice: "#{CodetableItem.get_short_description(@action_plan_detail.entity_type)} reopened"
	# 	else
	# 		redirect_to action_plan_action_plan_detail_url(@action_plan,@action_plan_detail.id), notice: "#{CodetableItem.get_short_description(@action_plan_detail.entity_type)} cannot be reopened"
	# 	end
	# 	rescue => err
	# 		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","reopen",err,current_user.uid)
	# 		flash[:alert] = "Error ID: #{error_object.id} - Failed to reopen action detail record."
	# 		redirect_to_back
	# end


	# Wizard start - Kiran 02/03/2015

	def action_plan_detail_wizard_initialize
		session[:ACTION_PLAN_DETAIL_STEP] = session[:ACTION_PLAN_DETAIL_ID] = nil
	  	redirect_to start_action_plan_detail_wizard_path(@action_plan)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","action_plan_detail_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to start wizard."
		redirect_to_back
  	end

  # Edit Link on Application show page will call this action.
	def edit_action_plan_detail_wizard
		session[:ACTION_PLAN_DETAIL_STEP] =  nil
		session[:ACTION_PLAN_DETAIL_ID] =  params[:id]
		session[:APD_PARAMS] = nil
		session[:APD_PARAMS] = {}
		build_session_hash_for_action_plan_detail
      	redirect_to start_action_plan_detail_wizard_path(@action_plan)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","edit_action_plan_detail_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to edit action plan detail."
		redirect_to_back
	end



	# def start_action_plan_detail_wizard
	# 	if session[:ACTION_PLAN_DETAIL_STEP].blank?
	#   	 	session[:ACTION_PLAN_DETAIL_STEP] = nil
	#   	end

	# 	if session[:ACTION_PLAN_DETAIL_ID].present?
	# 	  	@action_plan_detail = ActionPlanDetail.find(session[:ACTION_PLAN_DETAIL_ID].to_i)
	# 	  	@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 	else
	# 		@action_plan_detail = @action_plan.action_plan_details.new
	# 		@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 		@action_plan_detail.activity_status = 6043 # default activity status to open
	# 		@action_plan_detail.entity_type = session[:ENTITY_TYPE]
	# 		@action_plan_detail.frequency_id = 2320 # default frequency to weekly to avoid flickering, revisit required
	# 		#session[:ENTITY_TYPE] = nil
	# 	end
	# 	set_custom_dropdown_values()
	# 	@action_plan_detail.assign_attributes(session[:APD_PARAMS])

	# 	@action_plan_detail.current_step = session[:ACTION_PLAN_DETAIL_STEP]
	# 	if @action_plan_detail.current_step == "action_plan_detail_first"
	# 		populate_grouped_options_instance()
	# 		#logger.debug("@grouped_options = #{@grouped_options.inspect}")
	# 	elsif @action_plan_detail.current_step == "action_plan_detail_second"
	# 		populate_selected_days()
	# 	end
	# 	set_barriers_drop_down()

	# 	 rescue => err
	# 		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","start_action_plan_detail_wizard",err,current_user.uid)
	# 		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
	# 		redirect_to_back
	# end

	def start_action_plan_detail_wizard
		if session[:ACTION_PLAN_DETAIL_STEP].blank?
	  	 	session[:ACTION_PLAN_DETAIL_STEP] = nil
	  	end

		if session[:ACTION_PLAN_DETAIL_ID].present?
		  	@action_plan_detail = ActionPlanDetail.find(session[:ACTION_PLAN_DETAIL_ID].to_i)
		  	@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
		else
			@action_plan_detail = @action_plan.action_plan_details.new
			@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
			@action_plan_detail.activity_status = 6043 # default activity status to open
			@action_plan_detail.entity_type = session[:ENTITY_TYPE]
			@action_plan_detail.frequency_id = 2320 # default frequency to weekly to avoid flickering, revisit required
			#session[:ENTITY_TYPE] = nil
		end
		set_custom_dropdown_values()
		# @action_plan_detail.assign_attributes(session[:APD_PARAMS])
		@action_plan_detail.current_step = session[:ACTION_PLAN_DETAIL_STEP]
		if @action_plan_detail.current_step == "action_plan_detail_first"
			# fail
			populate_grouped_options_instance()

			@activity_types = CodetableItem.get_activity_types_associated_with_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
			#logger.debug("@grouped_options = #{@grouped_options.inspect}")
		elsif @action_plan_detail.current_step == "action_plan_detail_second"
			@activity_types = CodetableItem.get_activity_types_associated_with_non_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
		end
		populate_selected_days()
		set_barriers_drop_down()
		# Rails.logger.debug("@barriers = #{@barriers.inspect}")
		# fail
		@multi_add_buttons = true
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","start_action_plan_detail_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

  # 	def process_action_plan_detail_wizard
  # 		# fail
  # 		# logger.debug("before session[:APD_PARAMS] = #{session[:APD_PARAMS].inspect}")
  # 		# session[:APD_PARAMS].deep_merge!(params_values)
  # 		# logger.debug("****session[:APD_PARAMS] = #{session[:APD_PARAMS].inspect}")
  # 		# fail
  # 		# populate instance variables
		# if session[:ACTION_PLAN_DETAIL_ID].blank?
  #     	 	@action_plan_detail = @action_plan.action_plan_details.new
  #     	 	@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
  #     	 	@action_plan_detail.entity_type = session[:ENTITY_TYPE]
  #     	 	#set_custom_dropdown_values()
  #     	 	#session[:ENTITY_TYPE] = nil
  #     	else
  #     	 	@action_plan_detail = ActionPlanDetail.find(session[:ACTION_PLAN_DETAIL_ID].to_i)
  #     	 	@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
  #     	end
  #     	#logger.debug("@action_plan_detail.current_step = #{@action_plan_detail.current_step}")

  #     	# @action_plan_detail.assign_attributes(session[:APD_PARAMS])

  #     	@action_plan_detail.assign_attributes(params_values)
  #     	if @action_plan_detail.activity_type.present?
  #     		@action_plan_detail.barrier_id =  SystemParam.get_barrier_id_for_given_activity_type(@action_plan_detail.activity_type, session[:CLIENT_ID])
  #     		@action_plan_detail.activity_type =  SystemParam.get_component_type_for_given_activity_type(@action_plan_detail.activity_type)
  #     	end
  #     	@action_plan_detail.current_step = session[:ACTION_PLAN_DETAIL_STEP]

  #     	 # manage steps
  #     	if params[:back_button].present?
  #     		 @action_plan_detail.previous_step
  #     	elsif @action_plan_detail.last_step?
  #     		# reached final step - no changes to step - this is needed, so that we don't increment to next step
  #     	else
  #          @action_plan_detail.next_step if params[:next_button].present?
  #       end
  #      session[:ACTION_PLAN_DETAIL_STEP] = @action_plan_detail.current_step
  #      #manage steps - end

  #   #   what step to process?
  #  		set_custom_dropdown_values()
		# if @action_plan_detail.get_process_object == "action_plan_detail_first" # && params[:next_button].present?
		# 	#logger.debug("step1 steps.index(current_step) = #{@action_plan_detail.steps.index(@action_plan_detail.current_step)}")
		# 	if @action_plan_detail.valid?
		# 		@action_plan_detail.save
		# 		create_or_update_schedule()
		# 		if params[:save_and_exit].present?
		# 			redirect_to action_plan_action_plan_details_path(@action_plan), notice: "Activity Created."
		# 		else
		# 			redirect_to start_action_plan_detail_wizard_path(@action_plan), notice: "Activity Created."
		# 		end
		# 	else
		# 		# fail
		# 		@action_plan_detail.previous_step if params[:next_button].present?
		#  		session[:ACTION_PLAN_DETAIL_STEP] = @action_plan_detail.current_step
		#  		populate_grouped_options_instance()
		#  		set_barriers_drop_down()
		#  		populate_selected_days()
		#  		#logger.debug("first step error = #{@action_plan_detail.inspect}")
		#  		#logger.debug("@grouped_options = #{@grouped_options.inspect}")
		#  		# set_barriers_drop_down()

		#  		render :start_action_plan_detail_wizard
		# 	end

		# elsif @action_plan_detail.get_process_object == "action_plan_detail_second" && (params[:next_button].present? || params[:skip_warnings_button].present?)
		# 	# apd = ActionPlanDetail.new
		# 	# logger.debug("apd.warnings = #{apd.warnings.inspect}")
		# 	# fail
		# 	if @action_plan_detail.valid?
		# 		#logger.debug("session[:APD_PARAMS] = #{session[:APD_PARAMS].inspect}")
		# 		#logger.debug("current_step = #{@action_plan_detail.current_step}")
		# 		if @action_plan_detail.component_type == 6238 # "Job Search and Job Readiness"
		# 			@warnings = @action_plan_detail.perform_validations_for_component_type_job_serach_and_job_readiness
		# 		elsif @action_plan_detail.component_type == 6239 || @action_plan_detail.component_type == 6241 || @action_plan_detail.component_type == 6242 || @action_plan_detail.component_type == 6243
		# 			# 6239 On the Job Training
		# 			# 6241 Work Experience
		# 			# 6242 Subsidized Private Employment
		# 			# 6243 Subsidized Public Employment
		# 			@warnings = @action_plan_detail.perform_validations_for_component_type
		# 		elsif @action_plan_detail.component_type == 6240 # "Career and Technical Education"
		# 			@warnings = @action_plan_detail.perform_validations_for_career_and_technical_education
		# 		end
		# 		if @warnings.present? && params[:next_button].present?
		# 			@action_plan_detail.warning_count = @warnings.count
		# 			@action_plan_detail.previous_step
		# 	 		session[:ACTION_PLAN_DETAIL_STEP] = @action_plan_detail.current_step
		# 	 		#logger.debug("@days_of_week = #{@action_plan_detail.days_of_week.inspect}")
		# 	 		populate_selected_days()
		# 	 		set_barriers_drop_down()
		# 	 		render :start_action_plan_detail_wizard
		# 		else
		# 			redirect_to start_action_plan_detail_wizard_path(@action_plan)
		# 		end
		# 	else
		# 		@action_plan_detail.previous_step
		#  		session[:ACTION_PLAN_DETAIL_STEP] = @action_plan_detail.current_step
		#  		#logger.debug("@days_of_week = #{@action_plan_detail.days_of_week.inspect}")
		#  		populate_selected_days()
		#  		set_barriers_drop_down()
		#  		render :start_action_plan_detail_wizard
		# 	end
		# 	#logger.debug("session[:APD_PARAMS] = #{session[:APD_PARAMS].inspect}")
		# 	#logger.debug("current_step = #{@action_plan_detail.current_step}")
	 #  		#fail

		#  	#session[:ACTION_PLAN_DETAIL_STEP] = @action_plan_detail.current_step
		#  	#redirect_to start_action_plan_detail_wizard_path(@action_plan)

		# elsif @action_plan_detail.current_step == "action_plan_detail_last"
		# 	#logger.debug("@action_plan_detail.get_process_object = #{@action_plan_detail.get_process_object.inspect}")
  #       	#fail
		# 	#logger.debug("123 @action_plan_detail. = #{@action_plan_detail.inspect}")
		# 	unless @action_plan_detail.valid?
		# 		#logger.debug("123 @action_plan_detail. = #{@action_plan_detail.errors.full_messages.inspect}")
		# 	end
		# 	#fail
		# 	if @action_plan_detail.save
		# 		# create_outcome_if_required()
		# 		create_or_update_schedule()
		# 		#fail
		# 		#logger.debug("session[:APD_PARAMS] = #{session[:APD_PARAMS].inspect}")
		# 		#logger.debug("current_step = #{@action_plan_detail.current_step}")
		# 		redirect_to action_plan_action_plan_details_path(@action_plan), notice: "#{CodetableItem.get_short_description(@action_plan_detail.entity_type)} saved."
		# 	else
		# 		#@action_plan_detail.previous_step
		#  		#session[:ACTION_PLAN_DETAIL_STEP] = @action_plan_detail.current_step
		#  		#logger.debug("@days_of_week = #{@action_plan_detail.days_of_week.inspect}")
		#  		set_barriers_drop_down()
		#  		render :start_action_plan_detail_wizard
		# 	end
		# else
		# 	#logger.debug("***session[:APD_PARAMS] = #{session[:APD_PARAMS].inspect}")
		# 	#logger.debug("***@days_of_week = #{@action_plan_detail.days_of_week.inspect}")
		# 	# Back button is pressed
		# 	#logger.debug("-->Kiran @action_plan_detail = #{@action_plan_detail.inspect}")
		# 	#fail
		# 	redirect_to start_action_plan_detail_wizard_path(@action_plan)
		# end

		# # rescue => err
		# # 	error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","process_action_plan_detail_wizard",err,current_user.uid)
		# # 	flash[:alert] = "Error ID: #{error_object.id} - Error occured when processing action plan detail."
		# # 	redirect_to_back

  # 	end

  	def process_action_plan_detail_wizard
  		# fail
  		if session[:ACTION_PLAN_DETAIL_ID].blank?
      	 	@action_plan_detail = @action_plan.action_plan_details.new
      	 	@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
      	 	@action_plan_detail.entity_type = session[:ENTITY_TYPE]
      	else
      	 	@action_plan_detail = ActionPlanDetail.find(session[:ACTION_PLAN_DETAIL_ID].to_i)
      	 	@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
      	end

      	@action_plan_detail.assign_attributes(params_values)
      	component_type = 173 # "Defaulting it to core" this code is no longer in use
      	if @action_plan_detail.activity_type.present?
      		@action_plan_detail.barrier_id =  SystemParam.get_barrier_id_for_given_activity_type(@action_plan_detail.activity_type.to_s, session[:CLIENT_ID])
      		@action_plan_detail.component_type =  SystemParam.get_component_type_for_given_activity_type(@action_plan_detail.activity_type.to_s, component_type)
      	end
      	@action_plan_detail.current_step = session[:ACTION_PLAN_DETAIL_STEP]

      	 # manage steps
      	if params[:back_button].present?
      		 @action_plan_detail.previous_step
      	elsif params[:next_button].present?
           @action_plan_detail.next_step #if params[:next_button].present?
        end
       session[:ACTION_PLAN_DETAIL_STEP] = @action_plan_detail.current_step
       #manage steps - end

    #   what step to process?
   		set_custom_dropdown_values()
   		# logger.debug("#{@action_plan_detail.get_process_object}")
   		# fail
		if params[:next_button].present? || params[:back_button].present?
			redirect_to start_action_plan_detail_wizard_path(@action_plan)
		elsif @action_plan_detail.get_process_object == "action_plan_detail_first" || @action_plan_detail.get_process_object == "action_plan_detail_second"
			# fail
			#logger.debug("step1 steps.index(current_step) = #{@action_plan_detail.steps.index(@action_plan_detail.current_step)}")
			if @action_plan_detail.valid?
				if @action_plan_detail.component_type == 6238 # "Job Search and Job Readiness"
					@warnings = @action_plan_detail.perform_validations_for_component_type_job_serach_and_job_readiness
				elsif @action_plan_detail.component_type == 6239 || @action_plan_detail.component_type == 6241 || @action_plan_detail.component_type == 6242 || @action_plan_detail.component_type == 6243
					# 6239 On the Job Training
					# 6241 Work Experience
					# 6242 Subsidized Private Employment
					# 6243 Subsidized Public Employment
					@warnings = @action_plan_detail.perform_validations_for_component_type
				elsif @action_plan_detail.component_type == 6240 # "Career and Technical Education"
					@warnings = @action_plan_detail.perform_validations_for_career_and_technical_education
				end
				if @warnings.present? && params[:next_button].present?
					@action_plan_detail.warning_count = @warnings.count
					@action_plan_detail.previous_step
			 		session[:ACTION_PLAN_DETAIL_STEP] = @action_plan_detail.current_step
			 		# logger.debug("@days_of_week = #{@action_plan_detail.days_of_week.inspect}")
			 		populate_selected_days()
			 		set_barriers_drop_down()
			 		render :start_action_plan_detail_wizard
				else
					@action_plan_detail.save
					create_or_update_schedule()
					if params[:save_and_exit].present?
						redirect_to action_plan_action_plan_details_path(@action_plan), notice: "Activity Created."
					else
						# Rails.logger.debug("@action_plan_detail.current_step = #{@action_plan_detail.current_step}")
						# fail
						# unless @action_plan_detail.last_step?
						# 	@action_plan_detail.previous_step
						# 	session[:ACTION_PLAN_DETAIL_STEP] = @action_plan_detail.current_step
						# end
						redirect_to start_action_plan_detail_wizard_path(@action_plan), notice: "Activity Created."
					end
				end
			else
				@action_plan_detail.previous_step
		 		session[:ACTION_PLAN_DETAIL_STEP] = @action_plan_detail.current_step
		 		if @action_plan_detail.current_step == "action_plan_detail_first"
					# populate_grouped_options_instance()
					@activity_types = CodetableItem.get_activity_types_associated_with_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
				elsif @action_plan_detail.current_step == "action_plan_detail_second"
					@activity_types = CodetableItem.get_activity_types_associated_with_non_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
				end
		 		set_barriers_drop_down()
		 		populate_selected_days()
		 		render :start_action_plan_detail_wizard
			end
		else
			redirect_to start_action_plan_detail_wizard_path(@action_plan)
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","process_action_plan_detail_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when processing action plan detail."
		redirect_to_back
  	end

  	def new_activity
  		@action_plan_detail = @action_plan.action_plan_details.new
		@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
		@action_plan_detail.activity_status = 6043 # default activity status to open
		@action_plan_detail.entity_type = 6252
		@action_plan_detail.frequency_id = 2320
		set_custom_dropdown_values()

		if params[:activity_type] == "core"
			@activity_types = CodetableItem.get_activity_types_associated_with_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
		elsif params[:activity_type] == "non_core"
			@activity_types = CodetableItem.get_activity_types_associated_with_non_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
		end
		populate_grouped_options_instance()
		populate_selected_days()
		set_barriers_drop_down()
		@activity_type = params[:activity_type]
		if @action_plan.present?
			instances = ActionPlanService.get_instances_for_active_plan_summary(session[:PROGRAM_UNIT_ID], @action_plan)
			@employment_goal = instances[:employment_goal]
			@work_participation = instances[:work_participation]
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","add_activity",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when processing action plan detail."
		redirect_to_back
  	end

  	def create_activity
  		# fail

      	@action_plan_detail = @action_plan.action_plan_details.new
      	@action_plan_detail.assign_attributes(params_values)
      	@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID].to_i
      	@action_plan_detail.entity_type = 6253 if [6284, 6285, 6286, 6287, 6289, 6290, 6291, 6292, 6293, 6321, 6322, 6323, 6324, 6326, 6327, 6359, 6360, 6361, 6362, 6722].include?(@action_plan_detail.activity_type.to_i) # "Service"
      	if @action_plan_detail.activity_type.present?
      		@action_plan_detail.barrier_id =  SystemParam.get_barrier_id_for_given_activity_type(@action_plan_detail.activity_type.to_s, session[:CLIENT_ID])
      		component_type = params[:activity_type] == "core" ? 173 : 174
      		@action_plan_detail.component_type =  SystemParam.get_component_type_for_given_activity_type(@action_plan_detail.activity_type.to_s, component_type)
      	end


   		set_custom_dropdown_values()

		if @action_plan_detail.valid?
			if @action_plan_detail.component_type == 6238 # "Job Search and Job Readiness"
				@warnings = @action_plan_detail.perform_validations_for_component_type_job_serach_and_job_readiness
			elsif @action_plan_detail.component_type == 6239 || @action_plan_detail.component_type == 6241 || @action_plan_detail.component_type == 6242 || @action_plan_detail.component_type == 6243
				# 6239 On the Job Training
				# 6241 Work Experience
				# 6242 Subsidized Private Employment
				# 6243 Subsidized Public Employment
				@warnings = @action_plan_detail.perform_validations_for_component_type
			elsif @action_plan_detail.component_type == 6240 # "Career and Technical Education"
				@warnings = @action_plan_detail.perform_validations_for_career_and_technical_education
			end
			if @warnings.present? && params[:skip_warnings_button].blank?
				@action_plan_detail.warning_count = @warnings.count

				set_custom_dropdown_values()

				if params[:activity_type] == "core"
					@activity_types = CodetableItem.get_activity_types_associated_with_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
				elsif params[:activity_type] == "non_core"
					@activity_types = CodetableItem.get_activity_types_associated_with_non_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
				end
				populate_grouped_options_instance()
				populate_selected_days()
				set_barriers_drop_down()
				@activity_type = params[:activity_type]
				if @action_plan.present?
					instances = ActionPlanService.get_instances_for_active_plan_summary(session[:PROGRAM_UNIT_ID], @action_plan)
					@employment_goal = instances[:employment_goal]
					@work_participation = instances[:work_participation]
				end
				render :new_activity
			else
				@action_plan_detail.save
				create_or_update_schedule()
				if params[:save_and_exit].present?
					redirect_to action_plan_action_plan_details_path(@action_plan), notice: "Activity Created."
				else
					redirect_to new_activity_path(@action_plan,params[:activity_type]), notice: "Activity Created."
				end
			end
		else

	 		if params[:activity_type] == "core"
				@activity_types = CodetableItem.get_activity_types_associated_with_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
			elsif params[:activity_type] == "non_core"
				@activity_types = CodetableItem.get_activity_types_associated_with_non_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
			end
			populate_grouped_options_instance()
	 		set_barriers_drop_down()
	 		populate_selected_days()
	 		@activity_type = params[:activity_type]
			@activity_type = params[:activity_type]
			if @action_plan.present?
				instances = ActionPlanService.get_instances_for_active_plan_summary(session[:PROGRAM_UNIT_ID], @action_plan)
				@employment_goal = instances[:employment_goal]
				@work_participation = instances[:work_participation]
			end
	 		render :new_activity
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","create_activity",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when creating action plan detail."
		redirect_to_back
  	end

  	def client_activities
  		l_records_per_page = SystemParam.get_pagination_records_per_page
  		@action_plan_details = ActionPlanDetail.get_all_activities_for_the_client(session[:CLIENT_ID]).page(params[:page]).per(l_records_per_page)
  		@action_plan_details.each do |action|
  			@activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail(action.id)
  			if @activity_hours.present?
  				@activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail(action.id).first
  			else
  			end
  		  end
	rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","client_activities",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Failed to create client activity."
	 	redirect_to_back
  	end

  	def show_client_activity
  		@action_plan = ActionPlan.find(@action_plan_detail.action_plan_id)
  		@schedule = Schedule.get_schedule_info_from_action_plan_detail_id(@action_plan_detail.id)
   		outcome_collection = Outcome.get_outcome_object(@action_plan_detail.id,@action_plan_detail.entity_type)
		if outcome_collection.present?
			@outcome = outcome_collection.first
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","show_client_activity",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -Error when showing client activity."
		redirect_to_back
  	end


  	def authorize_service
  		@focus_client_id = session[:CLIENT_ID]
		@focus_program_unit_id = session[:PROGRAM_UNIT_ID]
		action_plan_id = params[:action_plan_id]
		action_plan_detail_id = params[:action_plan_detail_id]

		msg = ServiceAuthorization.authorize_non_supportive_service_plan(action_plan_detail_id)
		if msg == "SUCCESS"
			flash[:notice] = "Successfully authorized service plan."
			redirect_to action_plan_details_path(session[:ACTION_PLAN_ID].to_i)
		else
			flash[:alert] = "Failed to authorize service plan."
			redirect_to action_plan_action_plan_detail_path(action_plan_id,action_plan_detail_id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ServiceAuthorizationsController","authorize_service",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when authorizing service authorization."
		redirect_to_back
  	end

  	def close_action_plan_detail
  		@outcome = Outcome.new
  	end

  def create_apd_outcome
  	# fail
  		@action_plan_detail.activity_status = 6044
  		schedule = Schedule.get_schedule_info_from_action_plan_detail_id(@action_plan_detail.id)
  		if (@action_plan_detail.start_date + schedule.duration.weeks) > Date.today
  			@action_plan_detail.end_date = Date.today
  		else
  			@action_plan_detail.end_date = @action_plan_detail.start_date + schedule.duration.weeks
  		end
  		@outcome = Outcome.new
		@outcome.outcome_entity = @action_plan_detail.entity_type
		@outcome.reference_id =  @action_plan_detail.id
		@outcome.outcome_code = params[:outcome][:outcome_code]
		@outcome.notes = params[:outcome][:notes]
		@action_plan_detail.outcome_code = params[:outcome][:outcome_code]
  		if (@outcome.valid? && @action_plan_detail.valid?)
			# step1 : Populate common event management argument structure
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
		        common_action_argument_object.event_id = 738 # "CLOSE ACTIVITY"
		        common_action_argument_object.action_plan_detail_id = @action_plan_detail.id
		        begin
      				ActiveRecord::Base.transaction do
      					@action_plan_detail.save!
      					@outcome.save!
				        # step2: call common method to process event.
				        ls_msg = EventManagementService.process_event(common_action_argument_object)
				        if ls_msg == "SUCCESS"
				        	lb_saved = true
						else
							lb_saved = false
						end
				  	end
			  	rescue => err
			  		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","create_apd_outcome",err,current_user.uid)
			  		lb_saved = false
			  		ls_msg = "Failed to close activity - for more details refer to Error ID: #{error_object.id}."
		        end
			redirect_to action_plan_action_plan_detail_path(@action_plan,@action_plan_detail), notice: "#{CodetableItem.get_short_description(@action_plan_detail.entity_type)} closed"
  		else
  			if @action_plan_detail.errors.full_messages.present?
  				@outcome.errors[:base] << @action_plan_detail.errors.full_messages.last
  			end
  			render :close_action_plan_detail
  		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","create_apd_outcome",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -Error while closing #{CodetableItem.get_short_description(@action_plan_detail.entity_type)}."
		redirect_to_back
  	end

  	def extend_action_plan_detail
  		@schedule_extension = ScheduleExtension.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","extend_action_plan_detail",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -Error while extending #{CodetableItem.get_short_description(@action_plan_detail.entity_type)}."
		redirect_to_back
  	end

  	def create_apd_extension
  		@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID]
  		schedule = Schedule.get_schedule_info_from_action_plan_detail_id(@action_plan_detail.id)
  		@schedule_extension = schedule.schedule_extensions.new
  		@schedule_extension.extension_duration = params[:schedule_extension][:extension_duration]
		@schedule_extension.extension_reason = params[:schedule_extension][:extension_reason]
		@warnings = []
		if @schedule_extension.valid?
			schedule.duration = schedule.duration + @schedule_extension.extension_duration.to_i
			@action_plan_detail.duration = schedule.duration
			if @action_plan_detail.component_type == 6238 # "Job Search and Job Readiness"
					@warnings = @action_plan_detail.perform_validations_for_component_type_job_serach_and_job_readiness
			elsif @action_plan_detail.component_type == 6239 || @action_plan_detail.component_type == 6241 || @action_plan_detail.component_type == 6242 || @action_plan_detail.component_type == 6243
				# 6239 On the Job Training
				# 6241 Work Experience
				# 6242 Subsidized Private Employment
				# 6243 Subsidized Public Employment
				@warnings = @action_plan_detail.perform_validations_for_component_type
			elsif @action_plan_detail.component_type == 6240 # "Career and Technical Education"
				@warnings = @action_plan_detail.perform_validations_for_career_and_technical_education
			end
			if @warnings.blank? || params[:commit] == "Skip Warnings"
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
		        common_action_argument_object.event_id = 739 # "EXTEND ACTIVITY"
		        common_action_argument_object.action_plan_detail_id = @action_plan_detail.id
		        begin
      				ActiveRecord::Base.transaction do
      					schedule.save!
				        @schedule_extension.save!
				        # step2: call common method to process event.
				        ls_msg = EventManagementService.process_event(common_action_argument_object)
				        Rails.logger.debug("ls_msg = #{ls_msg.inspect}")

				        if ls_msg == "SUCCESS"
				        	lb_saved = true
						else
							lb_saved = false
						end
				  	end
			  	rescue => err
			  		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","create_apd_extension",err,current_user.uid)
			  		lb_saved = false
			  		ls_msg = "Failed to extend activity - for more details refer to Error ID: #{error_object.id}."
		        end

				redirect_to action_plan_action_plan_detail_path(@action_plan,@action_plan_detail), notice: "#{CodetableItem.get_short_description(@action_plan_detail.entity_type)} extended"
			else
				@action_plan_detail.warning_count = @warnings.count
				render :extend_action_plan_detail
			end
  		else
  			render :extend_action_plan_detail
  		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","create_apd_extension",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -Error while extending #{CodetableItem.get_short_description(@action_plan_detail.entity_type)}."
		redirect_to_back
  	end

  	def assessment_activity
  		if assessment_plan_not_required
  			redirect_to selected_sections_for_short_assessment_path(session[:CLIENT_ID]), notice: "Assessment Plan already created."
  		else
  			@multi_add_buttons = false
	  		action_plan_object_for_assessment_activity
	  		@action_plan_detail = ActionPlanDetail.new

			if session[:CLIENT_ID].present? && Client.is_child(session[:CLIENT_ID])
		  		@action_plan_detail.barrier_id = 7 # "No high school Diploma"
		  		@action_plan_detail.activity_type = 6317 # "Participate in High School GED program"
		  		@action_plan_detail.component_type = 6247 # "Attandenc at secondary school(Core)"
		  	else
		  		# @action_plan_detail.barrier_id = 3 # "Currently working and needs assistance"
		  		# @action_plan_detail.activity_type = 6315 # "Participate in job search - self"
		  		# @action_plan_detail.component_type = 6238 # "Job Search and Job Readiness (Core)"

		  		@action_plan_detail.barrier_id = SystemParam.get_barrier_id_for_given_activity_type("6770", session[:CLIENT_ID])
		  		@action_plan_detail.activity_type = 6770 # "Job Readiness"
		  		@action_plan_detail.component_type = 6771 # "Job Readiness (Core)"
		  	end

	  		@action_plan_detail.entity_type = 6252 # "Action"
	  		@activity_types = CodetableItem.get_activity_types_associated_with_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
	  		populate_selected_days()
	  		@path = create_assessment_activity_path
  		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","assessment_activity",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -Error occured while getting assessment activity."
		redirect_to_back
  	end

  	def create_assessment_activity
  		# Rails.logger.debug("session[:NAVIGATE_FROM] = #{session[:NAVIGATE_FROM]}")
  		# fail
  		action_plan_object_for_assessment_activity
  		@action_plan.employment_readiness_plan_id = 1
  		if params[:skip_button].present?
  			@action_plan.save!
  			flash[:notice] = "Assessment Activity skipped."
			if session[:NAVIGATE_FROM].present?
				navigate_back_to_called_page()
			else
				redirect_to selected_sections_for_short_assessment_path(session[:CLIENT_ID])
			end
  		else
  			@action_plan_detail = ActionPlanDetail.new
	  		@action_plan_detail.assign_attributes(params_values)
	  		@action_plan_detail.client_id = session[:CLIENT_ID]
	  		@action_plan_detail.activity_status = 6043 # "Open"
	  		# Rails.logger.debug("@action_plan = #{@action_plan.inspect}")
	  		# Rails.logger.debug("@action_plan_detail = #{@action_plan_detail.inspect}")
	  		@action_plan_detail.program_unit_id = session[:PROGRAM_UNIT_ID].present? ? session[:PROGRAM_UNIT_ID] : 0
			@action_plan_detail.validations_for_step2
			@action_plan_detail.errors[:start_date] << "must be greater than or equal to #{Date.today.strftime("%m/%d/%Y")}" if @action_plan_detail.start_date < Date.today


			if @action_plan_detail.errors.full_messages.blank?
				@warnings = @action_plan_detail.perform_validations_for_component_type_job_serach_and_job_readiness
				@action_plan_detail.warning_count = @warnings.count
				if @warnings.present? && params[:save_button].present?
					populate_selected_days()
					@multi_add_buttons = false
					@activity_types = CodetableItem.get_activity_types_associated_with_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
					@path = create_assessment_activity_path
			 		render :assessment_activity
			 	else
			 		begin
			  			ActiveRecord::Base.transaction do
			  				@action_plan.save!
			  				@action_plan_detail.action_plan_id = @action_plan.id
			  				@action_plan_detail.save!
			  				create_or_update_schedule()
			  				flash[:notice] = "Assessment Activity created."
			  				if session[:NAVIGATE_FROM].present?
			  					navigate_back_to_called_page()
			  				else
			  					redirect_to selected_sections_for_short_assessment_path(session[:CLIENT_ID])
			  				end
			  			end
			  		rescue => err
			  			error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","assessment_activity",err,current_user.uid)
			  			flash[:alert] = "Error ID: #{error_object.id} -Error occured while creating assessment activity."
			  			redirect_to_back
			  		end
				end
		  	else
		  		populate_selected_days()
		 		set_barriers_drop_down()
		 		@path = create_assessment_activity_path
		 		render :assessment_activity
			end
  		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlanDetailsController","create_assessment_activity",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -Error occured while creating assessment activity."
		redirect_to_back
  	end


	private

	 	def params_values
  			params.require(:action_plan_detail).permit(:barrier_id, :provider_id, :activity_classfication, :entity_type, :reference_id, :frequency_id, :duration,
        		:activity_type, :component_type, :activity_status, :hours_per_day, :start_date, :end_date, :client_agreement_date, :notes, :outcome_code, :outcome_notes, days_of_week: [], warnings: [])
	    end


		def set_action_plan_id
			@action_plan = ActionPlan.find(params[:action_plan_id])
			onet_ws = OnetWebService.new("arwins","9436zfu")
			if @action_plan.short_term_goal.present?
				if (@action_plan.short_term_goal).to_i != 6767
				   onet_ws = OnetWebService.new("arwins","9436zfu")
				   @employment_goal = onet_ws.get_code_description(@action_plan.short_term_goal,"careers","career")
				else
					@employment_goal = CodetableItem.get_long_description((@action_plan.short_term_goal).to_i)
				end
			end
		end

		def set_id
	  		@action_plan_detail = ActionPlanDetail.find(params[:id])
		end

		def set_client_id
			@client = Client.find(session[:CLIENT_ID])
		end

		def set_custom_dropdown_values()
			if @action_plan_detail.new_record?
				@activity_statuses = CodetableItem.items_to_include(133,[6043],"Activity Status")
			else
				@activity_statuses = CodetableItem.items_to_include(133,[6043,6044],"Activity Status")
			end
			#logger.debug("@action_plan_detail.entity_type = #{@action_plan_detail.entity_type}")
			#fail
			case @action_plan_detail.entity_type
			when 6252 # "Action"
				# @activity_types = CodetableItem.get_activity_types_associated_with_core_components(session[:CLIENT_ID])
				if session[:BRP].present?
					brp_barrier_action_mappings = SystemParam.param_values_list(21,"BRP Action Barrier Mapped to Activity Type")
					@activity_type_grouped_options = brp_barrier_action_mappings.inject({}) do |options, mapping|
					  (options[mapping.key] ||= []) << [CodetableItem.get_short_description(mapping.value), mapping.value]
					  options
				  	end
					# @activity_types = CodetableItem.get_activity_types_for_barrier_reduction_plan_actions


				else
					# @activity_types = CodetableItem.get_activity_types_for_employment_plan_actions
					brp_barrier_action_mappings = SystemParam.param_values_list(20,"Employment Action Barrier Mapped to Activity Type")
					@activity_type_grouped_options = brp_barrier_action_mappings.inject({}) do |options, mapping|
					  (options[mapping.key] ||= []) << [CodetableItem.get_short_description(mapping.value), mapping.value]
					  options
				  	end
				end
				# @activity_types = CodetableItem.item_list(181,"Activity Type For Action")
			when 6253 # "Service"
				if session[:BRP].present?
					@activity_types = CodetableItem.get_activity_types_for_barrier_reduction_plan_services
					brp_barrier_action_mappings = SystemParam.param_values_list(23,"BRP Service Barrier Mapped to Activity Type")
					@activity_type_grouped_options = brp_barrier_action_mappings.inject({}) do |options, mapping|
					  (options[mapping.key] ||= []) << [CodetableItem.get_short_description(mapping.value), mapping.value]
					  options
				  	end
				else
					# @activity_types = CodetableItem.get_activity_types_for_employment_plan_services
					brp_barrier_action_mappings = SystemParam.param_values_list(22,"Employment Service Barrier Mapped to Activity Type")
					@activity_type_grouped_options = brp_barrier_action_mappings.inject({}) do |options, mapping|
					  (options[mapping.key] ||= []) << [CodetableItem.get_short_description(mapping.value), mapping.value]
					  options
				  	end
				end
				# @activity_types = CodetableItem.item_list(182,"Activity Type For Service")
			when 6294
				# @activity_types = CodetableItem.item_list(168,"Activity Type For Supportive Service")
			end
			#logger.debug("-->@activity_types = #{@activity_types.inspect}")
			#@selected_days = []
		end

		def create_outcome_if_required()
			if @action_plan_detail.activity_status == 6044
				outcome = Outcome.new
				outcome.outcome_entity = 6252
				outcome.reference_id =  @action_plan_detail.id
				outcome.outcome_code = params[:action_plan_detail][:outcome_code]
				outcome.notes = params[:action_plan_detail][:outcome_notes]
				outcome.save
			end
		end

		def populate_grouped_options_instance()
	  # 		@mappings = SystemParam.param_values_list(16,"action/service mappings to federal components")
			# @grouped_options = @mappings.inject({}) do |options, mapping|
			#   (options[mapping.key] ||= []) << [CodetableItem.get_short_description(mapping.value), mapping.value]
			#   options
			# end
			# logger.debug("@grouped_options = #{@grouped_options.inspect}")

			# populating provider dropdown
			# if @action_plan_detail.entity_type == 6253
				@list_of_providers = Provider.providers_with_approved_agreement_for_start_date_and_occupation(@action_plan.start_date, @action_plan.short_term_goal)
				# @list_of_providers = Provider.providers_with_approved_agreement_for_start_date(@action_plan.start_date)


				# logger.debug("@list_of_providers = #{@list_of_providers.inspect}")
				# fail

				@providers = @list_of_providers.inject({}) do |options, mapping|
				  (options[mapping.service_type] ||= []) << [mapping.provider_name, mapping.id]
				  options
				end


				# logger.debug("@providers = #{@providers.inspect}")
				# fail
			# end

			# logger.debug("@action_plan_detail.entity_type = #{@action_plan_detail.entity_type}")
			# fail
	  	end

	  	def set_barriers_drop_down()
	  		# if session[:BRP].present?
	  		# 	if @action_plan_detail.entity_type.present?
	  		# 		if @action_plan_detail.entity_type == 6252
	  		# 		# Manoj 05/26/2015.
	  		# 		# filter transportation challenge barrier - for action in Barrier reduction plan.
					# @barriers = ClientAssessment.get_client_non_employment_barriers_for_action(@client.id)
					# else
					# 	@barriers = ClientAssessment.get_client_non_employment_barriers(@client.id)
					# end
	  		# 	else
	  		# 		@barriers = ClientAssessment.get_client_non_employment_barriers(@client.id)
	  		# 	end
	  		# else
	  		# 	@barriers =  ClientAssessment.get_client_employment_barriers(@client.id)
	  		# end

	  		# @barriers =  ClientAssessment.get_client_employment_barriers(@client.id)
	  		@barriers =  ClientAssessment.get_client_barriers(@client.id)
	  		# logger.debug("@barriers = #{@barriers.inspect}")
	  		# fail
	  	end

	  	def get_client_assessments
	  		@client_assessments = ClientAssessment.where("client_id = ?",@client.id)
	  	end

	  	def populate_selected_days()

  			@selected_days = []
  			if @action_plan_detail.days_of_week.present?
  				@selected_days = @action_plan_detail.days_of_week
  				# @selected_days = @action_plan_detail.days_of_week
  			elsif @action_plan_detail.id.present?
  				schedule = Schedule.get_schedule_for_action_plan_detail(@action_plan_detail.id)
  				@action_plan_detail.duration = schedule.duration
  				@selected_days = schedule.day_of_week
  			end
        end

        def create_or_update_schedule()
        	schedule = Schedule.get_schedule_for_action_plan_detail(@action_plan_detail.id)
        	unless schedule.present?
        		schedule = Schedule.new
        	end
        	schedule.entity = @action_plan_detail.entity_type
        	schedule.reference_id = @action_plan_detail.id
        	schedule.day_of_week = @action_plan_detail.days_of_week
        	if schedule.day_of_week.include?("")
        		schedule.day_of_week.shift
        	end
        	schedule.duration = @action_plan_detail.duration
        	schedule.recurring = @action_plan_detail.frequency_id
        	# logger.debug("^^^^^^^^^schedule = #{schedule.inspect}")
        	schedule.valid?
        	# logger.debug("^^^^^^^^^schedule = #{schedule.errors.full_messages.inspect}")
        	schedule.save
        end

        def build_session_hash_for_action_plan_detail
        	#logger.debug("@action_plan_detail = #{@action_plan_detail.inspect}")
        	#fail
        	schedule = Schedule.get_schedule_for_action_plan_detail(@action_plan_detail.id)
        	action_plan_detail_hash = {}
        	action_plan_detail_hash["barrier_id"] = @action_plan_detail.barrier_id
        	action_plan_detail_hash["entity_type"] = @action_plan_detail.entity_type
        	action_plan_detail_hash["reference_id"] = @action_plan_detail.reference_id
        	action_plan_detail_hash["activity_type"] = @action_plan_detail.activity_type
        	action_plan_detail_hash["component_type"] = @action_plan_detail.component_type
        	action_plan_detail_hash["activity_status"] = @action_plan_detail.activity_status
        	action_plan_detail_hash["notes"] = @action_plan_detail.notes
        	if schedule.present?
        		action_plan_detail_hash["frequency_id"] = schedule.recurring
        		action_plan_detail_hash["duration"] = schedule.duration

        		if schedule.recurring == 2320 # weekly
        			day_of_week_collection = [""]
        			schedule.day_of_week.each do |day|
        				day_of_week_collection << day.to_s
        			end
	        		action_plan_detail_hash["days_of_week"] = day_of_week_collection

	        	end
        	end


        	action_plan_detail_hash["hours_per_day"] = @action_plan_detail.hours_per_day
        	action_plan_detail_hash["start_date"] = @action_plan_detail.start_date
        	action_plan_detail_hash["end_date"] = @action_plan_detail.end_date

        	action_plan_detail_hash["outcome_code"] = ""
        	action_plan_detail_hash["outcome_notes"] = ""


        	action_plan_detail_hash["client_agreement_date"] = @action_plan_detail.client_agreement_date
        	# logger.debug("action_plan_detail_hash = #{action_plan_detail_hash.inspect}")
        	# fail
        	session[:APD_PARAMS] = action_plan_detail_hash
        	# logger.debug("session[:APD_PARAMS] = #{session[:APD_PARAMS].inspect}")
        	# fail
        end


        def set_partial_instance_variables
			 @client = Client.find(session[:CLIENT_ID])
			 @selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
			 @service_program_id = @selected_program_unit.service_program_id
			 @case_type_id =  @selected_program_unit.case_type
			 @expected_work_participation_hours_collection = ExpectedWorkParticipationHour.where("service_program_id = ? and case_type = ?",@service_program_id,@case_type_id)
			 @planned_client_activity_hours_collection = CareerPathwayPlan.planned_work_participation_hours_for_program_unit(@selected_program_unit.id)
		end

		def action_plan_object_for_assessment_activity
			@action_plan = ActionPlan.new
	  		@action_plan.client_id = session[:CLIENT_ID]
			# @action_plan.short_term_goal = "35-3022.00"
			@action_plan.action_plan_type = 2976
			@action_plan.start_date = (params[:action_plan_detail].present? && params[:action_plan_detail][:start_date].present?) ? params[:action_plan_detail][:start_date] : Date.today
			@action_plan.action_plan_status = 6043
			@action_plan.required_participation_hours = 20
			program_unit_id = session[:PROGRAM_UNIT_ID]
			if program_unit_id.blank?
	  			client_program_units = ProgramUnit.get_open_client_program_units(session[:CLIENT_ID])
	  			program_unit_id = client_program_units.present? ? client_program_units.first.id : 0
	  		elsif program_unit_id != 0
	  			program_unit = ProgramUnit.find_by_id(program_unit_id)
	  			if program_unit.case_type == 6049 #minor parent
				   @action_plan.short_term_goal = 6767	 #"High School Diploma/GED"
				end
	  			participation_hours = ActionPlanService.get_expected_work_participation_hours(program_unit, nil, nil)
				@action_plan.required_participation_hours = participation_hours[:total_hours] if participation_hours.present?
				@action_plan.core_hours = participation_hours[:min_core_hours] if participation_hours.present?
				@action_plan.non_core_hours = participation_hours[:non_core_hours] if participation_hours.present?
	  		end
			@action_plan.program_unit_id = program_unit_id
		end

		def instances_for_edit_activity
			activity_type = nil
			populate_selected_days()
			@selected_days = @selected_days.map { |e| e.to_s  }
			barriers =  ClientAssessment.get_client_employment_barriers(@client.id)
			barriers = barriers.select("assessment_barriers.barrier_id")
			core_activities = CodetableItem.get_activity_types_associated_with_core_components(session[:CLIENT_ID],session[:PROGRAM_UNIT_ID])
			# non_core_activities = CodetableItem.get_activity_types_associated_with_non_core_components(session[:CLIENT_ID])
			# if core_activities.where("id = ?",@action_plan_detail.activity_type).count > 0
			if core_activities.present?
				@activity_types = core_activities
				activity_type = "core"
			else
				@activity_types = CodetableItem.get_activity_types_associated_with_non_core_components(session[:CLIENT_ID])
				activity_type = "non_core"
			end
			@path = update_activity_path(@action_plan,activity_type,@action_plan_detail)
		end
end