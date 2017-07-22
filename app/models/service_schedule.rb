class ServiceSchedule < ActiveRecord::Base
has_paper_trail :class_name => 'ServiceScheduleVersion',:on => [:update, :destroy]




  include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field

    HUMANIZED_ATTRIBUTES = {
      trip_day: "Day of the Week",
      trip_pick_up_time: "Pick Up Time",
      return_trip_pick_up_time: "Return Trip Pick Up Time"
    }

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

   #  instantiate Date service object
  # after_initialize do |obj|
  #   @l_date_object = DateService.new
  # end


   belongs_to :service_authorization
   validates_presence_of :trip_day, message: "is required."
   validate :return_pickup_time_is_after_pickup_time?

   def return_pickup_time_is_after_pickup_time?
        #Transportation schedule, should have either pick up time or return time populated.
      if (trip_pick_up_time.blank? and return_trip_pick_up_time.blank?)
          errors[:base] << "Pick up time or return trip pick up time should be selected."
          return false
      elsif (trip_pick_up_time.present? and return_trip_pick_up_time.blank?)
         return true
      elsif (return_trip_pick_up_time.present? and trip_pick_up_time.blank?)
         return true
      else
        DateService.validate_start_time_and_end_time_and_day(self,trip_day,trip_pick_up_time,return_trip_pick_up_time,"Pick Up Time","Return Pick Up Time")
      end
   end


  def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

    def self.get_schedules_sorted_by_id(arg_service_authorization_id)
    	where("service_authorization_id = ?",arg_service_authorization_id).order("id ASC")
    end

    def self.get_service_schedule_for_given_authorization_and_day(arg_service_authorization_id,arg_trip_day_name)

        case arg_trip_day_name
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

        # check if schedule is present for that day.
        service_schedule_collection = ServiceSchedule.where("service_authorization_id = ? and trip_day = ?",arg_service_authorization_id,l_trip_day)
        return service_schedule_collection

    end


    def self.get_distinct_schedule_days(arg_service_authorization_id)
      sschedule_collection = ServiceSchedule.where("service_authorization_id = ?",arg_service_authorization_id).select("distinct service_authorization_id,trip_day")
    end






end
