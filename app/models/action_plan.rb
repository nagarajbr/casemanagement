class ActionPlan < ActiveRecord::Base
has_paper_trail :class_name => 'ActionPlanVersion',:on => [:update, :destroy]
    attr_accessor :outcome_code, :outcome_notes, :plan_type

	include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field#, :validate_action_plan_start_and_end_dates#, :set_employment_readiness_plan_id
    after_update :close_all_related_action_plan_details_if_action_plan_status_is_set_to_closed

    def set_create_user_fields
        user_id = AuditModule.get_current_user.uid
        self.created_by = user_id
        self.updated_by = user_id
    end

    def set_update_user_field
        user_id = AuditModule.get_current_user.uid
        self.updated_by = user_id
    end

    HUMANIZED_ATTRIBUTES = {
    	household_id: "Household ID",
     	action_plan_type: "Type",
     	action_plan_status: "Status",
     	required_participation_hours: "Participation Hours/Week",
     	client_agreement_date: "Agreement Date",
     	start_date: "Start Date",
     	end_date: "End Date" ,
     	notes: "Notes",
        outcome_code: "Outcome",
        outcome_notes: "Outcome Notes",
        short_term_goal: "Employment Goal"

    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    has_many :action_plan_details, dependent: :destroy

    validates_presence_of :client_id,:program_unit_id,:start_date,message: "is required"
    validate :valid_end_date?, :presence_of_check_when_status_is_closed
    #validate :required_participation_hours_range,
    validate :end_date_should_be_blank_if_action_plan_status_is_open
    #validate :short_term_goal_required?
    validate :participation_hours_required?
    validate :valid_start_date?, :on => :create
    validate :valid_start_date_on_update?, :on => :update

    def short_term_goal_required?
        # Children will not be required to have an employment goal
        lb_return = true
        client_age = Client.get_age(self.client_id)
        if client_age > 0 && client_age < SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i
        else

          if short_term_goal.blank?
             errors.add(:short_term_goal, "is required")
             lb_return = false
          end

        end
         return lb_return
    end

    def participation_hours_required?
        lb_return = true
        if action_plan_type == 2976

          if required_participation_hours.blank?
             errors.add(:required_participation_hours, "is required")
             lb_return = false
          end

        end
         return lb_return
    end


    def valid_start_date?
        if start_date.present?
            if  start_date < Date.today
              errors.add(:start_date,  "must be greater than or equal to #{(Date.today).strftime("%m/%d/%Y")}")
              return false
            else
                return true
            end
        else
            return true
        end
    end
    def valid_start_date_on_update?
        if start_date.present?
            if  start_date < created_at.to_date
              errors.add(:start_date,  "must be greater than or equal to #{(created_at.to_date).strftime("%m/%d/%Y")}")
              return false
            else
                return true
            end
        else
            return true
        end

    end

    def valid_end_date?
        DateService.valid_date?(self,end_date,"End date")
    end

    # def start_date_less_than_end_date?
    #     DateService.begin_date_cannot_be_greater_than_end_date?(self,start_date,end_date,"Start date","End date")
    # end

    def self.get_action_plans(arg_client_id, arg_program_unit_id, arg_plan_type)
    	where("client_id = ? and program_unit_id = ? and action_plan_type = ?",arg_client_id, arg_program_unit_id, arg_plan_type).order("id DESC")
    end


    def presence_of_check_when_status_is_closed
        if action_plan_status == 6044
            if outcome_code.blank?
                errors[:outcome_code] << " is required when plan is closed"
            end
        end
    end

    def required_participation_hours_range
        li_required_participation_hours = self.required_participation_hours
    	if li_required_participation_hours.present?
    		unless (0..50).include?(li_required_participation_hours)
    		 	errors[:required_participation_hours] << " should be between 0 and 50"
    		end
    	end
    end

    def validate_start_date_before_update
        if self.action_plan_details.present?
            lowest_action_plan_detail = self.action_plan_details.order(start_date: :asc).first
            lowest_action_plan_detail_start_date = lowest_action_plan_detail.start_date
            if self.start_date > lowest_action_plan_detail_start_date
                errors[:start_date] << " can't be after #{CodetableItem.get_short_description(lowest_action_plan_detail.activity_type)} start date #{CommonUtil.format_db_date(lowest_action_plan_detail_start_date)}"
                return false
            else
                return true
            end
        else
            return true
        end
    end

    def validate_end_date_before_update
        if self.action_plan_details.present?
            highest_action_plan_details = self.action_plan_details.where("end_date is not null").order(end_date: :desc)
            if highest_action_plan_details.present?
                highest_action_plan_detail = highest_action_plan_details.first
                highest_action_plan_detail_end_date = highest_action_plan_detail.end_date
                if highest_action_plan_detail_end_date.present?
                   if self.end_date.present? && self.end_date < highest_action_plan_detail_end_date
                        errors[:end_date] << " can't be before #{CodetableItem.get_short_description(highest_action_plan_detail.activity_type)} end date #{CommonUtil.format_db_date(highest_action_plan_detail_end_date)}"
                        return false
                    else
                        return true
                    end
                end
            else
                highest_action_plan_details = self.action_plan_details.order(start_date: :desc)
                if highest_action_plan_details.present?
                    highest_action_plan_detail = highest_action_plan_details.first
                    highest_action_plan_detail_start_date = highest_action_plan_detail.start_date
                    if highest_action_plan_detail_start_date.present?
                       if self.end_date.present? && self.end_date < highest_action_plan_detail_start_date
                            errors[:end_date] << " can't be before #{CodetableItem.get_short_description(highest_action_plan_detail.activity_type)} end date #{CommonUtil.format_db_date(highest_action_plan_detail_start_date)}"
                            return false
                        else
                            return true
                        end
                    end
                else
                    return true
                end
            end
        else
            return true
        end
    end

    def validate_action_plan_start_and_end_dates
        # start_date_validation = validate_start_date_before_update
        # end_date_validation = validate_end_date_before_update
        validate_start_date_before_update && validate_end_date_before_update
    end

    def close_all_related_action_plan_details_if_action_plan_status_is_set_to_closed
        ls_action_plan_status = self.action_plan_status
        if  ls_action_plan_status.present? && ls_action_plan_status == 6044
            action_plan_details = self.action_plan_details
            action_plan_details = action_plan_details.where("end_date is null and entity_type != 6294")
            action_plan_details.each do |apd|
                if apd.activity_status != 6044
                    apd.activity_status = 6044
                    apd.end_date = self.end_date
                    apd.outcome_code = 3093 #temporary value "other" to bypass the outcome record creation.
                    apd.save
                end
            end
        end
    end

    def end_date_should_be_blank_if_action_plan_status_is_open
            ls_action_plan_status = self.action_plan_status
        if ls_action_plan_status.present? && ls_action_plan_status == 6043 # open status
            unless self.end_date.blank?
                errors[:base] = "End Date should be blank when action plan status is open"
            end
        end
    end

    def self.is_there_an_open_action_plan_for_the_program_unit(arg_program_unit_id, arg_plan_type,arg_client_id)
        where("program_unit_id = ? and action_plan_status = 6043 and action_plan_type = ? and client_id = ?", arg_program_unit_id, arg_plan_type,arg_client_id).count > 0
    end

    def self.get_all_open_action_plans_for_the_program_unit(arg_program_unit_id)
        where("program_unit_id = ? and action_plan_status = 6043", arg_program_unit_id)
    end

    # def self.get_all_open_action_plans_for_the_client(arg_client_id)
    #     where("client_id = ? and action_plan_status = 6043",arg_client_id)
    # end

    def self.get_open_action_plan(arg_program_unit_id, arg_client_id)
        result = where("program_unit_id = ? and client_id = ? and action_plan_status = 6043",arg_program_unit_id, arg_client_id)
        result = result.first if result.present?
        return result
    end

    def self.process_workpays_payment_line_item(arg_client_id,arg_activity_month)
         # Author : Manoj Patil
        # Date : 04/08/2015
        # logger.debug("process_workpays_payment_line_item")
        # description : Called from Activity Hours save screen.
        ldt_payment_date = "#{arg_activity_month.year}-#{arg_activity_month.month}-01"
        ldt_payment_date = ldt_payment_date.to_date
        lb_create_wp_payment_line_item = false
        # get the latest open program unit.
      step1 = ProgramUnitParticipation.joins("INNER JOIN program_units
                                                ON (program_unit_participations.program_unit_id = program_units.id
                                                    and program_units.service_program_id = 4 )
                                            INNER JOIN program_unit_members
                                            ON program_unit_members.program_unit_id = program_units.id
                                            ")
        step2 = step1.where("program_unit_members.client_id = ?",arg_client_id)
        step3 = step2.where("program_unit_participations.id = (select max(a.id) from program_unit_participations as a where a.program_unit_id = program_units.id )")
        step4 = step3.where("program_unit_participations.participation_status = 6043")
        latest_open_pgu_collection = step4
        if latest_open_pgu_collection.present?
            # logger.debug("process_workpays_payment_line_item - latest_open_pgu_collection.present? is true")
            # Open PGU found Proceed.
            #  Check if payment record already found.
            participation_object = latest_open_pgu_collection.first
            l_program_unit_id = participation_object.program_unit_id
             # check if payment line item is already created .
                program_unit_object = ProgramUnit.find(l_program_unit_id)
                if program_unit_object.service_program_id == 4
                   step1 = PaymentLineItem.where("line_item_type = 6176 and payment_type = 5760 and reference_id = ? and payment_date = ?",l_program_unit_id,ldt_payment_date)
                   payment_line_item_collection =  step1
                   if payment_line_item_collection.blank?
                        # Payment record not found - proceed with creating
                         # get the latest submitted ED.
                        ed_collection = ProgramWizard.where("program_unit_id = ? and submit_date is not null",l_program_unit_id).order("submit_date DESC")
                        if ed_collection.present?

                            ed_object = ed_collection.first
                             program_benefit_detail_collection = ProgramBenefitDetail.get_program_benefit_detail_collection(ed_object.run_id,ed_object.month_sequence)
                            if program_benefit_detail_collection.present?
                                 lb_create_wp_payment_line_item = true
                                 ld_program_benefit_amount = program_benefit_detail_collection.first.program_benefit_amount
                                 payment_return_object = PaymentLineItem.set_payment_line_item_object(l_program_unit_id,
                                                                                                     ldt_payment_date,
                                                                                                     6176,
                                                                                                     5760,
                                                                                                     arg_client_id,
                                                                                                     6172,
                                                                                                     ld_program_benefit_amount,
                                                                                                     6191 ,
                                                                                                     ed_object.run_id,
                                                                                                     6201)

                                begin
                                    ActiveRecord::Base.transaction do
                                        payment_return_object.save!
                                    end
                                    msg = "SUCCESS"
                                rescue => err
                                  # logger.debug("in exception  - #{err.inspect}")
                                  error_object = CommonUtil.write_to_attop_error_log_table("In ProgramUnit- Model","Method Name: approve_program_unit",err,AuditModule.get_current_user.uid)
                                  msg = "Failed to submit workpays payment - for more details refer to error ID: #{error_object.id}."
                                end
                            end # end of     program_benefit_detail_collection.present?
                        end
                   end
                end

        end

        if lb_create_wp_payment_line_item == false
           msg = "NOTHING_TO_PROCESS"
        end



        # 1. "SUCCESS" -means - payment line item create successfully
        # 2. "Failed to create Payment line item for Workpays."- means - need to create payment line item - failed to create one.
        # 3. "NOTHING_TO_PROCESS" -means - No need to create payment line item.
       # logger.debug("process_workpays_payment_line_item -msg = #{msg}")
         return msg
    end



    def self.can_create_workpays_payment?(arg_activity_hours_id,arg_client_id,arg_activity_date)
        # Author : Manoj Patil
        # Date : 04/08/2015
        # 1.This is called from activity hours data entry save.
        # Rule : If Last week activity time entry for all activities of workpays client  are completed - WP Payment line items are created.

        # Description:
        # Goal : If 4/5 weeks time entry is completed , then add payment line item - incentive for submitting Timesheets on time.
        # If Time entry for all activities (Action Plan details) for client is completed
        # when last activity date of month activity time is entered & all other activity time entry is done for the activity month
        # Payment is submitted.

        lb_return = false

        # logger.debug("Is there Open WP Program Unit present")
        # Check if Open Workpays program unit is present?
        # Rule: Client should be in Open Workpays program unit to proceed.
        step1 = ProgramUnitParticipation.joins("INNER JOIN program_units
                                                ON (program_unit_participations.program_unit_id = program_units.id
                                                    and program_units.service_program_id = 4 )
                                            INNER JOIN program_unit_members
                                            ON program_unit_members.program_unit_id = program_units.id
                                            ")
        step2 = step1.where("program_unit_members.client_id = ?",arg_client_id)
        step3 = step2.where("program_unit_participations.id = (select max(a.id) from program_unit_participations as a where a.program_unit_id = program_units.id )")
        step4 = step3.where("program_unit_participations.participation_status = 6043")
        latest_open_pgu_collection =  step4
        if latest_open_pgu_collection.present?
            lb_return = true
        end

      if lb_return == true
        # Open Workpays program unit found - so proceed ..
        ldt_today = Date.today

        # # 1. Is the current activity hour entry Last scheduled working day in last week of the month?
        # # from schedule find the Last Day of week he will be entring Time.
        activity_hour_object = ActivityHour.find(arg_activity_hours_id)
        l_activity_plan_detail_id = activity_hour_object.action_plan_detail_id

        # Check if the arg_activity_date is in Last week of the month.
        # Last date of month.

       # Activity Month is last_activity_date - 4
       # This will make sure activity month is pushed to previous month - when last day of week is next month.
       # example : April-2015 - 5th week last date - 05/02/2015 -
       # Detrmine Activity - Month & Year based on activity date
        l_activity_month =  arg_activity_date - 4
        l_month = l_activity_month.month
        l_year = l_activity_month.year
        ldt_last_day_date_of_month = Date.civil(l_year, l_month, -1)
        last_day_name = ldt_last_day_date_of_month.strftime("%A").upcase
        # week = sunday to saturday
        # For Reporting Month : Determing Last week start date & Last week end date
        case last_day_name
        when "SUNDAY"
            # example :Activity month: Jan-2016
            # ldt_last_day_date_of_month = 01/31/2016
            # last_day_name for 01/31/2016 = SUNDAY
            # ldt_last_week_start_date = 01/24/2016 (SUNDAY)
            # ldt_last_week_end_date = 01/30/2016 (SATURDAY)
          ldt_last_week_start_date = ldt_last_day_date_of_month - 7
          ldt_last_week_end_date = ldt_last_day_date_of_month - 1

        when "MONDAY"
            # example :Activity month: aUG-2015
            # ldt_last_day_date_of_month = 08/31/2015
            # last_day_name for 08/31/2015 = MONDAY
            # ldt_last_week_start_date = 08/23/2015 (SUNDAY)
            # ldt_last_week_end_date = 08/29/2015 (SATURDAY)
            ldt_last_week_start_date = ldt_last_day_date_of_month - 8
            ldt_last_week_end_date = ldt_last_day_date_of_month - 2
        when "TUESDAY"
             # example :Activity month: June-2015
            # ldt_last_day_date_of_month = 06/30/2015
            # last_day_name for 08/31/2015 = TUESDAY
            # ldt_last_week_start_date = 06/21/2015 (SUNDAY)
            # ldt_last_week_end_date = 06/27/2015 (SATURDAY)
            ldt_last_week_start_date = ldt_last_day_date_of_month - 9
            ldt_last_week_end_date = ldt_last_day_date_of_month - 3
        when "WEDNESDAY"
            # example :Activity month: Sep-2015
            # ldt_last_day_date_of_month = 09/30/2015
            # last_day_name for 09/30/2015 = WEDNESDAY
            # ldt_last_week_start_date = 09/27/2015 (SUNDAY)
            # ldt_last_week_end_date = 10/03/2015 (SATURDAY)
           ldt_last_week_start_date = ldt_last_day_date_of_month - 3
            ldt_last_week_end_date = ldt_last_day_date_of_month + 3
        when "THURSDAY"
            # example :Activity month: April-2015
            # ldt_last_day_date_of_month = 04/30/2015
            # last_day_name for 04/30/2015 = THURSDAY
            # ldt_last_week_start_date = 04/26/2015 (SUNDAY)
            # ldt_last_week_end_date = 05/02/2015 (SATURDAY)
            ldt_last_week_start_date = ldt_last_day_date_of_month - 4
            ldt_last_week_end_date = ldt_last_day_date_of_month + 2
        when "FRIDAY"
            # example :Activity month: July-2015
            # ldt_last_day_date_of_month = 07/31/2015
            # last_day_name for 07/31/2015 = FRIDAY
            # ldt_last_week_start_date = 07/26/2015 (SUNDAY)
            # ldt_last_week_end_date = 08/01/2015 (SATURDAY)
           ldt_last_week_start_date = ldt_last_day_date_of_month - 5
            ldt_last_week_end_date = ldt_last_day_date_of_month + 1
        when "SATURDAY"
            # example :Activity month: Oct-2015
            # ldt_last_day_date_of_month = 10/31/2015
            # last_day_name for 10/31/2015 = SATURDAY
            # ldt_last_week_start_date = 10/25/2015 (SUNDAY)
            # ldt_last_week_end_date = 10/31/2015 (SATURDAY)
          ldt_last_week_start_date = ldt_last_day_date_of_month - 6
          ldt_last_week_end_date = ldt_last_day_date_of_month + 0
        end



        # logger.debug("arg_activity_date = #{arg_activity_date.inspect}")
        # logger.debug("l_activity_month = #{l_activity_month.inspect}")
        # logger.debug("ldt_last_week_start_date = #{ldt_last_week_start_date.inspect}")
        # logger.debug("ldt_last_week_end_date = #{ldt_last_week_end_date.inspect}")


            # Get all distinct open activity details for the client
             step1 = ActionPlanDetail.joins("INNER JOIN action_plans
                                            ON action_plan_details.action_plan_id = action_plans.id
                                           ")
             step2 = step1.where("(action_plans.end_date is null OR action_plans.end_date > ?)
                                  and   (action_plan_details.end_date is null OR action_plans.end_date > ?)
                                  and (action_plans.client_id = ?)
                                 ",ldt_today,ldt_today,arg_client_id)
            step3 = step2.select("distinct action_plan_details.*")
            action_plan_details_collection = step3

            # check if all activity hours are entered -when saving one of the last activity day of month.
            # if all activity hours are entered - create payment record.
            if action_plan_details_collection.present?
                    action_plan_details_collection.each do |each_action_plan_detail|
                    # get the last week day as per schedule for each activity
                    schedule_collection = Schedule.where("reference_id = ?",each_action_plan_detail.id)
                    schedule_object = schedule_collection.first
                    day_of_week_array = schedule_object.day_of_week
                    last_day = day_of_week_array.last
                    last_day_name = CodetableItem.get_short_description(last_day)
                    last_day_name = last_day_name.upcase

                    if ( arg_activity_date >= ldt_last_week_start_date && arg_activity_date <= ldt_last_week_end_date )

                            # Last day as per schedule should be completed.
                            # Example : ACtivity month : Apr-2015
                            case last_day_name
                            when "SUNDAY"
                                # 04/26/2015 is the last working day if sunday is last day in the schedule
                              last_scheduled_work_date = ldt_last_week_start_date
                            when "MONDAY"
                                # 04/27/2015 is the last working day if monday is last day in the schedule
                               last_scheduled_work_date = ldt_last_week_start_date + 1
                            when "TUESDAY"
                                 # 04/28/2015 is the last working day if tuesday is last day in the schedule
                               last_scheduled_work_date = ldt_last_week_start_date + 2
                            when "WEDNESDAY"
                                 # 04/29/2015 is the last working day if WEDNESDAY is last day in the schedule
                              last_scheduled_work_date = ldt_last_week_start_date + 3
                            when "THURSDAY"
                                 # 04/30/2015 is the last working day if Thursday is last day in the schedule
                             last_scheduled_work_date = ldt_last_week_start_date + 4
                            when "FRIDAY"
                                 # 05/01/2015 is the last working day if FRIDAY is last day in the schedule
                              last_scheduled_work_date = ldt_last_week_start_date + 5
                            when "SATURDAY"
                                  # 05/02/2015 is the last working day if saturday is last day in the schedule
                              last_scheduled_work_date = ldt_last_week_start_date + 6
                            end

                             # logger.debug("last_scheduled_work_date = #{last_scheduled_work_date.inspect}")

                            activity_hours_completed_collection = ActivityHour.where("action_plan_detail_id = ? and activity_date = ?",each_action_plan_detail.id,last_scheduled_work_date)
                            if activity_hours_completed_collection.present?
                                lb_return = true
                            else
                                # activity hours data entry is not completed -so set to false
                                lb_return = false
                                break
                            end
                    else
                         lb_return = false
                    end # end of arg_date in last week check.
                end # end of action_plan_details_collection.each
            else
                 lb_return = false
            end

        end # end of lb_return == true



         # logger.debug("lb_return of can_create_workpays_payment? = #{lb_return}")
        return lb_return

    end

    def self.an_open_action_plan_exist(arg_client_id)
        where("client_id = ? and action_plan_status = 6043",arg_client_id).count > 0
    end

    def self.get_latest_action_plan(arg_client_id)
        where("client_id = ? and action_plan_status = 6044 and end_date is not null", arg_client_id).order("id  desc").first
    end

    def self.get_earliest_action_plan_start_date_for_the_program_unit(arg_program_unit_id, arg_date)
        result = where("program_unit_id = ? and start_date >= ?", arg_program_unit_id,arg_date).order(:start_date)
        result = result.first.start_date if result.present?
        return result
    end

    def self.get_open_action_plan_for_client(arg_client_id)
        result = where("client_id = ? and action_plan_status = 6043", arg_client_id)
        result = result.first if result.present?
        return result
    end

    def self.get_action_plan_without_program_unit_id(arg_client_id)
        action_plans = where("client_id = ? and program_unit_id = 0 and action_plan_status = 6043", arg_client_id)
        action_plan = action_plans.present? ? action_plans.first : nil
        return action_plan
    end

    def self.is_program_unit_having_open_actions(arg_program_unit_id)
        action_plans = where("program_unit_id = ? and action_plan_status = 6043 and end_date is null",arg_program_unit_id)
        if action_plans.length > 0
            return true
        else
            return false
        end
    end
end
