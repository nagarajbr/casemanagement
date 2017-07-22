class Schedule < ActiveRecord::Base
has_paper_trail :class_name => 'ScheduleVersion',:on => [:update, :destroy]


	include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field

    def set_create_user_fields
        user_id = AuditModule.get_current_user.uid
        self.created_by = user_id
        self.updated_by = user_id
    end

    def set_update_user_field
        user_id = AuditModule.get_current_user.uid
        self.updated_by = user_id
    end

    has_many :schedule_extensions, dependent: :destroy

	def self.get_schedule_for_action_plan_detail(arg_action_plan_detail_id)
		where("reference_id = ?",arg_action_plan_detail_id).first
	end

	validates_presence_of :entity, :reference_id, :recurring, :duration, message: "is required."
    validate :presence_of_day_of_week

    def self.get_schedule_info_from_action_plan_detail_id(arg_action_plan_detail_id)
        schedules = where("reference_id = ?",arg_action_plan_detail_id)
        if schedules.present?
            schedule = schedules.first
            return schedule
        else
            return ""
        end
    end

    def self.get_duration_for_action_plan_detail(arg_action_plan_detail_id)
        schedule = get_schedule_info_from_action_plan_detail_id(arg_action_plan_detail_id)
        if schedule.present?
            return schedule.duration
        else
            return 0
        end
    end

    def presence_of_day_of_week
        if self.recurring == 2320 #weekly
            validates_presence_of :day_of_week, message: "is required."
        end
    end

    # def self.get_schedules_info_for_given_dates_associated_with_action_plan(arg_action_plan_id, arg_start_date, arg_end_date, arg_activity_types)
    #     step1 = joins("INNER JOIN action_plan_details ON schedules.reference_id = action_plan_details.id
    #                    INNER JOIN action_plans ON action_plan_details.action_plan_id = action_plans.id")
    #     step2 = step1.where("action_plan_details.action_plan_id = ?
    #                          and (action_plan_details.start_date < ? or action_plan_details.start_date between ? and ?)
    #                          and (action_plan_details.end_date is null or (action_plan_details.end_date > ? or action_plan_details.end_date between ? and ?))
    #                          and action_plan_details.activity_type in (?)
    #                         ",arg_action_plan_id,arg_start_date, arg_start_date, arg_end_date,arg_start_date, arg_start_date, arg_end_date, arg_activity_types)
    #     step3 = step2.select("schedules.*")
    # end

    def self.get_schedules_info_for_given_dates_associated_with_program_unit(arg_program_unit_id, arg_start_date, arg_end_date, arg_activity_types)
        step1 = joins("INNER JOIN action_plan_details ON schedules.reference_id = action_plan_details.id
                       INNER JOIN action_plans ON action_plan_details.action_plan_id = action_plans.id")
        step2 = step1.where("action_plans.program_unit_id = ?
                             and (action_plan_details.start_date < ? or action_plan_details.start_date between ? and ?)
                             and ((CASE WHEN action_plan_details.end_date is null then (action_plan_details.start_date+(schedules.duration*7)-1) ELSE action_plan_details.end_date END > ?)
                                  or (CASE WHEN action_plan_details.end_date is null then (action_plan_details.start_date+(schedules.duration*7)-1) ELSE action_plan_details.end_date END between ? and ?)
                                 )
                             and action_plan_details.activity_type in (?)
                            ",arg_program_unit_id,arg_start_date, arg_start_date, arg_end_date,arg_start_date, arg_start_date, arg_end_date, arg_activity_types)
        step3 = step2.select("schedules.*")
    end
end