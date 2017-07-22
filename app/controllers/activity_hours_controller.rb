class ActivityHoursController < AttopAncestorController


	before_action :set_action_plan_detail_id, only: [:index, :new,:show, :add_week, :create, :activity_index, :edit_week_info, :save_week_info, :edit_week_activity, :save_week_activity]
	before_action :set_action_plan_id, only: [:index, :new, :show, :add_week, :create, :activity_index, :edit_week_info, :save_week_info, :edit_week_activity, :save_week_activity]
	before_action :set_client_id, only:[:index, :new,:show, :add_week, :create]

	# def index

	# end

	# def new
	# 	#@activity_hour = ActivityHour.new
	# 	l_records_per_page = SystemParam.get_pagination_records_per_page
	# 	@activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail_till_date(@action_plan_detail.id).page(params[:page]).per(l_records_per_page)
	# 	#@incomes = @client.incomes.page(params[:page]).per(l_records_per_page).order("effective_beg_date  desc")
	# 	#logger.debug("@activity_hours = #{@activity_hours.inspect}")
	# 	#fail
	# 	rescue => err
	# 		error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","new",err,current_user.uid)
	# 		flash[:alert] = "Error ID: #{error_object.id} - Attempted to create new activity hours."
	# 		redirect_to_back


	# end

	# def show
	# 	@activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail_till_date(@action_plan_detail.id)
	# rescue => err
	# 		error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","show",err,current_user.uid)
	# 		flash[:alert] = "Error ID: #{error_object.id} - Attempted to show activity hours."
	# 		redirect_to_back


	# end

	# def create
	# 	# @activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail_till_date(@action_plan_detail.id)
	# 	# logger.debug("@activity_hours = #{@activity_hours.class}")
	# 	# logger.debug("@activity_hours= #{@activity_hours.inspect}")
	# 	# logger.debug("params = #{params.inspect}")
	# 	change_in_activity_hours = false
	# 	activity_hour_id = nil
	# 	@activity_hours_errors = ActivityHour.new
	# 	@activity_hours = []
	# 	@warnings = []
	# 	any_errors_in_the_collection = false
	# 	# logger.debug("params[:activity_hours].keys.inspect = #{params[:activity_hours].keys.inspect}")
	# 	# future_activity_hours = ActivityHour.where("id in (?) and activity_date > ?",params[:activity_hours].keys, (Date.today+14.days))
	# 	future_activity_hours = ActivityHour.where("id in (?) and activity_date > ?",params[:activity_hours].keys, Date.today)
	# 	# logger.debug("ahs = #{ahs.where("activity_date > ?",(Date.today+14.days)).inspect}")
	# 	# logger.debug("future_activity_hours = #{future_activity_hours.inspect}")
	# 	# fail
	# 	if future_activity_hours.present? && future_dated_activity_hours_not_empty(future_activity_hours)
	# 		l_records_per_page = SystemParam.get_pagination_records_per_page
	# 		@activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail_till_date(@action_plan_detail.id).page(params[:page]).per(l_records_per_page)
	# 		# flash.now[:alert] = "Can't save future dated activities, please leave them blank"
	# 		@activity_hours_errors.errors[:base] = "Can't save future dated activities, please leave them blank."
	# 		render :new
	# 	else
	# 		params[:activity_hours].keys.each do |key|
	# 			# logger.debug("ActivityHour.find(key).inspect = #{ActivityHour.find(key).inspect}")
	# 			activity_hour = ActivityHour.find(key)
	# 			#logger.debug("params[:activity_hours][key] = #{params[:activity_hours][key].inspect}")
	# 			# is_an_update_required(params[:activity_hours][key], activity_hour)
	# 			#activity_hour.assign_attributes(params[:activity_hours][key])
	# 			if is_an_update_required(params[:activity_hours][key], activity_hour)
	# 				activity_hour = update_activity_hour_object(params[:activity_hours][key], activity_hour)

	# 				if activity_hour.save
	# 					change_in_activity_hours = true
	# 					activity_hour_id = activity_hour.id
	# 				else
	# 					# fail
	# 					#logger.debug("after save else = #{activity_hour.inspect}")
	# 					any_errors_in_the_collection = true
	# 					# logger.debug("activity_hour.errors.full_messages = #{activity_hour.errors.full_messages.inspect}")
	# 					activity_hour.errors.full_messages.each do |error|
	# 						# result = (error != "Absent hours")
	# 						# Rails.logger.debug("#{error}!= Absent hours = #{result}")
	# 						if error_not_part_of_filtered_messages(error)
	# 							@activity_hours_errors.errors[:base] = "#{error} for activity dated #{activity_hour.activity_date.strftime("%m/%d/%Y")}."
	# 						end
	# 					end
	# 				end
	# 			end
	# 			@activity_hours << activity_hour
	# 		end

	# 		if any_errors_in_the_collection
	# 			# logger.debug("@activity_hours_errors = #{@activity_hours_errors.errors.full_messages.inspect}")
	# 			l_records_per_page = SystemParam.get_pagination_records_per_page
	# 			@activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail_till_date(@action_plan_detail.id).page(params[:page]).per(l_records_per_page)
	# 			# @activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail_till_date(@action_plan_detail.id).page(params[:page]).per(l_records_per_page)
	# 			render :new,  alert: "Please correct the following errors."
	# 		else
	# 			# Manoj 04/07/2015 - start
	# 			# If the time entry is last schedule work day in last week of the month - generate payment records.
	# 			# get the latest saved activity hours record.
	# 			l_client_id = session[:CLIENT_ID].to_i
	# 			activity_hour_collection = ActivityHour.get_activity_hours_for_action_plan_detail_till_date(@action_plan_detail.id)
	# 			activity_hour_object = activity_hour_collection.first

	# 			begin
	# 	            ActiveRecord::Base.transaction do
	# 	            	if change_in_activity_hours
	# 		            	common_action_argument_object = CommonEventManagementArgumentsStruct.new
	# 				        common_action_argument_object.client_id = l_client_id
	# 				        common_action_argument_object.event_id = 833 # Activity Hours Save
	# 				        common_action_argument_object.program_unit_id = ActivityHour.get_program_unit_id(activity_hour_id)
	# 				        common_action_argument_object.is_a_new_record = false
	# 						msg = EventManagementService.process_event(common_action_argument_object)
	# 		            end
	# 		            lb_check = ActionPlan.can_create_workpays_payment?(activity_hour_object.id,l_client_id,activity_hour_object.activity_date)
	# 					if lb_check == true
	# 						ret_msg = ActionPlan.process_workpays_payment_line_item(l_client_id,activity_hour_object.activity_date)
	# 						if ret_msg == "SUCCESS"
	# 							redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail),  notice: "Activity hours information saved and workpays payment is submitted."
	# 						else
	# 							if ret_msg.include?("NOTHING_TO_PROCESS")
	# 								redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail),  notice: "Activity hours information saved."
	# 							else
	# 								redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail),  alert: "Activity hours information saved.#{ret_msg}"
	# 							end
	# 						end
	# 					else
	# 						redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail),  notice: "Activity hours information saved."
	# 					end
	# 	            end
	# 		        rescue => err
	# 		            error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","save activity hours information",err,AuditModule.get_current_user.uid)
	# 		            msg = "Failed to save activity hours - for more details refer to Error ID: #{error_object.id}."
	# 	        end

	# 			# Manoj 04/07/2015 - end

	# 			# redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail),  notice: "Activity hours information saved"
	# 		end
	# 	end

	# 	#redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail)
	# 	rescue => err
	# 		error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","create",err,current_user.uid)
	# 		flash[:alert] = "Error ID: #{error_object.id} - Attempted to create new activity hours."
	# 		redirect_to_back
	# end

	# def add_week
	# 	msg = ""
	# 	@warnings = []
	# 	if ActivityHour.is_previous_week_activity_complete(@action_plan_detail.id)

	# 		if ActivityHour.get_number_of_weeks_added(@action_plan_detail.id) < @action_plan_detail.get_duration
	# 			create_participation_hours_records_for_a_week
	# 			msg = "Week activity added."
	# 		else
	# 			msg = "Scheduled number of weeks have been added for this #{CodetableItem.get_short_description(@action_plan_detail.entity_type).downcase}. Can't add any more weeks."
	# 		end
	# 	else
	# 		msg = "Previous week activity is incomplete, cannot add another week at this time."
	# 	end
	# 	if @warnings.present?
	# 		l_records_per_page = SystemParam.get_pagination_records_per_page
	# 		@activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail_till_date(@action_plan_detail.id).page(params[:page]).per(l_records_per_page)
	# 		render :new, notice: "#{msg}"
	# 	else
	# 		redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail), notice: "#{msg}"
	# 	end
	# 	rescue => err
	# 		error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","add_week",err,current_user.uid)
	# 		flash[:alert] = "Error ID: #{error_object.id} - Attempted to Add a week."
	# 		redirect_to_back

	# end

	def activity_index
		@client = Client.find_by_id(session[:CLIENT_ID])
		# l_records_per_page = SystemParam.get_pagination_records_per_page
		# @activity_info = ActivityHour.activity_hours_for_client_activity_grouped_by_week_ending_saturday(session[:CLIENT_ID], params[:action_plan_detail_id].to_i).page(params[:page]).per(l_records_per_page)
		@activity_info = ActivityHour.activity_hours_for_client_activity_grouped_by_week_ending_saturday(session[:CLIENT_ID], params[:action_plan_detail_id].to_i)
		@work_participation_for_client = ActivityHour.get_work_particpation_code(session[:CLIENT_ID], params[:action_plan_detail_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","activity_index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred while retrieving activity hours information for the client."
		redirect_to_back
	end

	def edit_week_info
		@client = Client.find_by_id(session[:CLIENT_ID])
		@week_id = params[:week_id].to_i
		@week_info = ActivityHour.activity_hours_for_client_activity_for_given_week_id(session[:CLIENT_ID], params[:action_plan_detail_id].to_i, @week_id)
		@work_participation_for_client = ActivityHour.get_work_particpation_code(session[:CLIENT_ID], params[:action_plan_detail_id])
		@submit_button_name = @week_info.completed_hours_for_week.to_i == 0 ? "Save" : "Edit"
		if @week_info.completed_hours_for_week.to_i == 0
			@submit_button_name = "Save"
			@completed_hours_read_only_flag = false
		else
			@submit_button_name = "Edit"
			@completed_hours_read_only_flag = true
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","edit_week_info",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred while editing week information for the client."
		redirect_to_back
	end

	def save_week_info
		# fail
		@week_id = params[:week_id].to_i
		if params[:commit] == "Save" && params[:completed_hours].to_i >= params[:assigned_hours].to_i
			week_info = ActivityHour.activity_hours_for_client_activity_for_given_week_id(session[:CLIENT_ID], params[:action_plan_detail_id].to_i, @week_id)
			activity_end_date = week_info.week_ending_date
			activity_start_date = DateService.date_of_previous("Sunday", activity_end_date)
			@activity_hours = ActivityHour.get_activity_hour_records_between_dates(params[:action_plan_detail_id].to_i, activity_start_date, activity_end_date)
			num_of_days_week = @activity_hours.count
			completed_hours = params[:completed_hours].to_i
			# Rails.logger.debug("completed_hours = #{completed_hours}")
			hrs_per_day = completed_hours/num_of_days_week
			hrs_per_day_offset = completed_hours%num_of_days_week
			# Rails.logger.debug("hrs_per_day = #{hrs_per_day}")
			# Rails.logger.debug("hrs_per_day_offset = #{hrs_per_day_offset}")
			# Rails.logger.debug("@activity_hours = #{@activity_hours.inspect}")
			# fail
			# count = 1
			@activity_hours.each do |activity_hour|
				# Rails.logger.debug("-->activity_hour#{count} = #{activity_hour.inspect}")
				activity_hour.completed_hours = hrs_per_day
				activity_hour.completed_hours += hrs_per_day_offset if @activity_hours.last == activity_hour
				activity_hour.save
				# unless activity_hour.save
				# 	Rails.logger.debug("-->after activity_hour#{count} = #{activity_hour.errors.full_messages}")
				# end
				# Rails.logger.debug("-->after activity_hour#{count} = #{activity_hour.inspect}")
				# count += 1
			end
			# fail
			redirect_to activity_index_path(@action_plan_detail.action_plan_id, @action_plan_detail.id), notice: "Activty Hours for the week ending in #{week_info.week_ending_date.strftime("%m/%d/%Y")} has been saved successfully."
		else
			flash[:notice] = "Please distribute the completed hours across each day of the week manually, since completed hours entered is less than assigned hours."
			redirect_to edit_week_activity_path(@action_plan_detail.action_plan_id, @action_plan_detail.id,@week_id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","save_week_info",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred while saving week information for the client."
		redirect_to_back
	end

	def edit_week_activity
		@client = Client.find_by_id(session[:CLIENT_ID])
		@week_id = params[:week_id].to_i
		week_info = ActivityHour.activity_hours_for_client_activity_for_given_week_id(session[:CLIENT_ID], params[:action_plan_detail_id].to_i, @week_id)
		activity_end_date = week_info.week_ending_date
		activity_start_date = DateService.date_of_previous("Sunday", activity_end_date)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@activity_hours = ActivityHour.get_activity_hour_records_between_dates(params[:action_plan_detail_id].to_i, activity_start_date, activity_end_date).page(params[:page]).per(l_records_per_page)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","edit_week_activity",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred while editing weekly activity day information for the client."
		redirect_to_back
	end

	def save_week_activity
		# fail
		@client = Client.find_by_id(session[:CLIENT_ID])
		@week_id = params[:week_id].to_i
		change_in_activity_hours = false
		# activity_hour_id = nil
		@activity_hours_errors = ActivityHour.new
		# @activity_hours = []
		# @warnings = []
		# any_errors_in_the_collection = false

		week_info = ActivityHour.activity_hours_for_client_activity_for_given_week_id(session[:CLIENT_ID], params[:action_plan_detail_id].to_i, @week_id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@activity_hours = ActivityHour.where("id in (?)",params[:activity_hours].keys).page(params[:page]).per(l_records_per_page)

		if @activity_hours.present?
			total_assigned_hours = @activity_hours.first.assigned_hours * @activity_hours.count
			total_hours_worked = 0
			absent_hours_hours_for_the_week = 0
			@activity_hours.each do |activity_hour|
				activity_hour = update_activity_hour_object(params[:activity_hours][activity_hour.id.to_s], activity_hour) if is_an_update_required(params[:activity_hours][activity_hour.id.to_s], activity_hour)
				total_hours_worked += activity_hour.completed_hours.to_i
				total_hours_worked += activity_hour.absent_hours.to_i if (activity_hour.absent_reason.present? && activity_hour.absent_reason.to_i != 6747)
				absent_hours_hours_for_the_week += activity_hour.absent_hours.to_i if activity_hour.absent_reason.present? && ![6295,6297,6747,6769].include?(activity_hour.absent_reason)
				unless activity_hour.valid?
					activity_hour.errors.full_messages.each do |error|
						@activity_hours_errors.errors[:base] << "#{error} for activity dated #{activity_hour.activity_date.strftime("%m/%d/%Y")}."
					end
				end
				if activity_hour.absent_reason.to_i == 6769 && !ClientCharacteristic.has_a_deferred_work_characteristic_on_the_given_date(activity_hour.client_id, activity_hour.activity_date)
					@activity_hours_errors.errors[:base] << "No deferred characteristic exist for the activity dated #{activity_hour.activity_date.strftime("%m/%d/%Y")}, can't save the activity information."
				end
			end

			@activity_hours_errors.errors[:base] << "Assigned Hours must be greater than or equal to completed hours and absence hours for the week to save activity information." unless total_hours_worked >= total_assigned_hours

			# For a reporting month all the absent hours shouldn't be greater than 16 hours
			# with reasons anything other than "Authorized Holiday" - 6295, "Compensation Time Off" - 6747, "Do not attend - Not Excused" - 6297, "Deferral/Exemption" - 6769

			reporting_month_start_date = DateService.get_start_date_of_reporting_month(week_info.week_ending_date)
			reporting_month_end_date = DateService.get_end_date_of_reporting_month(week_info.week_ending_date)

			absent_hours_for_reporting_month = ActivityHour.get_absent_hours_within_the_date_range(@client.id, reporting_month_start_date, reporting_month_end_date)
			absent_hours_for_reporting_month += absent_hours_hours_for_the_week
			@activity_hours_errors.errors[:base] << "Allowable absence hours for the reporting month exceeds 16 hours, can't save the activity information." if absent_hours_for_reporting_month > 16

			# The absent hours for 12 reporting months shouldn't exceed 80 hours, for any absent reason other than above mentioned
			reporting_year_start_date = DateService.get_reporting_month_start_date_prior_to_given_months(reporting_month_start_date, 11)
			reporting_year_end_date = reporting_month_end_date

			absent_hours_for_reporting_year = ActivityHour.get_absent_hours_within_the_date_range(@client.id, reporting_year_start_date, reporting_year_end_date)
			absent_hours_for_reporting_year += absent_hours_hours_for_the_week
			@activity_hours_errors.errors[:base] << "Allowable absence hours for the 12 reporting months exceeds 80 hours, can't save the activity information." if absent_hours_for_reporting_year > 80
		end

		if @activity_hours_errors.errors[:base].present?
			render :edit_week_activity
		else
			@activity_hours.each do |activity_hour|
				activity_hour.save
			end
			redirect_to activity_index_path(@action_plan_detail.action_plan_id, @action_plan_detail.id), notice: "Activity Information for the week ending #{week_info.week_ending_date.strftime("%m/%d/%Y")} has been updated successfully."
		end

		# # Rails.logger.debug("@activity_hours = #{@activity_hours.inspect}")
		# fail
		# # logger.debug("params[:activity_hours].keys.inspect = #{params[:activity_hours].keys.inspect}")
		# # future_activity_hours = ActivityHour.where("id in (?) and activity_date > ?",params[:activity_hours].keys, (Date.today+14.days))
		# future_activity_hours = ActivityHour.where("id in (?) and activity_date > ?",params[:activity_hours].keys, Date.today)
		# # logger.debug("ahs = #{ahs.where("activity_date > ?",(Date.today+14.days)).inspect}")
		# # logger.debug("future_activity_hours = #{future_activity_hours.inspect}")
		# # fail
		# if future_activity_hours.present? && future_dated_activity_hours_not_empty(future_activity_hours)
		# 	week_info = ActivityHour.activity_hours_for_client_activity_for_given_week_id(session[:CLIENT_ID], params[:action_plan_detail_id].to_i, @week_id)
		# 	activity_end_date = week_info.week_ending_date
		# 	activity_start_date = DateService.date_of_previous("Sunday", activity_end_date)
		# 	l_records_per_page = SystemParam.get_pagination_records_per_page
		# 	@activity_hours = ActivityHour.get_activity_hour_records_between_dates(params[:action_plan_detail_id].to_i, activity_start_date, activity_end_date).page(params[:page]).per(l_records_per_page)
		# 	# flash.now[:alert] = "Can't save future dated activities, please leave them blank"
		# 	@activity_hours_errors.errors[:base] = "Can't save future dated activities, please leave them blank."
		# 	render :edit_week_activity
		# else
		# 	Rails.logger.debug("params[:activity_hours].keys = #{params[:activity_hours].keys.inspect}")
		# 	params[:activity_hours].keys.each do |key|
		# 		# logger.debug("ActivityHour.find(key).inspect = #{ActivityHour.find(key).inspect}")
		# 		activity_hour = ActivityHour.find(key)
		# 		#logger.debug("params[:activity_hours][key] = #{params[:activity_hours][key].inspect}")
		# 		# is_an_update_required(params[:activity_hours][key], activity_hour)
		# 		#activity_hour.assign_attributes(params[:activity_hours][key])
		# 		if is_an_update_required(params[:activity_hours][activity_hour.id], activity_hour)
		# 			activity_hour = update_activity_hour_object(params[:activity_hours][activity_hour.id], activity_hour)

		# 			# if activity_hour.save
		# 			# 	change_in_activity_hours = true
		# 			# 	activity_hour_id = activity_hour.id
		# 			# else
		# 			# 	# fail
		# 			# 	#logger.debug("after save else = #{activity_hour.inspect}")
		# 			# 	any_errors_in_the_collection = true
		# 			# 	# logger.debug("activity_hour.errors.full_messages = #{activity_hour.errors.full_messages.inspect}")
		# 			# 	activity_hour.errors.full_messages.each do |error|
		# 			# 		# result = (error != "Absent hours")
		# 			# 		# Rails.logger.debug("#{error}!= Absent hours = #{result}")
		# 			# 		if error_not_part_of_filtered_messages(error)
		# 			# 			@activity_hours_errors.errors[:base] = "#{error} for activity dated #{activity_hour.activity_date.strftime("%m/%d/%Y")}."
		# 			# 		end
		# 			# 	end
		# 			# end
		# 		end
		# 		activity_hour.valid?
		# 		@activity_hours << activity_hour
		# 	end
		# 	render :edit_week_activity
		# 	# if any_errors_in_the_collection
		# 	# 	# logger.debug("@activity_hours_errors = #{@activity_hours_errors.errors.full_messages.inspect}")
		# 	# 	week_info = ActivityHour.activity_hours_for_client_activity_for_given_week_id(session[:CLIENT_ID], params[:action_plan_detail_id].to_i, @week_id)
		# 	# 	activity_end_date = week_info.week_ending_date
		# 	# 	activity_start_date = DateService.date_of_previous("Sunday", activity_end_date)
		# 	# 	l_records_per_page = SystemParam.get_pagination_records_per_page
		# 	# 	@activity_hours = ActivityHour.get_activity_hour_records_between_dates(params[:action_plan_detail_id].to_i, activity_start_date, activity_end_date).page(params[:page]).per(l_records_per_page)
		# 	# 	# @activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail_till_date(@action_plan_detail.id).page(params[:page]).per(l_records_per_page)
		# 	# 	render :edit_week_activity,  alert: "Please correct the following errors."
		# 	# else
		# 	# 	# Manoj 04/07/2015 - start
		# 	# 	# If the time entry is last schedule work day in last week of the month - generate payment records.
		# 	# 	# get the latest saved activity hours record.
		# 	# 	l_client_id = session[:CLIENT_ID].to_i
		# 	# 	week_info = ActivityHour.activity_hours_for_client_activity_for_given_week_id(session[:CLIENT_ID], params[:action_plan_detail_id].to_i, @week_id)
		# 	# 	activity_end_date = week_info.week_ending_date
		# 	# 	activity_start_date = DateService.date_of_previous("Sunday", activity_end_date)
		# 	# 	l_records_per_page = SystemParam.get_pagination_records_per_page
		# 	# 	activity_hour_collection = ActivityHour.get_activity_hour_records_between_dates(params[:action_plan_detail_id].to_i, activity_start_date, activity_end_date).page(params[:page]).per(l_records_per_page)

		# 	# 	# activity_hour_collection = ActivityHour.get_activity_hours_for_action_plan_detail_till_date(@action_plan_detail.id)
		# 	# 	activity_hour_object = activity_hour_collection.first

		# 	# 	begin
		#  #            ActiveRecord::Base.transaction do
		#  #            	if change_in_activity_hours
		# 	#             	common_action_argument_object = CommonEventManagementArgumentsStruct.new
		# 	# 		        common_action_argument_object.client_id = l_client_id
		# 	# 		        common_action_argument_object.event_id = 833 # Activity Hours Save
		# 	# 		        common_action_argument_object.program_unit_id = ActivityHour.get_program_unit_id(activity_hour_id)
		# 	# 		        common_action_argument_object.is_a_new_record = false
		# 	# 				msg = EventManagementService.process_event(common_action_argument_object)
		# 	#             end
		# 	#             lb_check = ActionPlan.can_create_workpays_payment?(activity_hour_object.id,l_client_id,activity_hour_object.activity_date)
		# 	# 			if lb_check == true
		# 	# 				ret_msg = ActionPlan.process_workpays_payment_line_item(l_client_id,activity_hour_object.activity_date)
		# 	# 				if ret_msg == "SUCCESS"
		# 	# 					redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail),  notice: "Activity hours information saved and workpays payment is submitted."
		# 	# 				else
		# 	# 					if ret_msg.include?("NOTHING_TO_PROCESS")
		# 	# 						redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail),  notice: "Activity hours information saved."
		# 	# 					else
		# 	# 						redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail),  alert: "Activity hours information saved.#{ret_msg}"
		# 	# 					end
		# 	# 				end
		# 	# 			else
		# 	# 				redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail),  notice: "Activity hours information saved."
		# 	# 			end
		#  #            end
		# 	#         rescue => err
		# 	#             error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","save activity hours information",err,AuditModule.get_current_user.uid)
		# 	#             msg = "Failed to save activity hours - for more details refer to Error ID: #{error_object.id}."
		#  #        end

		# 	# 	# Manoj 04/07/2015 - end

		# 	# 	# redirect_to enter_participation_hours_path(@action_plan,@action_plan_detail),  notice: "Activity hours information saved"
		# 	# end
		# end
		# fail
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","save_week_activity",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred while saving weekly activity day information for the client."
		redirect_to_back
	end


	private

		def create_participation_hours_records_for_a_week
		schedule = Schedule.get_schedule_for_action_plan_detail(@action_plan_detail.id)
			activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail_till_date(@action_plan_detail.id)
			if activity_hours.present?
				# logger.debug("--> activity_hours.first.activity_date = #{activity_hours.first.activity_date}")
				start_date = DateService.date_of_next("Sunday", activity_hours.first.activity_date)
				# logger.debug("--> start_date = #{DateService.date_of_next("Monday", activity_hours.first.activity_date)}")
				# fail
			else
				start_date = @action_plan_detail.start_date
				# logger.debug("start_date = #{start_date}")
				# fail
			end
			# logger.debug("start_date = #{start_date}")
			# fail
			start_day_id = CodetableItem.where("code_table_id = 153 and short_description = ?",start_date.strftime("%A")).first.id
			days_of_week = CodetableItem.where("code_table_id = 153").order("id")


			if schedule.recurring == 2325 #Daily
				start_day_id = days_of_week.where("short_description = ?",start_date.strftime("%A")).first.id

				days_of_week = days_of_week.where("id >= ?",start_day_id)
				#start_date = start_date + (CodetableItem.where("code_table_id = 153 and id not in(6142,6148)").count - days_of_week.count)
				days_of_week.each do |day|
					activity_hour = @action_plan_detail.activity_hours.new
					activity_hour.client_id = @client.id
					activity_hour.activity_date = start_date
					wpc = ClientCharacteristic.get_work_characteristic_for_client(@client.id)
					if wpc.present?
						wpc = wpc.first
						activity_hour.work_participation_code = wpc.characteristic_id
					end
					activity_hour.assigned_hours = @action_plan_detail.hours_per_day
					activity_hour.save
					start_date = start_date + 1
				end
			else #2320 weekly



					start_day_id = days_of_week.where("short_description = ?",start_date.strftime("%A")).first.id

					days_of_week = days_of_week.where("id >= ?",start_day_id)

					unless days_of_week.where("id in (?)",schedule.day_of_week).count > 0
						days_of_week = CodetableItem.where("code_table_id = 153").order("id")
						start_date = DateService.date_of_next("Sunday",start_date)
					end


					# logger.debug("days_of_week = #{days_of_week.inspect}")
					# fail

					days_of_week.each do |day|
						# logger.debug("schedule.day_of_week = #{schedule.day_of_week.inspect}")
						# logger.debug("(day.id = #{day.id}")
						# logger.debug("(day.id = #{schedule.day_of_week.include?(day.id)}")

						if schedule.day_of_week.include?(day.id)
							activity_hour = @action_plan_detail.activity_hours.new
							activity_hour.client_id = @client.id
							activity_hour.activity_date = start_date
							wpc = ClientCharacteristic.get_work_characteristic_for_client(@client.id)
							if wpc.present?
								wpc = wpc.first
								activity_hour.work_participation_code = wpc.characteristic_id
							end
							activity_hour.assigned_hours = @action_plan_detail.hours_per_day
							activity_hour.save
						end
						start_date = start_date + 1
					end
			end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ActivityHoursController","create_participation_hours_records_for_a_week",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to create participation record for the week."
			redirect_to_back
	end


	 	# def params_values
  	# 		params.require(:activity_hour).permit(:action_plan_detail_id, :client_id, :activity_date, :work_participation_code,
			# 								       :assigned_hours, :completed_hours, :completed_minutes, :absent_hours,
			# 								       :absent_minutes, :absent_reason, :time_limit, :caretaker_flag)
	  #   end

	    def set_client_id
			@client = Client.find(session[:CLIENT_ID])
		end

		def set_action_plan_id
			@action_plan = ActionPlan.find(params[:action_plan_id])
		end

		def set_action_plan_detail_id
	  		@action_plan_detail = ActionPlanDetail.find(params[:action_plan_detail_id])
		end

		# def set_id
	 #  		@activity_hour = ActivityHour.find(params[:id])
		# end

		# def create_activity_hour_record()
		# 	activity_hour = @action_plan_detail.activity_hours.new
		# 	activity_hour.client_id = @client.id
		# 	activity_hour.activity_date = @action_plan_detail.start_date
		# 	wpc = ClientCharacteristic.get_work_characteristic_for_client(@client.id)
		# 	if wpc.present?
		# 		wpc = wpc.first
		# 		activity_hour.work_participation_code = wpc.id
		# 	end
		# 	activity_hour.assigned_hours = @action_plan_detail.hours_per_day
		# 	activity_hour.save
		# end

		def is_an_update_required(hash, activity_hour)
			#"assigned_hours"=>"7", "completed_hours"=>"2", "completed_minutes"=>"22", "absent_hours"=>"3", "absent_minutes"=>"3", "absent_reason"=>""
			result = is_there_a_change_on_the_field(hash[:assigned_hours], activity_hour.assigned_hours)
			result = result || is_there_a_change_on_the_field(hash[:completed_hours], activity_hour.completed_hours)
			# result = result || is_there_a_change_on_the_field(hash[:completed_minutes], activity_hour.completed_minutes)
			result = result || is_there_a_change_on_the_field(hash[:absent_hours], activity_hour.absent_hours)
			# result = result || is_there_a_change_on_the_field(hash[:absent_minutes], activity_hour.absent_minutes)
			result = result || is_there_a_change_on_the_field(hash[:absent_reason], activity_hour.absent_reason)
			return result
		end

		def is_there_a_change_on_the_field(arg1, arg2)
			if arg1.present? && arg2.present?
				return (arg1.to_i != arg2)
			elsif arg1.present? && arg2.blank?
				return true
			elsif arg1.blank? && arg2.present?
				return true
			end
		end

		def update_activity_hour_object(hash, activity_hour)
			activity_hour.assigned_hours = hash[:assigned_hours]
			activity_hour.completed_hours = hash[:completed_hours]
			# activity_hour.completed_minutes = hash[:completed_minutes]
			activity_hour.absent_hours = hash[:absent_hours]
			# activity_hour.absent_minutes = hash[:absent_minutes]
			activity_hour.absent_reason = hash[:absent_reason]
			return activity_hour
		end

		def error_not_part_of_filtered_messages(error)
			result = (error != "Absent hours " && error != "Absent minutes ")
			result = result && (error != "Completed hours " && error != "Completed minutes ")
			return result
		end

		# def validate_total_annual_hours(arg_hours)
		# 	if ClientRelationship.is_there_a_parent_relationship(@client.id)
	 #            if ClientRelationship.is_there_any_child_who_is_less_than_six_years(@client.id)
	 #            	total_hours_per_year = ActivityHour.get_total_assigned_hours_over_one_year(@client.id, @action_plan_detail.activity_type, arg_date, arg_hours)
	 #                if total_hours_per_year > 240
	 #                     @action_plan_detail.errors[:base] << "Total activity hours for this activity exceeds 240 hour limit."
	 #                end
	 #            else
	 #                if self.duartion > 360
	 #                    @action_plan_detail.errors[:base] << "Total activity hours for this activity exceeds 360 hour limit."
	 #                end
	 #            end
	 #        end
		# end

		def future_dated_activity_hours_not_empty(activity_hours)
			# logger.debug("params = #{params.inspect}")
			result = false
			activity_hours.each do |ah|
				ah = update_activity_hour_object(params[:activity_hours][ah.id.to_s], ah)
				if ah.completed_hours.present? || ah.absent_hours.present? || ah.absent_reason.present?
					result = true
					break
				end
			end
			return result
		end
end
