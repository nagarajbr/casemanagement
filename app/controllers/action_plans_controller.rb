class ActionPlansController < AttopAncestorController
	# Author : Kiran chamarthi
	# Date : 01/15/2015
	# Description: CRUD operation for Model - action_plans
	# Modified by Manoj 03/12/2015

	before_action :set_client_id, except: [:select_program_unit_id,:set_program_unit_id]
	before_action :set_id, only: [:show,:edit,:update,:destroy]
	before_action :set_partial_instance_variables, only: [:index,:barriers_index,:new,:create,:show,:edit,:update]

	def index
		# session[:BRP] = nil
		#2976 Employment Plan
		@action_plan_type = 2976
		# SHOW all Employment action Plans
		# @action_plans = ActionPlan.get_action_plans(session[:CLIENT_ID], session[:PROGRAM_UNIT_ID],2976)
		@action_plan = ActionPlan.get_open_action_plan(session[:PROGRAM_UNIT_ID], session[:CLIENT_ID])
		@total_hours = (@action_plan.core_hours.present? ? @action_plan.core_hours : 0)  + (@action_plan.non_core_hours.present? ? @action_plan.non_core_hours : 0) if @action_plan.present?
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])

		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6743,nil)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?

		if @action_plan.present?
			instances = ActionPlanService.get_instances_for_active_plan_summary(session[:PROGRAM_UNIT_ID], @action_plan)
			@employment_goal = instances[:employment_goal]
			@work_participation = instances[:work_participation]
		end

		@program_unit_participation_status = ProgramUnitParticipation.get_program_unit_participation_status(@selected_program_unit.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Client"
		redirect_to_back
	end

	# def barriers_index
	# 	session[:BRP] = true #2977 Barrier Reduction plan
	# 	@action_plan_type = 2977
	# 	# Show All Barrier REduction Plans
	# 	@action_plans = ActionPlan.get_action_plans(session[:CLIENT_ID], session[:PROGRAM_UNIT_ID],2977)
	# 	@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])

	# 	@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6745,nil)
	# 	l_records_per_page = SystemParam.get_pagination_records_per_page
	# 	@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?

	# 	render :index
	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","index",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Client"
	# 	redirect_to_back
	# end


	def new
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		if @selected_program_unit.service_program_id == 3
			# TEA DIVERSION
			flash[:alert] = "Employment Plan/ Barrier Reduction Planning is not needed for TEA Diversion Service Program."
			redirect_to action_plans_path
		else
			# TEA & WORK PAYS
			@employment_readiness_id = EmploymentReadinessPlan.get_employment_readiness_id(session[:CLIENT_ID])


			if session[:BRP].present?
				@arg_plan_type = 2977
			else
				@arg_plan_type = 2976
			end

			if ActionPlan.is_there_an_open_action_plan_for_the_program_unit(session[:PROGRAM_UNIT_ID],@arg_plan_type,@client.id)
				# In the view @action_plan presence is checked to show - Open Plan exists.
			else
				@action_plan = ActionPlan.new
				participation_hours = ActionPlanService.get_expected_work_participation_hours(@selected_program_unit, nil, nil)
				@action_plan.required_participation_hours = participation_hours[:total_hours] if participation_hours.present?
				@action_plan.core_hours = participation_hours[:min_core_hours] if participation_hours.present?
				@action_plan.non_core_hours = participation_hours[:non_core_hours] if participation_hours.present?
				# if @selected_program_unit.case_type == 6049 #minor parent
				# 	 @action_plan.short_term_goal = "6767"	 #"High School Diploma/GED"
				# end
			end

		end
		populate_employment_goal_dropdown

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to ceate new action plan"
		redirect_to_back
	end

	def create
		# fail
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		@employment_readiness_id = EmploymentReadinessPlan.get_employment_readiness_id(session[:CLIENT_ID])
		if session[:BRP].present?
			@arg_plan_type = 2977
		else
			@arg_plan_type = 2976
		end

		@action_plan = ActionPlan.new(action_plan_params_values)
		@action_plan.action_plan_type = @arg_plan_type
		@action_plan.client_id = session[:CLIENT_ID]
		@action_plan.program_unit_id = session[:PROGRAM_UNIT_ID]
		@action_plan.action_plan_type = @arg_plan_type
		@action_plan.action_plan_status = 6043 # Open
		@action_plan.employment_readiness_plan_id = @employment_readiness_id
		program_unit = ProgramUnit.find_by_id(session[:PROGRAM_UNIT_ID])
		participation_hours = ActionPlanService.get_expected_work_participation_hours(program_unit)
		@action_plan.required_participation_hours = participation_hours[:total_hours] if participation_hours.present?
		@action_plan.core_hours = participation_hours[:min_core_hours] if participation_hours.present?
		@action_plan.non_core_hours = participation_hours[:non_core_hours] if participation_hours.present?
		if @action_plan.save
			if session[:BRP].present?
				redirect_to barrier_action_plans_path, notice: "#{CodetableItem.get_short_description(@action_plan.action_plan_type)} information saved "
			else
				redirect_to action_plans_path, notice: "#{CodetableItem.get_short_description(@action_plan.action_plan_type)} information saved "
			end
		else
			populate_employment_goal_dropdown
			render :new
		end

		# rescue => err
		# 	error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","create",err,current_user.uid)
		# 	flash[:alert] = "Error ID: #{error_object.id} - Error when saving ActionPlan details"
		# 	if session[:BRP] == true
		# 		redirect_to barrier_action_plans_path
		# 	else
		# 		redirect_to action_plans_path
		# 	end
	end

	def outcome_new
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		@action_plan = ActionPlan.find(params[:id])
		@outcome = Outcome.new

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","outcome_new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to ceate new outcome plan"
		redirect_to_back
	end

	def outcome_create
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		@action_plan = ActionPlan.find(params[:id])
		@action_plan.end_date = Date.today
		@action_plan.action_plan_status = 6044 # Close
		l_params = outcome_params_values
		action_plan_details = @action_plan.action_plan_details
		@action_plan.outcome_code = l_params[:outcome_code]
		if @action_plan.valid?
			@action_plan.save
			@outcome = Outcome.new
			@outcome.outcome_code = l_params[:outcome_code]
			@outcome.notes = l_params[:outcome_notes]
			@outcome.reference_id = @action_plan.id
			if  @action_plan.action_plan_type == 2976
				@outcome.outcome_entity = 6254
				# Employment plan
			else
				@outcome.outcome_entity = 6251
				# Barrier Reduction Plan
			end
			if @outcome.save
				if session[:BRP].present?
					redirect_to barrier_action_plans_path, notice: "#{CodetableItem.get_short_description(@action_plan.action_plan_type)} Closed successfully "
				else
					redirect_to action_plans_path, notice: "#{CodetableItem.get_short_description(@action_plan.action_plan_type)} Closed successfully "
				end
			else
				@action_plan.end_date = nil
				@action_plan.action_plan_status = 6043
				@action_plan.save
				render :outcome_new
			end
		else
			render :outcome_new
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","outcome_create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to ceate new outcome plan"
		redirect_to_back
	end



	def show
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		# if outcome present then show outcome data.
		outcome_collection = Outcome.get_outcome_data(params[:id])
		if outcome_collection.present?
			outcome_object = outcome_collection.first
			@action_plan.outcome_code = outcome_object.outcome_code
			@action_plan.outcome_notes = outcome_object.notes
		end
		if (@action_plan.short_term_goal.present? && (arg_action_plan.short_term_goal).to_i != 6767 )
		   onet_ws = OnetWebService.new("arwins","9436zfu")
		   @employment_goal = onet_ws.get_code_description(@action_plan.short_term_goal,"careers","career")
		else
			@employment_goal = CodetableItem.get_long_description((@action_plan.short_term_goal).to_i)

		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid ActionPlan record"
		redirect_to action_plans_path
	end

	def edit
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		# onet_ws = OnetWebService.new("arwins","9436zfu")
		# assessment_career = AssessmentCareer.get_latest_assessment_career(@client.id)
		# response = onet_ws.get_code_description_hash(assessment_career.career_code)
		# @action_plan_short_term_goals = onet_ws.format_single_response(response, 'careers', 'career')
		populate_employment_goal_dropdown
		# @action_plan_long_term_goals = []

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to edit outcome plan"
		redirect_to_back
	end

	def update
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		if @action_plan.update(action_plan_params_values)
			if session[:BRP] == true
				redirect_to barrier_action_plans_path
			else
				redirect_to action_plans_path
			end
		else
			populate_employment_goal_dropdown
			render :edit
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when Updating ActionPlan record"
		redirect_to_back
	end

	def destroy
		@action_plan.destroy
		if session[:BRP].present?
			redirect_to barrier_action_plans_path, alert: "#{CodetableItem.get_short_description(@action_plan.action_plan_type)} information deleted"
		else
			redirect_to action_plans_path, alert: "#{CodetableItem.get_short_description(@action_plan.action_plan_type)} information deleted"
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to delete outcome plan"
		redirect_to_back
	end



	def select_program_unit_id
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			# @client_program_units = ProgramUnit.get_client_program_units(@client.id)
			# show client's program units if it is present in the selected for planning.
			@client_program_units = ProgramUnit.get_client_program_units_selected_for_planning(@client.id)
		else
			redirect_to client_search_path
		end
	end

	def set_program_unit_id
		session["PROGRAM_UNIT_ID"] = params[:program_unit_id]
		set_household_member_info_in_session(session[:CLIENT_ID])
		redirect_to action_plans_path
	end

	def create_comments_for_employment_plan
		case params[:action_plan_type].to_i
		when 2976 #employment plan
			notes_type = 6743
			redirect_path = action_plans_path
		when 2977 #barrier reduction plan
			notes_type = 6745
			redirect_path = barrier_action_plans_path
		end

		if params[:notes].present?
			NotesService.save_notes(6150,session[:CLIENT_ID],notes_type,nil,params[:notes])
			redirect_to redirect_path
		else
			flash[:alert] = "Comments are Required"
			redirect_to redirect_path
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","create_comments_for_employment_plan",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when adding comments to employment plan"
		redirect_to_back
	end





	private

		def action_plan_params_values
		  	params.require(:action_plan).permit(:required_participation_hours,:start_date,:notes,:short_term_goal)
		end

		def outcome_params_values
		  	params.require(:action_plan).permit(:outcome_code,:outcome_notes)
		end


		def set_client_id
			@client = Client.find(session[:CLIENT_ID])
		end

		def set_id
			@action_plan = ActionPlan.find(params[:id])
		end

		def set_partial_instance_variables
			@client = Client.find(session[:CLIENT_ID])
			@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
			@service_program_id = @selected_program_unit.service_program_id
			@case_type_id =  @selected_program_unit.case_type
			@expected_work_participation_hours_collection = ExpectedWorkParticipationHour.where("service_program_id = ? and case_type = ?",@service_program_id,@case_type_id)
			@wp_characters_collection =ClientCharacteristic.work_participation_characters_for_elible_program_unit(@selected_program_unit.id)
			@planned_client_activity_hours_collection = CareerPathwayPlan.planned_work_participation_hours_for_program_unit(@selected_program_unit.id)
		end

		def populate_employment_goal_dropdown
			onet_ws = OnetWebService.new("arwins","9436zfu")
			assessment_career = AssessmentCareer.get_latest_assessment_career(@client.id)
			if assessment_career.present?
				response = onet_ws.get_code_description_hash(assessment_career.career_code)
				# Rails.logger.debug("-->response = #{response.inspect}")
				# fail
				# @action_plan_short_term_goals = []
				# @action_plan_long_term_goals = []
				@action_plan_short_term_goals = onet_ws.format_single_response(response, 'careers', 'career')
			else
				@action_plan_short_term_goals = []
			end
		end
end
