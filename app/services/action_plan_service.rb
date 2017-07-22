class ActionPlanService

	def self.get_expected_work_participation_hours(arg_program_unit, arg_start_date, arg_end_date)
		participation_hours = nil
		expected_work_participation_hours_collection = ExpectedWorkParticipationHour.where("service_program_id = ? and case_type = ?",arg_program_unit.service_program_id,arg_program_unit.case_type).order(:work_participation_mandatory_deferred)
		expected_work_participation_hours_collection.each do |ewp|
			if validation_result(ewp, arg_program_unit, arg_start_date, arg_end_date)
				participation_hours = {}
				participation_hours[:min_core_hours] = ewp.min_core_hours
				participation_hours[:non_core_hours] = ewp.non_core_hours
				participation_hours[:total_hours] = ewp.min_core_hours + ewp.non_core_hours
				break
			end
		end
		return participation_hours
	end

	def self.validation_result(arg_expected_work_participation_hour, arg_program_unit, arg_start_date, arg_end_date)
		result = false
		case arg_expected_work_participation_hour.id
		when 2,12 # "No child under 6 years of age"
			result = ProgramUnitMember.no_child_under_six_years_of_age(arg_program_unit.id, arg_start_date, arg_end_date)
			# Rails.logger.debug("result = #{result}")
			# fail
		when 3,13 # "One or more children under 6 years of age"
			result = ProgramUnitMember.one_or_more_child_under_six_years_of_age(arg_program_unit.id, arg_start_date, arg_end_date)
		when 7 # "One parent deferred"
			case arg_program_unit.case_type
			when 6047 # "Two Parent"
				parent_participations = ClientCharacteristicService.determine_participation_status_for_the_parents_in_the_program_unit(arg_program_unit.id, arg_start_date, arg_end_date)
				result = true if parent_participations.present? && parent_participations[:mandatory] == 1 && parent_participations[:disabled] == 1
			else
				# result = ProgramUnitMember.one_or_more_adult_is_disabled(arg_program_unit.id, arg_start_date, arg_end_date)
			end
		when 5,8 # "No child care" or "One parent deferred"
			case arg_program_unit.case_type
			when 6047 # "Two Parent"
				parent_participations = ClientCharacteristicService.determine_participation_status_for_the_parents_in_the_program_unit(arg_program_unit.id, arg_start_date, arg_end_date)
				result = true if parent_participations.present? && parent_participations[:mandatory] == 1 && parent_participations[:deferred] == 1

			else
				# result = ProgramUnitMember.one_or_more_adult_is_deferred(arg_program_unit.id, arg_start_date, arg_end_date)
			end
		when 6 # "Child care provided"
			case arg_program_unit.case_type
			when 6047 # "Two Parent"
				parent_participations = ClientCharacteristicService.determine_participation_status_for_the_parents_in_the_program_unit(arg_program_unit.id, arg_start_date, arg_end_date)
				result = true if parent_participations.present? && parent_participations[:mandatory] == 2
			else
				# result = !(ProgramUnitMember.one_or_more_adult_is_disabled(arg_program_unit.id, arg_start_date, arg_end_date)) && !(ProgramUnitMember.one_or_more_adult_is_deferred(arg_program_unit_id, arg_start_date, arg_end_date))
			end

		when 4,9,11
			# Rails.logger.debug("arg_program_unit.case_type = #{arg_program_unit.case_type}")
			case arg_program_unit.case_type
			when 6046 # "Single Parent"
				pgu_members = ProgramUnitService.get_parent_list_for_the_program_unit(arg_program_unit.id)
				result = true if pgu_members.present? && ClientCharacteristicService.is_the_client_deferred(pgu_members.first.client_id, arg_start_date, arg_end_date)
			when 6047 # "Two Parent"
				parent_participations = ClientCharacteristicService.determine_participation_status_for_the_parents_in_the_program_unit(arg_program_unit.id, arg_start_date, arg_end_date)
				result = true if parent_participations.present? && (parent_participations[:deferred] + parent_participations[:disabled]) == 2
			# else
				# result = true
			end
			# Rails.logger.debug("result = #{result}")
			# fail
		end
		return result
	end

	# def self.get_six_weeks_participation_hours(arg_action_plan)
	# 	work_participation_hours_for_six_weeks = []
	# 	start_date = arg_action_plan.start_date > Date.today ? arg_action_plan.start_date : Date.today
	# 	end_date = DateService.date_of_next("Saturday", start_date)
	# 	(1..6).each do
	# 		work_participation = WorkParticipationStruct.new
	# 		work_participation.week_ending = end_date
	# 		work_participation.core_hours = get_core_hours(arg_action_plan.id, start_date, end_date)
	# 		work_participation.non_core_hours = get_non_core_hours(arg_action_plan.id, start_date, end_date)
	# 		work_participation_hours_for_six_weeks << work_participation
	# 		start_date = end_date + 1
	# 		end_date = end_date + 7
	# 	end
	# 	return work_participation_hours_for_six_weeks
	# end

	def self.get_work_participation_hours_for_reporting_month(arg_program_unit_id, arg_start_date, arg_end_date)
		parents_list = ProgramUnitService.get_parent_list_for_the_program_unit(arg_program_unit_id)
		arg_program_unit = ProgramUnit.find_by_id(arg_program_unit_id)
		month_participation_hrs = get_expected_work_participation_hours(arg_program_unit, arg_start_date, arg_end_date)
		# Rails.logger.debug("month_participation_hrs = #{month_participation_hrs.inspect}")
		# fail
		reporting_month_participation_hrs = []
		reporting_date = arg_start_date
		reporting_month_core_hrs = reporting_month_non_core_hrs = reporting_month_total_hrs = 0
		mandatory_characteristics = [5667,5700,5701]
		# hide_schedule_result = true # ******************Need revisit**************************
		hide_schedule_result = false
		while arg_start_date < arg_end_date
			start_date = arg_start_date
			end_date = DateService.date_of_next("Saturday", start_date)
			work_participation = WorkParticipationStruct.new
			work_participation.week_ending = end_date
			work_participation.core_hours = get_core_hours(arg_program_unit_id, start_date, end_date)
			work_participation.non_core_hours = get_non_core_hours(arg_program_unit_id, start_date, end_date)
			work_participation.total_hours = work_participation.core_hours + work_participation.non_core_hours

			reporting_month_core_hrs += work_participation.core_hours
			reporting_month_total_hrs += work_participation.total_hours
			reporting_month_non_core_hrs += work_participation.non_core_hours
			# Populate Work Participation information for all the parents within the program unit
			# ******************Need revisit**************************

			if parents_list.present?
				parents_list.each do |pgu_member|
					work_participation.work_characteristics[pgu_member.client_id] = ClientCharacteristic.get_work_participation_for_parent(pgu_member.client_id, start_date, end_date)
					# hide_schedule_result = false if hide_schedule_result && mandatory_characteristics.include?(work_participation.work_characteristics[pgu_member.client_id])
				end
			end

			# ******************Need revisit**************************
			reporting_month_participation_hrs << work_participation
			arg_start_date = end_date + 1
		end
		reporting_month_participation_hrs[0].reporting_date = reporting_date.strftime("%B,%Y") if reporting_month_participation_hrs.size > 0

		no_of_weeks = reporting_month_participation_hrs.size

		# Rails.logger.debug("month_participation_hrs = #{month_participation_hrs.inspect}")
		# Rails.logger.debug("no_of_weeks = #{no_of_weeks}")
		# Rails.logger.debug("month_participation_hrs[:min_core_hours].to_i*no_of_weeks = #{month_participation_hrs[:min_core_hours].to_i*no_of_weeks}")
		# Rails.logger.debug("month_participation_hrs[:total_hours].to_i*no_of_weeks = #{month_participation_hrs[:total_hours].to_i*no_of_weeks}")
		# Rails.logger.debug("reporting_month_core_hrs = #{reporting_month_core_hrs}")
		# Rails.logger.debug("reporting_month_total_hrs = #{reporting_month_total_hrs}")
		# fail
		reporting_month_participation_hrs[0].reporting_month_core_hrs = reporting_month_core_hrs
		reporting_month_participation_hrs[0].reporting_month_non_core_hrs = reporting_month_non_core_hrs
		reporting_month_participation_hrs[0].reporting_month_total_hrs = reporting_month_total_hrs

		reporting_month_participation_hrs[0].reported_avg_hrs_per_week = (reporting_month_total_hrs/no_of_weeks.to_f).round(2)
		reporting_month_participation_hrs[0].reported_core_avg_hrs_per_week = (reporting_month_core_hrs/no_of_weeks.to_f).round(2)
		reporting_month_participation_hrs[0].reported_non_core_avg_hrs_per_week = (reporting_month_non_core_hrs/no_of_weeks.to_f).round(2)
		# Rails.logger.debug("hide_schedule_result = #{hide_schedule_result}")
		# fail
		if month_participation_hrs.present?
			reporting_month_participation_hrs[0].total_hrs_required = month_participation_hrs[:total_hours].to_i*no_of_weeks
			reporting_month_participation_hrs[0].core_hrs_required = month_participation_hrs[:min_core_hours].to_i*no_of_weeks
			reporting_month_participation_hrs[0].required_avg_hrs_per_week = month_participation_hrs[:total_hours].to_i
			reporting_month_participation_hrs[0].required_core_avg_hrs_per_week = month_participation_hrs[:min_core_hours].to_i*no_of_weeks
			hide_schedule_result = true if reporting_month_participation_hrs[0].total_hrs_required == 0
			unless hide_schedule_result
				if (reporting_month_core_hrs >= reporting_month_participation_hrs[0].core_hrs_required) && (reporting_month_total_hrs >= reporting_month_participation_hrs[0].total_hrs_required)
					reporting_month_participation_hrs[0].schedule_result = "Met required weekly work participation"
				else
					reporting_month_participation_hrs[0].schedule_result = "Does not meet the required weekly work participation"
				end
			end
		end
		return reporting_month_participation_hrs
	end

	def self.get_core_hours(arg_program_unit_id, start_date, end_date)
		core_activity_types = CodetableItem.get_activity_types_for_core_components
		# Rails.logger.debug("core_activity_types = #{core_activity_types.inspect}")
		# fail
		calculate_participation_hours(arg_program_unit_id, start_date, end_date, core_activity_types)
	end

	def self.get_non_core_hours(arg_program_unit_id, start_date, end_date)
		non_core_activity_types = CodetableItem.get_activity_types_for_non_core_components
		calculate_participation_hours(arg_program_unit_id, start_date, end_date, non_core_activity_types)
	end

	def self.calculate_participation_hours(arg_program_unit_id, arg_start_date, arg_end_date, activity_types)
		total_participation_hrs = 0
		schedules = Schedule.get_schedules_info_for_given_dates_associated_with_program_unit(arg_program_unit_id, arg_start_date, arg_end_date, activity_types)
		# if Date.today + 2 == start_date
		# 	Rails.logger.debug("-->0.1 schedules for #{start_date} = #{schedules.inspect}")
		# 	fail
		# end
		# Rails.logger.debug("schedules = #{schedules.inspect}")
		# fail
		if schedules.present?
			schedules.each do |schedule|
				start_date = arg_start_date
				end_date = arg_end_date
				action_plan_detail = ActionPlanDetail.find_by_id(schedule.reference_id)
				start_date = action_plan_detail.start_date > start_date ? action_plan_detail.start_date : start_date
				action_plan_detail.end_date = action_plan_detail.start_date + schedule.duration*7 - 1 if action_plan_detail.end_date.blank?
				end_date = action_plan_detail.end_date < end_date ? action_plan_detail.end_date : end_date
				# Rails.logger.debug("start_date = #{start_date}")
				# Rails.logger.debug("end_date = #{end_date}")
				# fail
				start_date_id = CodetableItem.get_codetable_items_id(153, start_date.strftime("%A")).first.id
				end_date_id = CodetableItem.get_codetable_items_id(153, end_date.strftime("%A")).first.id
				schedule.day_of_week.reject! {|x| x < start_date_id}
				schedule.day_of_week.reject! {|x| x > end_date_id}
				# Rails.logger.debug("-->1. schedule.day_of_week = #{schedule.day_of_week.inspect}")
				# Rails.logger.debug("-->1.1 schedule.day_of_week.size = #{schedule.day_of_week.size}")
				# Rails.logger.debug("-->1.2 schedule.duration = #{schedule.duration}")
				participation_hrs = schedule.day_of_week.size * action_plan_detail.hours_per_day
				# Rails.logger.debug("-->2. participation_hrs = #{participation_hrs}")
				total_participation_hrs += participation_hrs
			end
		end
		# Rails.logger.debug("total_participation_hrs = #{total_participation_hrs}")
		# fail if arg_end_date == Date.civil(2016,4,30)
		return total_participation_hrs
	end

	def self.get_instances_for_active_plan_summary(arg_program_unit_id, arg_action_plan)
		if (arg_action_plan.present? && arg_action_plan.short_term_goal.present? && (arg_action_plan.short_term_goal).to_i != 6767 )
			onet_ws = OnetWebService.new("arwins","9436zfu")
			employment_goal = onet_ws.get_code_description(arg_action_plan.short_term_goal,"careers","career")
		else
			employment_goal = CodetableItem.get_long_description((arg_action_plan.short_term_goal).to_i) if arg_action_plan.short_term_goal.present?
		end
		start_date = DateService.get_start_date_of_reporting_month(Date.today)
		earliest_action_plan_start_date = ActionPlan.get_earliest_action_plan_start_date_for_the_program_unit(arg_program_unit_id, start_date)
		earliest_action_plan_start_date = Date.today if earliest_action_plan_start_date.blank?
		start_date = DateService.get_start_date_of_reporting_month(earliest_action_plan_start_date)
		end_date = DateService.get_end_date_of_reporting_month(earliest_action_plan_start_date)
		# start_date = start_date < earliest_action_plan_start_date ? earliest_action_plan_start_date : start_date
		work_participation = {}
		work_participation[:current_month] = ActionPlanService.get_work_participation_hours_for_reporting_month(arg_program_unit_id, start_date, end_date)
		start_date = end_date + 1 # Next month is consecutive reporting month for the current month.
		end_date = DateService.get_end_date_of_reporting_month(start_date)
		work_participation[:next_month] = ActionPlanService.get_work_participation_hours_for_reporting_month(arg_program_unit_id, start_date, end_date)
		instances = {}
		instances[:employment_goal] = employment_goal
		instances[:work_participation] = work_participation
		return instances
	end
end