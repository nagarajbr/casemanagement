class ActivityHour < ActiveRecord::Base
has_paper_trail :class_name => 'ActivityHourVersion',:on => [:update, :destroy]
	include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field#, :conditional_validation_for_absent_reason

    def set_create_user_fields
        user_id = AuditModule.get_current_user.uid
        self.created_by = user_id
        self.updated_by = user_id
    end

    def set_update_user_field
        user_id = AuditModule.get_current_user.uid
        self.updated_by = user_id
    end

    belongs_to :action_plan_detail

    attr_accessor :frequency_id


    # validate :conditional_validation_for_absent_reason, :validate_for_hours_distribution,:validate_authorized_holidays
    validate :conditional_validation_for_absent_reason,:validate_authorized_holidays

    def conditional_validation_for_absent_reason
        if self.absent_hours.present? || self.absent_minutes.present?
           validates_presence_of :absent_reason, message: "is required"
        end

        if self.absent_reason.present?
            if self.absent_hours.blank? #&& self.absent_minutes.blank?
                errors[:base] << "Absent hours is required"
                errors[:absent_hours] << ""
                # errors[:absent_minutes] << ""
            end
        end
    end

    def validate_authorized_holidays
        #Authorized Holiday should be verified with a list of approved holidays
        holiday_array = []
        if self.absent_reason.present? and self.absent_reason == 6295 and self.absent_hours.present?#Authorized holiday
            state_authorized_holidays = SystemParam.get_key_value_list(29,"Holiday","state holiday mapping")
            state_authorized_holidays.each do |holiday|
             holiday_array << holiday.value.to_date
            end
            unless holiday_array.include?(self.activity_date.to_date)
                any_errors_in_the_collection = true
                 #errors[:base] << "Activity dated #{self.activity_date.strftime("%m/%d/%Y")} is not a authorized holiday"
                 errors[:base] << "Hours cannot be keyed as authorized holiday."
            end
        end

    end

    def validate_for_hours_distribution
        total_hours = 0
        #Rails.logger.debug("--> #{self.completed_hours.present?}")
        total_hours = total_hours + (self.completed_hours.present? ? self.completed_hours : 0)
        # total_hours = total_hours + (self.completed_minutes.present? ? (self.completed_minutes/60.0) : 0)
        total_hours = total_hours + (self.absent_hours.present? ? self.absent_hours : 0)
        # total_hours = total_hours + (self.absent_minutes.present? ? (self.absent_minutes/60.0) : 0)
        if total_hours != 0 && total_hours != self.assigned_hours
            #Rails.logger.debug("total_hours = #{total_hours}")
            errors[:base] << "Assigned hours is not equal to sum of completed or absent hours."
            errors[:completed_hours] << ""
            # errors[:completed_minutes] << ""
            errors[:absent_hours] << ""
            # errors[:absent_minutes] << ""
        end
    end

    def self.get_activity_hours_for_action_plan_detail(arg_action_plan_detail_id)
        #logger.debug("#{where("action_plan_detail_id = ?",arg_action_plan_detail_id).inspect}")
        where("action_plan_detail_id = ?",arg_action_plan_detail_id).order("id desc")
        #fail
    end

     def self.get_activity_hours_for_action_plan_detail_till_date(arg_action_plan_detail_id)
        where("action_plan_detail_id = ? and activity_date <= ? ",arg_action_plan_detail_id, Date.today).order("id desc")
    end


    # def self.are_there_any_activity_hours_records_for_client(arg_client_id)
    #     where("client_id = ?",arg_client_id).count > 0
    # end


    # def self.get_total_assigned_hours_over_one_year(arg_client_id, arg_end_date)
    #     # Rails.logger.debug("called #{arg_action_plan_detail_id}")
    #     step1 = joins("INNER JOIN action_plan_details ON activity_hours.action_plan_detail_id = action_plan_details.id")
    #     step2 = step1.where("activity_hours.client_id = ? and action_plan_details.component_type = 6238 and activity_hours.activity_date >= ?",arg_client_id, (arg_end_date-365))
    #     step3 = step2.select("activity_hours.*").sum("assigned_hours")
    # end

    def self.validate_career_and_education_technical_limits(arg_client_id, arg_start_date, arg_end_date, arg_apd_id)
        step1 = joins("INNER JOIN action_plan_details ON activity_hours.action_plan_detail_id = action_plan_details.id")
        step2 = step1.where("activity_hours.client_id = ? and action_plan_details.component_type = 6240
                             and (completed_hours > 0 or absent_reason = 6297) and activity_date between ? and ?",arg_client_id, arg_start_date, arg_end_date)
        if arg_apd_id.present?
            return step2.where("activity_hours.action_plan_detail_id != ?",arg_apd_id).count > 0
        else
            return step2.count > 0
        end
    end

    def self.get_first_activity_date_for_career_and_education_technical_limits(arg_client_id)
        step1 = joins("INNER JOIN action_plan_details ON activity_hours.action_plan_detail_id = action_plan_details.id")
        step2 = step1.where("activity_hours.client_id = ? and action_plan_details.component_type = 6240 and (completed_hours > 0 or absent_reason = 6297)",arg_client_id)
        result = step2.select("activity_hours.*").order("activity_date")
        if result.present?
            result = result.first.activity_date
        end
        return result
    end

    def self.is_previous_week_activity_complete(arg_action_plan_detail_id)
        result = true
        activity_hours = get_activity_hours_for_action_plan_detail(arg_action_plan_detail_id)
        if activity_hours.present?
           activity_hours.each do |activity|
                completed_hours = activity.completed_hours.present? ? activity.completed_hours : 0
                absent_hours = activity.absent_hours.present? ? activity.absent_hours : 0
                unless activity.assigned_hours == (completed_hours + absent_hours)
                    result = false
                    break
                end
            end
        end
        return result
    end

    # def self.validation_for_component_type_job_search_and_job_readiness(arg_action_plan_detail)
    #     result = true
    #     activity_hours = get_activity_hours_for_action_plan_detail(arg_action_plan_detail.id)
    #     # Rails.logger.debug("activity_hours = #{activity_hours.inspect}")
    #     # fail
    #     if activity_hours.present?
    #         start_date = DateService.date_of_previous("Sunday", activity_hours.first.activity_date)
    #         end_date = start_date + 6
    #         max_allowed_weeks = 4
    #         count = 0
    #         weeks_occupied = 0
    #         while count < max_allowed_weeks
    #             result = is_the_week_occupied(start_date, end_date, arg_action_plan_detail.id)
    #             # Rails.logger.debug("***result#{count+1} = #{result}")
    #             if result == "OC"
    #                 weeks_occupied = weeks_occupied + 1
    #             # elsif max_allowed_weeks == 4 && result == "ONC"
    #             #     max_allowed_weeks = 5
    #             end
    #             start_date = start_date - 1.week
    #             end_date = end_date - 1.week
    #             count = count + 1
    #         end
    #         if weeks_occupied >= max_allowed_weeks
    #             result = false
    #             # fail
    #         end
    #         # Rails.logger.debug("weeks_occupied = #{weeks_occupied}")
    #         # Rails.logger.debug("max_allowed_weeks = #{max_allowed_weeks}")
    #         # fail
    #     end
    #     return result
    # end

    def self.get_particiapation_hours_for_closed_activity_with_component_type_jsjr(arg_action_plan_detail_id, arg_start_date, arg_end_date)
        total_hours = 0
        activity_hours = get_activity_hours_for_action_plan_detail(arg_action_plan_detail_id)
        total_hours = activity_hours.where("activity_date between ? and ?", arg_start_date, arg_end_date).sum("completed_hours")
        return total_hours
    end

    # def self.is_the_week_occupied(arg_start_date, arg_end_date, arg_action_plan_detail_id)

    #     # Return values:
    #     # UN - "Unoccupied"
    #     # OC - "Occupied Counted"
    #     # ONC - "Occupied Not Counted"
    #     # Rails.logger.debug("++++++++arg_start_date, arg_end_date, arg_action_plan_detail_id = #{arg_start_date}, #{arg_end_date}, #{arg_action_plan_detail_id}")
    #     result = "UN"
    #     week_participation_hours = where("activity_date between ? and ? and action_plan_detail_id = ?",arg_start_date, arg_end_date, arg_action_plan_detail_id)
    #     if week_participation_hours.present?
    #         result = (week_participation_hours.where("completed_hours > 0").count > 0) ? "OC" : result
    #         if result == "UN"
    #             # Rails.logger.debug("********week_participation_hours = #{week_participation_hours.inspect}")
    #             # fail
    #             result = "ONC"
    #             week_participation_hours.each do |activity_hour|
    #                 if activity_hour.absent_reason == 6297 # Do not attend - Not Excused
    #                     # Rails.logger.debug("week_participation_hours = #{week_participation_hours.inspect}")
    #                     # fail
    #                     result = "OC"
    #                     break
    #                 end
    #             end
    #         end
    #     end
    #     return result
    # end


    # def self.get_number_of_weeks_in_reporting_month(arg_reporting_month)
    #     # Manoj Patil 04/06/2015
    #     # Description : I/p : reporting month
    #     #               o/p : 4 or 5 weeks depending on beginning day of the month or the last day of the month.
    #     # defintion of week : should include >= 3 working days
    #     # Example : I/p Month - APril-2015
    #     # first day of the month = 04/01/2015 = Wednesday -
    #     # 3 working days are in first week, week count = 1
    #     # week ending 04/10/2015 --> week count = 2
    #     # week end ing 04/17/2015 --> week count  = 3
    #     # week ending 04/24/2015 --> week count = 4
    #     # last day of month 04/30/2015 in Thursay - 3 working days are , may-1-2015 is part of April reporting month
    #     # week count = 5
    #     # Hence in April - 2015 - there are 5 weeks with working days >=3



    #     li_week = 3
    #     # determine the first day of the passed month.
    #     ldt_first_day_date = "#{arg_reporting_month.year}-#{arg_reporting_month.month}-01"
    #     ldt_first_day_date = ldt_first_day_date.to_date
    #     # logger.debug("ldt_first_day_date = #{ldt_first_day_date.inspect}")

    #     first_day_name = ldt_first_day_date.strftime("%A").upcase
    #     # logger.debug("first_day_name = #{first_day_name}")
    #     if (first_day_name == 'MONDAY' || first_day_name == 'TUESDAY' || first_day_name == 'WEDNESDAY' )
    #         # Rule - >=3 working days then it is a countable week
    #         li_week = li_week + 1
    #     end

    #     l_month = arg_reporting_month.month
    #     l_year = arg_reporting_month.year
    #     ldt_last_day_date = Date.civil(l_year, l_month, -1)
    #      # logger.debug("ldt_last_day_date = #{ldt_last_day_date.inspect}")
    #     last_day_name = ldt_last_day_date.strftime("%A").upcase
    #       # logger.debug("last_day_name = #{last_day_name}")
    #      if (last_day_name == 'WEDNESDAY' || last_day_name == 'THURSDAY' || last_day_name == 'FRIDAY' || last_day_name == 'SATURDAY')
    #         # Last day of week on one of these days ensures - more tha >=3 working days - hence countable week
    #         li_week = li_week + 1
    #     end

    #     if li_week == 3
    #         # if it does'nt fall in workable week count - 4 weeks is a must.
    #          # logger.debug("li_week== 3 #{li_week.inspect}")
    #         li_week = 4
    #     end
    #     # logger.debug("li_week = #{li_week.inspect}")

    #     return li_week

    # end

    def self.is_there_an_activity_entry(arg_client_id, arg_component_type, arg_begin_date, arg_end_date, arg_apd_id)
        step1 = joins("INNER JOIN action_plan_details ON action_plan_details.id = activity_hours.action_plan_detail_id")
        step2 = step1.where("activity_hours.client_id = ? and  action_plan_details.component_type = ?
                             and activity_hours.completed_hours > 0 and activity_date between ? and ?",arg_client_id, arg_component_type, arg_begin_date, arg_end_date)
        if arg_apd_id.present?
            return step2.where("activity_hours.action_plan_detail_id != ?",arg_apd_id).count > 0
        else
            return step2.count > 0
        end
    end

    def self.get_number_of_weeks_added(arg_action_plan_detail_id)
        schedule = Schedule.get_schedule_info_from_action_plan_detail_id(arg_action_plan_detail_id)
        days_per_week = schedule.day_of_week.count
        weeks_added = 0
        total_entries = where("action_plan_detail_id = ?", arg_action_plan_detail_id).count
        if total_entries > 0
            weeks_added = total_entries/days_per_week.to_f
        end
        if weeks_added > weeks_added.to_i
            weeks_added = weeks_added.to_i + 1
        end
        return weeks_added
    end

    def self.get_program_unit_id(arg_activity_hour_id)
        result = nil
        step1 = joins("INNER JOIN action_plan_details ON action_plan_details.id = activity_hours.action_plan_detail_id
                       INNER JOIN action_plans ON action_plan_details.action_plan_id = action_plans.id")
        step2 = step1.where("activity_hours.id = ?",arg_activity_hour_id)
        step3 = step2.select("action_plans.*")
        if step3.present?
            result = step3.first.program_unit_id
        end
        return result
    end


    def self.get_client_activities_for_reporting_month(arg_start_date,arg_end_date,arg_client_id)
         step1 = ActivityHour.where("activity_date between ? and ? and client_id = ? ",arg_start_date,arg_end_date,arg_client_id)
         step2 = step1.select("distinct activity_hours.*" )
         return step2
    end
    def self.get_client_activities_for_last_12_reporting_months(arg_client_id)
        #6295 = "Authorized Holiday"
        previous_month = Date.today - 1.month
        prior_month_start_date = DateService.get_start_date_of_reporting_month(previous_month - 1.year)
        prior_month_end_date = DateService.get_end_date_of_reporting_month(previous_month)
        step1 = ActivityHour.joins("inner join client_characteristics on  client_characteristics.client_id = activity_hours.client_id")
        step2 = step1.where("client_characteristics.characteristic_type = 'WorkCharacteristic'and client_characteristics.characteristic_id = 5667  and activity_hours.activity_date between ? and ?  and activity_hours.client_id = ? and (activity_hours.absent_reason != 6295 or activity_hours.absent_reason is null) ", prior_month_start_date,prior_month_end_date,arg_client_id)
        step3 = step2.select("activity_hours.*")
        activity_hours = step3
        return activity_hours
    end


    def self.activity_hours_for_client_activity_grouped_by_week_ending_saturday(arg_client_id,arg_action_plan_detail_id)
        step1 = ActivityHour.where("activity_hours.client_id = ?
                                    and activity_hours.action_plan_detail_id = ?
                                    and activity_hours.activity_date <= ?
                                    ",arg_client_id,arg_action_plan_detail_id, Date.today)
        step2 = step1.select("  case extract(dow from activity_date)
                                   when 6 then activity_date + 0
                                   when 0 then activity_date + 6
                                   when 1 then activity_date + 5
                                   when 2 then activity_date + 4
                                   when 3 then activity_date + 3
                                   when 4 then activity_date + 2
                                   when 5 then activity_date + 1
                                end as week_ending_date,
                                sum(activity_hours.assigned_hours) as assigned_hours_for_week,
                                sum(activity_hours.completed_hours) as completed_hours_for_week,
                                sum(activity_hours.absent_hours) as absent_hours_for_week
                                ").group("week_ending_date").order("week_ending_date ASC")
        # latest_week_ending_possible = Date.today.strftime("%A") == "Saturday" ? Date.today : DateService.date_of_next("Saturday", Date.today)
        # weekly_activity_hours_collection = step2.where("week_ending_date <= ?",latest_week_ending_possible)
        # return weekly_activity_hours_collection
    end

    def self.get_work_particpation_code(arg_client_id, arg_action_plan_detail_id)
        step1 = where("activity_hours.client_id = ?
                                    and activity_hours.action_plan_detail_id = ?",arg_client_id,arg_action_plan_detail_id)
        step1.present? ? step1.first.work_participation_code : nil
    end

    def self.activity_hours_for_client_activity_for_given_week_id(arg_client_id,arg_action_plan_detail_id, arg_week_id)
        activities_info = activity_hours_for_client_activity_grouped_by_week_ending_saturday(arg_client_id,arg_action_plan_detail_id)
        # Rails.logger.debug("activities_info.class = #{activities_info.class.name}")
        # Rails.logger.debug("activities_info = #{activities_info.inspect}")
        # fail
        count = 1
        result = nil
        activities_info.each do |week_ending_activity|
            if count == arg_week_id.to_i
                result = week_ending_activity
            end
            count += 1
        end
        return result
    end

    def self.get_activity_hour_records_between_dates(arg_action_plan_id, arg_activity_start_date, arg_activity_end_date)
        where("action_plan_detail_id = ? and activity_date between ? and ?",arg_action_plan_id, arg_activity_start_date, arg_activity_end_date).order(:id)
    end

    def self.get_absent_hours_within_the_date_range(arg_client_id, arg_start_date, arg_end_date)
        where("client_id = ? and activity_date between ? and ? and
               absent_reason is not null and absent_reason not in (6295,6297,6747,6769)",arg_client_id, arg_start_date, arg_end_date).sum(:absent_hours)
    end

    def self.get_activity_hours_by_core_and_non_core_hours(arg_program_unit_id,arg_start_date,arg_end_date)
        step1 = ActionPlan.joins("INNER JOIN  action_plan_details on (action_plans.id = action_plan_details.action_plan_id)
                                  INNER JOIN  activity_hours on activity_hours.action_plan_detail_id = action_plan_details.id ")
        step2 = step1.where("action_plans.program_unit_id = ? and activity_hours.activity_date between ? and ? ",arg_program_unit_id,arg_start_date,arg_end_date )
        step3 = step2.select("activity_hours.*")
    end

    def self.get_activity_hours_by_core_or_non_core_hours(arg_program_unit_id,arg_start_date,arg_end_date,arg_activity_type)
        step1 = ActionPlan.joins("INNER JOIN  action_plan_details on (action_plans.id = action_plan_details.action_plan_id)
                                  INNER JOIN  activity_hours on activity_hours.action_plan_detail_id = action_plan_details.id ")
        step2 = step1.where("action_plans.program_unit_id = ? and activity_hours.activity_date between ? and ? and action_plan_details.activity_type in (?)",arg_program_unit_id,arg_start_date,arg_end_date,arg_activity_type )
        step3 = step2.select("activity_hours.*")
    end

end