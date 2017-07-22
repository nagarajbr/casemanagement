class ActionPlanDetail < ActiveRecord::Base
has_paper_trail :class_name => 'ActionPlanDetailVersion',:on => [:update, :destroy]
    attr_accessor :outcome_code, :outcome_notes, :frequency_id, :days_of_week, :duration, :warning_count, :program_unit_id, :client_id, :providers_list

    after_create :set_reference_id_if_required

    include AuditModule
    before_create :set_create_user_fields, :validations_for_step3, :set_activity_classification, :set_youngest_child_details_from_houshold
    before_update :set_update_user_field, :validate_action_plan_start_and_end_dates, :validations_for_step3, :set_activity_classification
    # before_update :set_update_user_field, :validate_action_plan_start_and_end_dates, :close_all_related_supportive_services_if_activity_status_is_set_to_closed, :validations_for_step3, :set_activity_classification

    after_update :save_non_supportive_service
    after_create :save_non_supportive_service

    def save_non_supportive_service
        if entity_type == 6253 && client_agreement_date.blank?
            ServiceAuthorization.create_non_supportive_service_plan(id)
        end
    end


    # before_save :validations_for_step3
    def set_create_user_fields
        user_id = AuditModule.get_current_user.uid
        self.created_by = user_id
        self.updated_by = user_id
    end

    def set_update_user_field
        user_id = AuditModule.get_current_user.uid
        self.updated_by = user_id
    end

    has_many :activity_hours, dependent: :destroy

    HUMANIZED_ATTRIBUTES = {
        activity_classfication: "Activity Classification",
        activity_type: "Activity Type",
        component_type: "Component Type",
        activity_status: "Activity Status",
        client_agreement_date: "Agreement Date",
        start_date: "Start Date",
        end_date: "End Date" ,
        notes: "Notes",
        outcome_code: "Outcome Code",
        outcome_notes: "Outcome Notes",
        hours_per_day: " Number of Hours/Day"#,
        #duration: ((self.frequency_id.present? && self.frequency_id == 2325)? "Number of Days" : "Number of Weeks")
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    belongs_to :action_plan

    validate :custom_validations, :perform_validations_for_supportive_services

    def custom_validations
        # if self.get_process_object == "action_plan_detail_first"
        #     validations_for_step1
        #     validations_for_step2
        # elsif self.get_process_object == "action_plan_detail_second"
        #     validations_for_step1
        #     validations_for_step2
        # end
        validations_for_step1
        validations_for_step2
    end

    def perform_validations_for_supportive_services
        if self.entity_type == 6294 # supportive service
            validates_presence_of :action_plan_id, :barrier_id, :activity_type, :entity_type, :activity_status, :start_date, message: "is required"
        end
    end

    def validations_for_step1
        validates_presence_of :action_plan_id, :activity_type, :entity_type, :activity_status, message: "is required"
        validates_presence_of :barrier_id, :component_type, message: "is required" if self.activity_type.present?
        if self.entity_type.present? && self.entity_type == 6253 # Service entity type
            validates_presence_of :provider_id, message: "is required"
        end
        check_if_same_activity_type_already_exist

        # Validations for component type work experience
        if self.component_type.present? && (self.component_type == 6239 || self.component_type == 6241 || self.component_type == 6242 || self.component_type == 6243)
            # This component type should not be allowed for a child only or a minor parent case
            # case_type = ProgramUnit.find(self.program_unit_id).case_type
            case_type = ProgramUnit.get_case_type(self.program_unit_id)
            if case_type.present? && (case_type == 6048 || case_type == 6049)  # 6048 "Child Only Case", 6049 "Minor Parent Case"
                errors[:base] << "Can't add this activity since it is a #{CodetableItem.get_short_description(case_type)} case."
            end
        end
    end

    def set_activity_classification
        if self.component_type.present?
            self.activity_classfication = CodetableItem.get_code_table_id(self.component_type)
        end
    end

    def validations_for_step2
        validates_presence_of :start_date, :hours_per_day, message: "is required"
        required_duration_range
        valid_start_date?
        validate_presence_of_end_date
        if self.end_date.present?
            valid_end_date?
            # start_date_less_than_end_date?
            presence_of_check_when_activity_status_is_closed
        end

        if self.frequency_id.present?
            if self.hours_per_day.present?
                unless (0..8).include?(self.hours_per_day)
                    errors[:hours_per_day] << " should be between 0 and 8"
                end
            end
        end

        if self.frequency_id.present?
            if self.duration.blank?
                # errors[:duration] << ""
                if self.frequency_id == 2325
                    errors[:duration] <<"Number of Days is required."
                else
                    errors[:duration] <<"Number of Weeks is required."
                end
            end
            if self.days_of_week.include?("")
                self.days_of_week.shift
            end
            unless self.days_of_week.count > 0
                errors[:base] <<"Select days in the week."
            end
        end

        # Validations for component type work experience
        # Min and Max hours per week validation for component type Work Experience
        # Max Hours: 40, for any case type
        # Single Parent Case -  Min hours: 30
        # Two parent Case - No minimum hours validation
        if self.new_record? && (self.component_type == 6239 || self.component_type == 6241 || self.component_type == 6242 || self.component_type == 6243) && self.hours_per_day.present? && self.days_of_week.count > 0 # 6241-Work Experience
            hours_per_week = self.hours_per_day.to_i * self.days_of_week.count
            case_type = ProgramUnit.get_case_type(self.program_unit_id)
            if case_type == 6046 # "Single Parent Case"
                if self.component_type == 6241
                    min_hours_per_week = 30
                else
                    min_hours_per_week = 20
                end
                if hours_per_week < min_hours_per_week
                    errors[:base] <<"Minimum #{min_hours_per_week} hours per week is required."
                end
            end
            # Common validation for both single and two parent case
            if hours_per_week > 40
                errors[:base] <<"Maximum 40 hours per week is allowed."
            end
        end

    end

    def validations_for_step3
        validates_presence_of :client_agreement_date, message: "is required."
    end

    def valid_start_date?
        DateService.valid_date?(self,start_date,"Start date") && is_start_date_greater_than_action_plan_start_date
    end

    def valid_end_date?
        DateService.valid_date?(self,end_date,"End date")
    end

    # def start_date_less_than_end_date?
    #     DateService.begin_date_cannot_be_greater_than_end_date?(self,start_date,end_date,"Start date","End date")
    # end

    def presence_of_check_when_activity_status_is_closed
        if self.activity_status.present? && self.activity_status == 6044 # close
            unless self.outcome_code.present?
                errors[:outcome_code] << " is required when activity is closed."
            end
        end
    end

    def required_duration_range
        if self.hours_per_day.present?
            unless (0..50).include?(self.hours_per_day)
                errors[:hours_per_day] << " should be between 0 and 50."
            end
        end
    end

    def is_start_date_greater_than_action_plan_start_date
        if self.start_date.present? && self.action_plan.present?
            unless self.action_plan.start_date <= self.start_date
              errors[:start_date] << " must be greater than action plan start date #{self.action_plan.start_date.strftime('%m/%d/%Y')}."
              return false
            end
        else
            return true
        end
    end

    def validate_presence_of_end_date
        if self.activity_status.present?
            if self.activity_status == 6043 # open status
                if self.end_date.present?
                    errors[:end_date] = " should be blank when activity status is open."
                end
            elsif self.activity_status == 6044 # close status
                if self.end_date.blank?
                    errors[:end_date] = " is required when activity status is closed."
                end
            end
        end
    end

    def check_if_same_activity_type_already_exist
        if (self.activity_type.present? and self.activity_type != 6357)
            if self.id.present?
                open_activity_type_present = ActionPlanDetail.where("action_plan_id = ? and activity_type = ? and activity_status = 6043 and id != ?",self.action_plan_id,self.activity_type, self.id).count > 0
            else
                open_activity_type_present = ActionPlanDetail.where("action_plan_id = ? and activity_type = ? and activity_status = 6043",self.action_plan_id,self.activity_type).count > 0
            end

             if open_activity_type_present
                errors[:activity_type] = " #{CodetableItem.get_short_description(self.activity_type)} is already open"
            end
        end
    end

    def set_reference_id_if_required
        if self.entity_type != 6294 # supportive services
            self.reference_id = self.id
            self.save
        end
    end

    # def close_all_related_supportive_services_if_activity_status_is_set_to_closed
    #     if self.activity_status.present? && self.activity_status == 6044 && self.entity_type != 6294
    #         supportive_services = ActionPlanDetail.where("entity_type = 6294 and reference_id = ? and end_date is null", self.id)
    #         #Rails.logger.debug("supportive_services** = #{supportive_services.inspect}")
    #         supportive_services.each do |ss|
    #             #Rails.logger.debug("ss--> = #{ss.inspect}")
    #             ss.activity_status = 6044
    #             ss.end_date = self.end_date
    #             ss.outcome_code = 3093 #temporary value "other" to bypass the outcome record creation.
    #             ss.save
    #         end
    #     end
    # end

    def validate_start_date_before_update
        supportive_services = ActionPlanDetail.where("entity_type = 6294 and reference_id = ?", self.id)
        if supportive_services.present?
            lowest_supportive_service = supportive_services.order(start_date: :asc).first
            lowest_supportive_service_start_date = lowest_supportive_service.start_date
            if self.start_date > lowest_supportive_service_start_date
                errors[:start_date] << " can't be after #{CodetableItem.get_short_description(lowest_supportive_service.activity_type)} start date #{CommonUtil.format_db_date(lowest_supportive_service_start_date)}"
                return false
            else
                return true
            end
        else
            return true
        end
    end

    def validate_end_date_before_update
        supportive_services = ActionPlanDetail.where("entity_type = 6294 and reference_id = ? and end_date is not null", self.id)
        if supportive_services.present?
            highest_supportive_service = supportive_services.order(end_date: :desc).first
            highest_supportive_service_end_date = highest_supportive_service.end_date
            if highest_supportive_service_end_date.present?
               if self.end_date.present? && self.end_date < highest_supportive_service_end_date
                    errors[:end_date] << " can't be before #{CodetableItem.get_short_description(highest_supportive_service.activity_type)} end date #{CommonUtil.format_db_date(highest_supportive_service_end_date)}"
                    return false
                else
                    return true
                end
            end
        else
            supportive_services = ActionPlanDetail.where("entity_type = 6294 and reference_id = ?", self.id)
            if supportive_services.present?
                highest_supportive_service =  supportive_services.order(start_date: :desc).first
                highest_supportive_service_start_date = highest_supportive_service.start_date
                if highest_supportive_service_start_date.present?
                   if self.end_date.present? && self.end_date < highest_supportive_service_start_date
                        errors[:end_date] << " can't be before #{CodetableItem.get_short_description(highest_supportive_service.activity_type)} start date #{CommonUtil.format_db_date(highest_supportive_service_start_date)}"
                        return false
                    else
                        return true
                    end
                end
            else
                return true
            end
        end
    end

    def validate_action_plan_start_and_end_dates
       validate_start_date_before_update && validate_end_date_before_update
    end

    # def get_supportive_services
    #     ActionPlanDetail.where("reference_id = ? and entity_type = 6294", self.id)
    # end

    # action plan detail multi step form creation of data. - start

    attr_accessor :current_step,:process_object

    def steps
       %w[action_plan_detail_first action_plan_detail_second]
    end

    def current_step
      @current_step || steps.first
    end

    def next_step
      self.current_step = steps[steps.index(current_step)+1]
    end

    def previous_step
      self.current_step = steps[steps.index(current_step)-1]
    end

    def first_step?
      current_step == steps.first
    end

    def last_step?
      current_step == steps.last
    end

    def get_process_object
        self.process_object = steps[steps.index(current_step)-1]
    end

    # action plan detail multi step form creation of data. - - End


    def self.get_all_activities_for_the_client(arg_client_id)
        step1 = joins("INNER JOIN action_plans ON action_plan_details.action_plan_id = action_plans.id")
        step2 = step1.where("action_plans.client_id = ?and action_plan_details.entity_type != 6294",arg_client_id)
        step3 = step2.select("action_plan_details.*")
    end



    def perform_validations_for_component_type_job_serach_and_job_readiness
        warnings = []
        client_id = get_client_id(self.action_plan_id)
        if self.duration.present? &&  self.component_type == 6238 # "Job Search and Job Readiness"

            if self.days_of_week.present? && self.days_of_week.include?("")
                self.days_of_week.shift
            end

            warnings = jsjr_validate_for_four_consecutive_weeks

            end_date = ""
            hours_for_current_apd = 0
            weeks_remaining = 12

            start_date = get_start_date_for_jsjr
            end_date = get_end_date_for_jsjr
            # Rails.logger.debug("self.program_unit_id = #{self.program_unit_id}")
            if self.program_unit_id.present?
                child = Client.get_the_youngest_child_in_the_household(self.program_unit_id)
                if child.present?
                    self.child_id = child.id
                    self.child_dob = child.dob
                    # self.child_dob = Date.today + 23.days - 6.years
                    weeks_remaining = weeks_remaining - get_equivalent_weeks_for_the_activity
                    # Rails.logger.debug("-->weeks_remaining = #{weeks_remaining}")
                    # fail
                    # compute maximum allowable hours over one uear and compare with hours_over_one_year and populate the warning message
                    action_plan_details = get_all_action_plan_details_with_component_type_jsjr(end_date - 1.year, end_date)

                    # Rails.logger.debug("1.weeks_remaining = #{weeks_remaining}")
                    # Rails.logger.debug("-->action_plan_details = #{action_plan_details.inspect}")

                    action_plan_details.each do |apd|
                        weeks_remaining = weeks_remaining - apd.get_equivalent_weeks_for_the_activity
                        # fail
                    end

                    # Rails.logger.debug("weeks_remaining = #{weeks_remaining}")
                    # fail
                    if weeks_remaining < 0
                        warnings  << "Activity #{CodetableItem.get_short_description(self.component_type)} exceeds annual limit"
                    end
                else
                    warnings  << "Can't add this activity, there is no child in the household."
                end
            end
        end
        return warnings
    end

    def jsjr_validate_for_four_consecutive_weeks
        warnings = []
        if self.duration.to_i > 4
            warnings << "Activity #{CodetableItem.get_short_description(self.component_type)} exceeds 4 weeks"
        else
            count = (4 - self.duration.to_i) + 1
            end_date = DateService.date_of_previous("Sunday",self.start_date) - 1
            start_date = DateService.date_of_previous("Sunday",end_date)
            # Rails.logger.debug("start_date = #{start_date}")
            # Rails.logger.debug("end_date = #{end_date}")
            # Rails.logger.debug("count = #{count}")
            # fail
            occupied_count = 0
            while count > 0
                action_plan_details = get_all_action_plan_details_with_component_type_jsjr(start_date, end_date)
                # Rails.logger.debug("-->action_plan_details = #{action_plan_details.inspect}")
                # fail
                if action_plan_details.present?
                    result = action_plan_details.where("activity_status = 6043").count > 0
                    # Rails.logger.debug("result = #{result}")
                    # fail
                    if action_plan_details.where("activity_status = 6043").count > 0
                        occupied_count += 1
                    else
                        action_plan_details.each do |apd|
                            if ActivityHour.get_particiapation_hours_for_closed_activity_with_component_type_jsjr(apd.id,start_date,end_date) > 0
                                occupied_count += 1
                                break
                            end
                        end
                    end
                end
                count -= 1
                start_date -= 7
                end_date -= 7
                # fail
                # Rails.logger.debug("start_date = #{start_date}")
                # Rails.logger.debug("end_date = #{end_date}")
            end
            # Rails.logger.debug("occupied_count = #{occupied_count}")
            # Rails.logger.debug("(4 - self.duration.to_i) + 1 = #{(4 - self.duration.to_i) + 1}")
            # fail
            if occupied_count == (4 - self.duration.to_i) + 1
                warnings << "Activity #{CodetableItem.get_short_description(self.component_type)} exceeds 4 weeks"
            end
        end
        return warnings
    end

    def get_equivalent_weeks_for_the_activity
        # Rails.logger.debug("-->self = #{self.inspect}")
        start_date = get_start_date_for_jsjr
        end_date = get_end_date_for_jsjr
        if self.new_record?
            hours_for_this_activity = self.duration.to_i * self.days_of_week.count * self.hours_per_day.to_i
        else
            if self.activity_status == 6043 #open status
                if self.duration.present? && self.days_of_week.present?
                    hours_for_this_activity = self.duration.to_i * self.days_of_week.count * self.hours_per_day.to_i
                else
                   schedule = Schedule.get_schedule_info_from_action_plan_detail_id(self.id)
                    hours_for_this_activity = schedule.duration * schedule.day_of_week.count * self.hours_per_day
                end
                # Rails.logger.debug("hours_for_this_activity = #{hours_for_this_activity}")
                # Rails.logger.debug("self = #{self.inspect}")
                # fail
            else
                hours_for_this_activity = ActivityHour.get_particiapation_hours_for_closed_activity_with_component_type_jsjr(self.id, start_date, end_date)
            end
        end
        # Rails.logger.debug("hours_for_this_activity = #{hours_for_this_activity}")
        weeks_equivalent = 0
        max_allowable_hours_per_year = 0
        if self.child_dob.present?
            child_under_six = false
            child_turns_six = false
            child_age = calculate_age_by_a_given_date(self.child_dob, start_date - 1)
            # Rails.logger.debug("child_age = #{child_age}")
            hours_for_current_arg_apd = 0
            # Step1: check if there is atleast one child who will remain 6 years after the end date, if step1 fails validate step2
            # Step2: check if any of the child under six years of age will turn 6 btween the given start and end dates
            if child_age < 6
                child_under_six = true
                from_date = Date.civil(self.child_dob.year,start_date.month,start_date.day)
                to_date = end_date
                if (from_date..to_date).include?(self.child_dob)
                    if calculate_age_by_a_given_date(self.child_dob, start_date - 1) == 5 && calculate_age_by_a_given_date(self.child_dob, end_date) == 6
                        child_turns_six = true
                    end
                end
            end


            if child_under_six
                if child_turns_six # There are children who will turn six
                    week_start_date = start_date
                    week_end_date = DateService.date_of_next("Saturday", start_date)
                    week_count = 0
                    while week_end_date < end_date
                        week_count = week_count + 1
                        if (week_start_date..week_end_date).include?(self.child_dob)
                            child_turns_six = true
                            break
                        end
                        week_start_date = week_end_date + 1
                        week_end_date = week_end_date + 7
                    end
                    # Rails.logger.debug("week_count = #{week_count}")
                    if week_count < self.duration.to_i
                        # if the child turns six in between the dates compute the total number of hours possible for 1 year at this rate
                        max_allowable_hours_per_year = (((week_count * 20) + (self.duration.to_i - week_count)*30)/self.duration.to_f)*12
                        # Rails.logger.debug("max_allowable_hours_per_year = #{max_allowable_hours_per_year}")
                        # fail
                    else
                        max_allowable_hours_per_year = 240
                    end
                else
                    max_allowable_hours_per_year = 240
                end
            else
                max_allowable_hours_per_year = 360
            end
            # Rails.logger.debug("max_allowable_hours_per_year = #{max_allowable_hours_per_year}")
            # Rails.logger.debug("hours_for_this_activity = #{hours_for_this_activity}")
            weeks_equivalent = get_equivalent_weeks_from_hours(hours_for_this_activity, max_allowable_hours_per_year)
        end
        # Rails.logger.debug("weeks_equivalent = #{weeks_equivalent}")
        # fail
        return weeks_equivalent
    end

    def get_equivalent_weeks_from_hours(arg_hours_for_this_activity, arg_max_allowable_hours_per_year)
        return  (arg_hours_for_this_activity.to_f*12)/arg_max_allowable_hours_per_year.to_f
    end

    def calculate_age_by_a_given_date(arg_dob, arg_date)
        age = arg_date.year - arg_dob.year
        age -= 1 if arg_date < arg_dob + age.years
        # Rails.logger.debug("age by #{arg_date} = #{age}")
        return age
    end

    def perform_validations_for_component_type
        warnings = []
        client_id = get_client_id(self.action_plan_id)
        msg = ""
        end_date = self.start_date + (self.duration.present? ? (self.duration.to_i - 1).weeks : 0)
        if end_date.strftime("%A") != "Saturday"
            end_date = DateService.date_of_next("Saturday", end_date)
        end
        # activity_months = (self.duration.present? ? (self.duration.to_i/4.0) : 0)
        activity_months = DateService.get_number_of_reporting_months(self.start_date, end_date)
        # Rails.logger.debug("1.activity_months = #{activity_months}")
        # fail
        start_date = DateService.get_start_date_of_reporting_month(end_date)
        arg_date = end_date - 2.years
        while start_date >= arg_date
            # Rails.logger.debug("-->start_date = #{start_date}")
            # Rails.logger.debug("-->end_date = #{end_date}")
            if ActivityHour.is_there_an_activity_entry(client_id, self.component_type, start_date, end_date, self.id)
                activity_months = activity_months + 1
            end
            if start_date == arg_date
                break
            end
            end_date = start_date - 1
            start_date = DateService.get_start_date_of_reporting_month((end_date - 10))
            if start_date < arg_date
                start_date = arg_date
            end
        end
        # Rails.logger.debug("2.activity_months = #{activity_months}")
        # fail
        if activity_months > 6
            warnings << "#{CodetableItem.get_short_description(self.component_type)} Activity exceeds 6 months"
        elsif activity_months > 3 && self.component_type == 6241 # Perform 3 month limit validation only for Work Experience comp type
            warnings << "#{CodetableItem.get_short_description(self.component_type)} Activity exceeds 3 months"
        end
        return warnings
    end


    def get_client_id(arg_action_plan_id)
        result = nil
        if arg_action_plan_id.present?
            result = ActionPlan.find(arg_action_plan_id).client_id
        else
            result = self.client_id
        end
        return result
    end

    # def self.get_open_activities_for_program_unit(arg_program_unit_id)
    #     step1 = ActionPlanDetail.joins(" INNER JOIN action_plans
    #                                      ON action_plan_details.action_plan_id = action_plans.id")
    #     step2 = step1.where("action_plans.program_unit_id = ?
    #                         and action_plans.end_date is null
    #                         and action_plan_details.end_date is null",arg_program_unit_id)
    #     open_activities_collection = step2.order("action_plan_details.id ASC")
    #     return open_activities_collection
    # end

    def get_duration
        schedule = Schedule.get_schedule_info_from_action_plan_detail_id(self.id)
        duration = schedule.present? ? schedule.duration : 0
        return duration
    end


    def get_all_action_plan_details_with_component_type_jsjr(arg_start_date,arg_end_date) # jsjr - "Job Search and Job Readiness" - 6238

        client_id = get_client_id(self.action_plan_id)
        step1 = ActionPlanDetail.joins("INNER JOIN action_plans
                                        ON action_plan_details.action_plan_id = action_plans.id
                                        INNER JOIN program_units
                                        ON action_plans.program_unit_id = program_units.id")
        step2 = step1.where("program_units.id = ?
                            and action_plan_details.component_type = 6238 and action_plans.client_id = ?",self.program_unit_id,client_id)
        action_plan_details = step2.select("action_plan_details.*")
        if self.id.present?
            action_plan_details = action_plan_details.where("action_plan_details.id != ?",self.id)
        end
        # Rails.logger.debug("get_all_action_plan_details_with_component_type_jsjr action_plan_details = #{action_plan_details.inspect}")
        # fail
        step3 = []
        action_plan_details.each do |apd|
            # Rails.logger.debug("-->apd = #{apd.inspect}")
            schedule = Schedule.get_schedule_info_from_action_plan_detail_id(apd.id)
            start_date = apd.get_start_date_for_jsjr
            end_date = apd.get_end_date_for_jsjr
            if (arg_start_date..arg_end_date).cover?(start_date) || (arg_start_date..arg_end_date).cover?(end_date) || (start_date <= arg_start_date && arg_end_date <= end_date)
                step3 << apd
            end
        end
        step3 = ActionPlanDetail.where(id: step3.map(&:id)) # Converting array to activerecord relation

        return step3
    end

    def get_start_date_for_jsjr
        if self.start_date.strftime("%A") != "Sunday"
            return DateService.date_of_previous("Sunday", self.start_date)
        else
            return self.start_date
        end
    end

    def get_end_date_for_jsjr
        if self.end_date.present?
            if self.end_date.strftime("%A") != "Saturday"
                return DateService.date_of_next("Saturday", self.end_date)
            else
                return self.end_date
            end
        else
            if self.id.present?
                duration = Schedule.get_duration_for_action_plan_detail(self.id)
            else
                duration = self.duration.to_i
            end
            if (self.start_date + (duration - 1).weeks).strftime("%A") != "Saturday"
                return DateService.date_of_next("Saturday", self.start_date + (duration - 1).weeks)
            else
                return (self.start_date + (duration - 1).weeks)
            end
        end
    end

    def set_youngest_child_details_from_houshold
        if self.component_type == 6238 # Set child details only for component type Job Serach and Job Readiness
            child = Client.get_the_youngest_child_in_the_household(self.program_unit_id)
            if child.present?
                self.child_id = child.id
                self.child_dob = child.dob
            else
                errors[:base] << "No child available in the household, can't create activity with component type #{CodetableItem.get_short_description(self.component_type)}."
            end
        end
    end

    def perform_validations_for_career_and_technical_education
        warnings = []
        client_id = get_client_id(self.action_plan_id)
        start_date = DateService.get_start_date_of_reporting_month(self.start_date)
        end_date = self.start_date + (self.duration.present? ? (self.duration.to_i - 1).weeks : 0)
        # Rails.logger.debug("start_date = #{start_date}")
        # Rails.logger.debug("end_date = #{end_date}")
        if self.id.present?
            schedule = Schedule.get_schedule_info_from_action_plan_detail_id(self.id)
            selected_days = schedule.day_of_week
            if selected_days.count > 1
                end_date = DateService.date_of_next(CodetableItem.get_short_description(selected_days.last),end_date)
            end
        else
            if self.days_of_week.count > 1
                end_date = DateService.date_of_next(CodetableItem.get_short_description(self.days_of_week.last),end_date)
            end
        end
        end_date = DateService.get_end_date_of_reporting_month(end_date)
        # Rails.logger.debug("final end_date = #{end_date}")
        activity_months = DateService.get_number_of_reporting_months(start_date, end_date)
        # Rails.logger.debug("activity_months = #{activity_months}")
        # fail
        arg_date = ActivityHour.get_first_activity_date_for_career_and_education_technical_limits(client_id)
        if arg_date.present?
            arg_date = DateService.get_start_date_of_reporting_month(arg_date)
            while start_date >= arg_date
                if ActivityHour.validate_career_and_education_technical_limits(client_id, start_date, end_date, self.id)
                    activity_months = activity_months + 1
                end
                if start_date == arg_date
                    break
                end
                end_date = start_date - 1
                start_date = DateService.get_start_date_of_reporting_month((end_date - 10))
                if start_date < arg_date
                    start_date = arg_date
                end
            end
        end

        if activity_months > 12
            warnings  << "Career and technical education limits exceeds 12 months."
        end

        return warnings
    end

    def self.is_there_an_assessment_activity_created_for_the_client(arg_client_id)
        # step1 = joins("INNER JOIN action_plans
        #                ON action_plan_details.action_plan_id = action_plans.id
        #                INNER JOIN program_units
        #                ON action_plans.program_unit_id = program_units.id")

        # step1 = joins("INNER JOIN action_plans
        #                ON action_plan_details.action_plan_id = action_plans.id")
        # step1.where("action_plans.client_id = ? and action_plan_details.activity_type = 6315 ",arg_client_id).count > 0
        ActionPlan.where("action_plans.client_id = ? and action_plan_status = 6043",arg_client_id).count > 0
    end

    def self.get_all_open_activities_for_program_unit(arg_program_unit_id)
        step1 = joins("INNER JOIN action_plans
                       ON action_plan_details.action_plan_id = action_plans.id
                       INNER JOIN clients ON action_plans.client_id = clients.id")
        step2 = step1.where("action_plans.program_unit_id = ? and (action_plan_details.end_date is null)",arg_program_unit_id)
        step2.select("action_plan_details.*, (clients.last_name ||', ' || clients.first_name) as client_full_name")
    end

    def self.get_all_completed_activities_for_program_unit(arg_program_unit_id)
        step1 = joins("INNER JOIN action_plans
                       ON action_plan_details.action_plan_id = action_plans.id
                       INNER JOIN clients ON action_plans.client_id = clients.id")
        step2 = step1.where("action_plans.program_unit_id = ? and (action_plan_details.end_date is not null) and action_plans.action_plan_status = 6043",arg_program_unit_id)
        step2.select("action_plan_details.*, (clients.last_name ||', ' || clients.first_name) as client_full_name")
    end

    def self.is_the_action_plan_detail_associated_with_client(arg_client_id, arg_action_plan_detail_id)
        step1 = joins("INNER JOIN action_plans ON action_plans.id = action_plan_details.action_plan_id")
        step1.where("action_plans.client_id = ? and action_plan_details.id = ?",arg_client_id, arg_action_plan_detail_id).count > 0
    end
end