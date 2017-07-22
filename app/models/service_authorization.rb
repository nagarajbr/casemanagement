class ServiceAuthorization < ActiveRecord::Base
has_paper_trail :class_name => 'ServiceAuthorizationVersion',:on => [:update, :destroy]


  include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field


    has_many :service_schedules, dependent: :destroy
    has_many :service_authorization_line_items, dependent: :destroy


    attr_accessor :distance, :average_service_cost, :total_service_cost,:check_ts_nts,:non_transport_service

    def get_trip_start_address
      start_address = ""
      if self.trip_start_address_line1.present?
        start_address = self.trip_start_address_line1
        if self.trip_start_address_line2.present?
          start_address = start_address + ", " + self.trip_start_address_line2
        end
        start_address = start_address + ", " + self.trip_start_address_city + ", "
        start_address = start_address + CodetableItem.get_short_description(self.trip_start_address_state) + "-" + self.trip_start_address_zip.to_s
      end
    end

    def get_trip_end_address
      start_address = ""
      if self.trip_end_address_line1.present?
        start_address = self.trip_end_address_line1
        if self.trip_end_address_line2.present?
          start_address = start_address + ", " + self.trip_end_address_line2
        end
        start_address = start_address + ", " + self.trip_end_address_city + ", "
        start_address = start_address + CodetableItem.get_short_description(self.trip_end_address_state) + "-" + self.trip_end_address_zip.to_s
      end
    end

    HUMANIZED_ATTRIBUTES = {
      provider_id: "Provider",
      program_unit_id: "Program Unit ID",
      barrier_id: "Barrier",
      service_start_date: "Service Start Date",
      service_end_date: "Service End Date",
      trip_start_address_line1: "Start Address line1",
      trip_start_address_line2: "Start Address line2",
      trip_start_address_city: "Start Address City",
      trip_start_address_state: "Start Address State",
      trip_start_address_zip: "Start Address Zip",
      trip_end_address_line1: "End Address line1",
      trip_end_address_line2: "End Address line2",
      trip_end_address_city: "End Address City",
      trip_end_address_state: "End Address State",
      trip_end_address_zip: "End Address Zip",
      notes: "Notes",
      service_type: "Supportive Service",
      service_date: "Service Date",
      # activity_type: "Activity",
      action_plan_detail_id: "Activity"
    }

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

   #  instantiate Date service object
  # after_initialize do |obj|
  #   @l_date_object = DateService.new
  # end


  # validates_presence_of :barrier_id, :service_start_date, :service_end_date, message: "is required"
  # validates_presence_of :barrier_id, message: "is required"


  # validate :valid_if_service_type_is_transportation
  validate :valid_if_check_ts_nts_is_yes
  validate :valid_transportation_first_step
  validate :valid_transportation_second_step
  validate :valid_transportation_last_step
  validate :valid_non_transportation_service
  validate :valid_start_date?,:valid_end_date?,:start_date_less_than_end_date?,:valid_service_date?,:valid_nts_service_date?
  validate :validate_supportive_service_start_date_should_be_greater_or_equal_to_activity_start_date

  validates_uniqueness_of :service_type, :scope => [:action_plan_detail_id]

  # REvisit Later - Manoj 02/28/2015 - start
  # validate :validate_no_overlapping_dates, :on => :create
  # validate :validate_no_overlapping_dates_update, :on => :update
  # REvisit Later - Manoj 02/28/2015 - end


  def valid_start_date?
    lb_return = true
    if service_type == 6215 && process_object == "service_authorizations_details_first"
      lb_return = DateService.valid_date?(self,service_start_date,"Service start date")
    end
    return lb_return
  end

  def valid_service_date?
     lb_return = true
    if check_ts_nts == "Y"
         lb_return = DateService.valid_date?(self,service_date,"Service date")
    end
    return lb_return
  end

  def valid_nts_service_date?
     lb_return = true

     if service_type != 6215 && non_transport_service == "Y"
         lb_return = DateService.valid_date?(self,service_date,"Service date")
    end
    return lb_return

  end

  def valid_end_date?
    lb_return = true
    if service_type == 6215 && process_object == "service_authorizations_details_first"
      lb_return = DateService.valid_date?(self,service_end_date,"Service end date")
    end
    return lb_return
  end

  def start_date_less_than_end_date?
      lb_return = true
    if service_type == 6215 && process_object == "service_authorizations_details_first"
     DateService.begin_date_cannot_be_greater_than_end_date?(self,service_start_date,service_end_date,"Service start date","Service end date")
    end
    return lb_return
  end






 def valid_if_check_ts_nts_is_yes
    lb_return = true
    if check_ts_nts == "Y"

      if service_type.blank?
         errors.add(:service_type, "is required.")
         lb_return = false
      end
       if service_date.blank?
         errors.add(:service_date, "is required.")
         lb_return = false
      end
    end
     return lb_return
 end

 def valid_transportation_first_step
   lb_return = true
  if service_type == 6215 && process_object == "service_authorizations_details_first"
    if service_start_date.blank?
      errors.add(:service_start_date, "is required.")
      lb_return = false
    end

    if service_end_date.blank?
      errors.add(:service_end_date, "is required.")
      lb_return = false
    end
  end
  return lb_return
 end

 def valid_non_transportation_service
    lb_return = true
    if service_type != 6215 && non_transport_service == "Y"
      if id.present?
        # EDit operation
        if service_date.blank?
          errors.add(:service_date, "is required.")
          lb_return = false
        end

         if service_type.blank?
          errors.add(:service_type, "is required.")
          lb_return = false
        end

      end
      # Check both in New & Edit operation
      if provider_id.blank?
        errors.add(:provider_id, "is required.")
        lb_return = false
      end
    end
    return lb_return
 end

 def valid_transportation_last_step

  lb_return = true
    if (service_type == 6215 && current_step == "service_authorizations_review_last")
       if provider_id.blank?

        errors.add(:provider_id, "is required.")
        lb_return = false
      end
    end

    return lb_return
 end

 def valid_transportation_second_step
   lb_return = true
   if service_type == 6215 && process_object == "service_authorizations_details_second"
      if trip_start_address_line1.blank?
         errors.add(:trip_start_address_line1, "is required.")
         lb_return = false
      end

      if trip_start_address_city.blank?
         errors.add(:trip_start_address_city, "is required.")
         lb_return = false
      end

      if trip_start_address_state.blank?
         errors.add(:trip_start_address_state, "is required.")
         lb_return = false
      end

      if trip_start_address_zip.blank?
         errors.add(:trip_start_address_zip, "is required.")
         lb_return = false
      end

      if trip_end_address_line1.blank?
         errors.add(:trip_end_address_line1, "is required.")
         lb_return = false
      end

      if trip_end_address_city.blank?
         errors.add(:trip_end_address_city, "is required.")
         lb_return = false
      end

      if trip_end_address_state.blank?
         errors.add(:trip_end_address_state, "is required.")
         lb_return = false
      end

      if trip_end_address_zip.blank?
         errors.add(:trip_end_address_zip, "is required.")
         lb_return = false
      end

   end
   return lb_return
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


    #Manoj 12/09/2014
    # Service Authorization - Multi step form creation of data. - start
    # attr_writer :current_step,:process_object
    attr_accessor :current_step,:process_object

    def steps
      %w[service_authorizations_details_first service_authorizations_details_second service_authorizations_schedule_third service_authorizations_review_last]
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


    # Service Authorization - Multi step form creation of data. - End


	# def self.get_service_authorization_list_for_client_id_and_program_unit_id(arg_client_id,arg_program_unit_id)
	# 	where("client_id = ? and program_unit_id = ?",arg_client_id,arg_program_unit_id).order("id DESC")
	# end


  def self.can_authorize_service(arg_service_authorization_id)
    #  Rule 1: Service schedule should be populated.
    #  Rule 2 : Service Status should be complete.
    #  Rule 3 : No service line items with Ready to be invoiced or Invoiced status found.
    service_authorization_object = ServiceAuthorization.find(arg_service_authorization_id)
    if service_authorization_object.status == 6161 || service_authorization_object.status == 6162
      # Only completed and authorized services can be AUthorized.
       ls_out = "Y"
    else
       ls_out = "N"
    end

    if ls_out == "Y"
      service_schedule_collection = ServiceSchedule.where("service_authorization_id = ?",arg_service_authorization_id)
      if service_schedule_collection.present?
         ls_out = "Y"
      else
         ls_out = "N"
      end
    end

    if ls_out == "Y"
      any_invoice_done_on_this_service_authorization_collection = ServiceAuthorizationLineItem.where("service_authorization_id = ? and line_item_status in (6169,6170)",arg_service_authorization_id)
      if any_invoice_done_on_this_service_authorization_collection.present?
         ls_out = "N"
      else
        ls_out = "Y"
      end
    end


    return ls_out

  end


  def self.authorize_service_and_create_invoice_line_items(arg_service_authorization_id, arg_trip_distance)
    # 1. Populate service_authorization_line_items
    #  Delete
    ServiceAuthorizationLineItem.where("service_authorization_id = ?",arg_service_authorization_id).destroy_all
    # Insert
    msg = "SUCCESS"
    service_authorization_object = ServiceAuthorization.find(arg_service_authorization_id)
      ldt_start_service_date = service_authorization_object.service_start_date
      ldt_service_date = ldt_start_service_date
      ldt_end_date = service_authorization_object.service_end_date
        # logger.debug("Service start Date =  #{ldt_start_service_date}")
       # logger.debug("Service End Date =  #{ldt_end_date}")
      while ldt_service_date <=  ldt_end_date
        # logger.debug("Service Date =  #{ldt_service_date}")
        msg = ServiceAuthorization.create_service_authorization_line_item_for_service_date(arg_service_authorization_id,ldt_service_date, arg_trip_distance)
        if msg != "SUCCESS"
          break
        end
        ldt_service_date = ldt_service_date + 1
      end
      return msg
  end

  def self.create_service_authorization_line_item_for_service_date(arg_service_authorization_id,arg_srvc_date, arg_trip_distance)
       # logger.debug("Inside  create_service_authorization_line_item_for_service_date")
       msg = "SUCCESS"
       ls_day_name = arg_srvc_date.strftime("%^A") # Day name - SUNADY/MONDAY for service date.
       service_schedule_for_a_day_collection = ServiceSchedule.get_service_schedule_for_given_authorization_and_day(arg_service_authorization_id,ls_day_name)
      if service_schedule_for_a_day_collection.present?
          service_schedule_object = service_schedule_for_a_day_collection.first
           if service_schedule_object.trip_pick_up_time.present?
          msg = ServiceAuthorization.create_service_authorization_line_item_per_trip(arg_service_authorization_id,arg_srvc_date,service_schedule_object.id,service_schedule_object.trip_pick_up_time, arg_trip_distance)
          end
          if service_schedule_object.return_trip_pick_up_time.present?
            msg = ServiceAuthorization.create_service_authorization_line_item_per_trip(arg_service_authorization_id,arg_srvc_date,service_schedule_object.id,service_schedule_object.return_trip_pick_up_time, arg_trip_distance)
          end
      end
      return msg
  end

  def self.create_service_authorization_line_item_per_trip(arg_service_authorization_id,arg_service_date,arg_schedule_id,arg_trip_start_time, arg_trip_distance)
         # logger.debug("Inside  create_service_authorization_line_item_per_trip")
        service_authorization_object = ServiceAuthorization.find(arg_service_authorization_id)
        service_schedule_object = ServiceSchedule.find(arg_schedule_id)

        service_authorization_line_item_object = ServiceAuthorizationLineItem.new

        service_authorization_line_item_object.service_authorization_id = service_schedule_object.service_authorization_id
        service_authorization_line_item_object.service_date = arg_service_date
        service_authorization_line_item_object.service_begin_time = arg_trip_start_time
        service_authorization_line_item_object.trip_start_address_line1 = service_authorization_object.trip_start_address_line1
        service_authorization_line_item_object.trip_start_address_line2 = service_authorization_object.trip_start_address_line2
        service_authorization_line_item_object.trip_start_address_city = service_authorization_object.trip_start_address_city
        service_authorization_line_item_object.trip_start_address_state = service_authorization_object.trip_start_address_state
        service_authorization_line_item_object.trip_start_address_zip = service_authorization_object.trip_start_address_zip
        service_authorization_line_item_object.trip_end_address_line1 = service_authorization_object.trip_end_address_line1
        service_authorization_line_item_object.trip_end_address_line2 = service_authorization_object.trip_end_address_line2
        service_authorization_line_item_object.trip_end_address_city = service_authorization_object.trip_end_address_city
        service_authorization_line_item_object.trip_end_address_state = service_authorization_object.trip_end_address_state
        service_authorization_line_item_object.trip_end_address_zip = service_authorization_object.trip_end_address_zip
        service_authorization_line_item_object.quantity = arg_trip_distance # for testing 5 miles is hard coded - it will be the distance in miles when start address and end address is returned from -Mapquest -from address - to address web service.
         service_authorization_line_item_object.actual_quantity = arg_trip_distance
        service_authorization_line_item_object.unit_of_measure = 6158 # Miles
        # ld_estimated_cost = calculate_trip_cost(arg_service_date, service_authorization_line_item_object.quantity,service_authorization_line_item_object.service_begin_time)
        ld_estimated_cost = calculate_trip_cost(arg_service_date,arg_trip_distance,arg_trip_start_time) # hard coded will be removed.
        service_authorization_line_item_object.estimated_cost = ld_estimated_cost
        service_authorization_line_item_object.actual_cost = ld_estimated_cost
        service_authorization_line_item_object.line_item_status =  6369 ## generated. old code -6168
        if service_authorization_line_item_object.save
          msg = "SUCCESS"
        else
          msg = service_authorization_line_item_object.errors.full_messages.last
        end
        return msg
  end


def self.calculate_trip_cost(arg_service_date,arg_miles,arg_service_time)
        # flat_rate =
        #  estimated_cost = Miles * mileage_rate + flat_rate

#         Rules
#         Hours Rate Summary Hours Defined
# Regular Business Hours (Weekday)
# $15.00 Flat Rate + State Mileage Rate
# $15.00 flat rate plus current state mileage reimbursement rate per mile for distance traveled
# Regula Hours = Any trip* that originates after 6am or before 6 pm – Monday through Friday
# After Hours = (Weeknight)  $20.00 flat rate plus current state mileage reimbursement rate per mile for distance traveled
# Any trip that originates before 6 am or after 6 pm – Monday through Friday

# Weekend
# $25.00 flat rate plus current state mileage reimbursement rate per mile for distance traveled
# Any trip that originates after 6 pm on Friday through 6 am on Monday

# No Shows $15.00 Flat Rate $15.00 Flat Rate





  # step 3 : what rate applies ? weekend/weekday/regular hours/after hours

  # 4 categories
  # category 1 : Regular Business Hours (Weekday)
  # category 2 : After Hours (Weeknight)
  # category 3 : Weekend

   # step1 : Determine - Day of the week.
  # ls_day_name =  arg_date.strftime("%^A")
  # # Step 2 : time of service ?
  # lt_srvc_begin_time = arg_pickup_time
  # if (ls_day_name == "MONDAY" || ls_day_name == "TUESDAY" || ls_day_name == "WEDNESDAY" || ls_day_name == "THURSDAY" || ls_day_name == "FRIDAY" ) && (lt_srvc_begin_time >= )
  falt_rate = 0
  # state_mileage_rate = SystemParam.find(876).value.to_i
  state_mileage_rate = SystemParam.find(876).value.to_f

  ls_day_name =  arg_service_date.strftime("%^A")

  case determine_type_of_hours(ls_day_name,arg_service_time)
  when "REGULAR"
    flat_rate = SystemParam.find(872).value.to_f
  when "WEEKNIGHT"
    flat_rate = SystemParam.find(873).value.to_f
  when "WEEKEND"
    flat_rate = SystemParam.find(874).value.to_f
  end
  estimated_cost = arg_miles * state_mileage_rate + flat_rate
  return estimated_cost
end

def self.determine_type_of_hours(arg_day,arg_service_time)
  result = "None"
  is_it_regular_hours_of_the_day = is_it_regular_hours(arg_service_time)
    if (arg_day == "MONDAY" || arg_day == "TUESDAY" || arg_day == "WEDNESDAY" || arg_day == "THURSDAY" || arg_day == "FRIDAY" )
        if arg_day == "MONDAY" || arg_day == "FRIDAY"
            if arg_day == "MONDAY"
                if is_it_regular_hours_of_the_day
                    result = "REGULAR"
                elsif arg_service_time.strftime("%M").to_i < SystemParam.get_key_value(13, "REGULAR_BUSINESS_HOUR_START_TIME", "regular_start_hour").to_i
                    result = "WEEKEND"
                else
                    result = "WEEKNIGHT"
                end
            else # it is FRIDAY
                if is_it_regular_hours_of_the_day
                    result = "REGULAR"
                else
                    result = "WEEKEND"
                end
            end
        else
            if is_it_regular_hours_of_the_day
                result = "REGULAR"
            else
                result = "WEEKNIGHT"
            end
        end
    else
    result = "WEEKEND"
    end
  return result
end

# def self.is_it_a_weekday(arg_day)
#   if (arg_day == "MONDAY" || arg_day == "TUESDAY" || arg_day == "WEDNESDAY" || arg_day == "THURSDAY" || arg_day == "FRIDAY" )
#     return true
#   else
#     return false
#   end
# end

def self.is_it_regular_hours(arg_service_time)
    service_time_hour = arg_service_time.strftime("%H").to_i
    regular_start_hour = SystemParam.get_key_value(13, "REGULAR_BUSINESS_HOUR_START_TIME", "regular_start_hour").to_i
    regular_end_hour = SystemParam.get_key_value(13, "REGULAR_BUSINESS_HOUR_END_TIME", "regular_end_hour").to_i

    if service_time_hour >= regular_start_hour && service_time_hour <= regular_end_hour
        if service_time_hour == regular_end_hour
            service_time_minute = arg_service_time.strftime("%M").to_i
            if service_time_minute == 0
                return true
            else
                return false
            end
        else
            return true
        end
    else
        return false
    end
end


    def self.get_service_authorizations_for_provider(arg_provider_id)
      where("provider_id = ? and status = 6162",arg_provider_id).order("program_unit_id DESC")
    end

    def self.get_service_program_activity_for_line_items(arg_auth_id)
      step1 = joins("INNER JOIN program_units ON service_authorizations.program_unit_id = program_units.id")
      step2 = step1.where("service_authorizations.id = ?",arg_auth_id)
      step3 = step2.select("service_authorizations.service_type, program_units.service_program_id")
    end

  def self.delete_service_schedules(arg_srvc_auth_id)
    srvc_schedule_collection = ServiceSchedule.where("service_authorization_id=?",arg_srvc_auth_id)
    if srvc_schedule_collection.present?
        srvc_schedule_collection.destroy_all
    end
  end


  def self.get_activity_detail(arg_action_plan_detail_id)
    step1 = ActionPlanDetail.joins("INNER JOIN action_plans ON action_plans.id = action_plan_details.action_plan_id
                                    INNER JOIN program_units ON  program_units.id =  action_plans.program_unit_id
                                  ")
    step2 = step1.where("action_plan_details.id = ?",arg_action_plan_detail_id)
    step3 = step2.select("action_plan_details.id,action_plans.action_plan_type,action_plans.start_date as action_plan_start_date,
                                 action_plans.end_date as action_plan_end_date,action_plan_details.activity_type,action_plan_details.activity_status,
                                 action_plan_details.start_date as action_plan_detail_start_date,action_plan_details.end_date as action_plan_detail_end_date,
                                 program_units.id as program_unit_id,program_units.service_program_id
                         ")
    activity_detail_object = step3.first
    return activity_detail_object

  end


  def self.get_transportation_barriers(arg_action_plan_detail_id)
    step1 = ActionPlanDetail.joins("INNER JOIN action_plans ON action_plans.id = action_plan_details.action_plan_id
                                    INNER JOIN employment_readiness_plans ON employment_readiness_plans.id = action_plans.employment_readiness_plan_id
                                    INNER JOIN client_assessments ON client_assessments.id = employment_readiness_plans.client_assessment_id
                                    INNER JOIN assessment_barriers ON (assessment_barriers.client_assessment_id = client_assessments.id and assessment_section_id = 13)
                                    INNER JOIN barriers ON barriers.id = assessment_barriers.barrier_id
                                 ")
    step2 = step1.where("action_plan_details.id = ?",arg_action_plan_detail_id)
    step3 = step2.select("action_plan_details.id as arg_action_plan_detail_id,
                          assessment_barriers.barrier_id ,
                          barriers.description as barrier_description
                          ")
    transport_barrier_collection = step3
    return transport_barrier_collection
  end

  def self.get_supportive_service_for_action_plan_id(arg_action_plan_details_id)
      step1 = ServiceAuthorization.where("action_plan_detail_id = ? and supportive_service_flag = 'Y'",arg_action_plan_details_id).order("id DESC")
      return step1
  end

  # def self.can_create_service_authorization_record(arg_action_plan_detail_id,arg_barrier_id,arg_service_type_id)
  #   # Is the service still open and ongoing ?
  #   where("action_plan_detail_id = ? and barrier_id = ? and service_type = ? and status = 6162", arg_action_plan_detail_id,arg_barrier_id,arg_service_type_id)

  # end

  def self.get_supportive_service_barriers(arg_action_plan_detail_id)
    step1 = ActionPlanDetail.joins("INNER JOIN action_plans ON action_plans.id = action_plan_details.action_plan_id
                                    INNER JOIN employment_readiness_plans ON employment_readiness_plans.id = action_plans.employment_readiness_plan_id
                                    INNER JOIN client_assessments ON client_assessments.id = employment_readiness_plans.client_assessment_id
                                    INNER JOIN assessment_barriers ON (assessment_barriers.client_assessment_id = client_assessments.id and assessment_section_id not in(2))
                                    INNER JOIN barriers ON barriers.id = assessment_barriers.barrier_id
                                 ")
    step2 = step1.where("action_plan_details.id = ?",arg_action_plan_detail_id)
    step3 = step2.select("action_plan_details.id as arg_action_plan_detail_id,
                          assessment_barriers.barrier_id ,
                          barriers.description as barrier_description
                          ")
    transport_barrier_collection = step3
    return transport_barrier_collection
  end

  def self.get_non_transport_supportive_service_barriers(arg_action_plan_detail_id)
    step1 = ActionPlanDetail.joins("INNER JOIN action_plans ON action_plans.id = action_plan_details.action_plan_id
                                    INNER JOIN employment_readiness_plans ON employment_readiness_plans.id = action_plans.employment_readiness_plan_id
                                    INNER JOIN client_assessments ON client_assessments.id = employment_readiness_plans.client_assessment_id
                                    INNER JOIN assessment_barriers ON (assessment_barriers.client_assessment_id = client_assessments.id and assessment_section_id not in(2,13))
                                    INNER JOIN barriers ON barriers.id = assessment_barriers.barrier_id
                                 ")
    step2 = step1.where("action_plan_details.id = ?",arg_action_plan_detail_id)
    step3 = step2.select("action_plan_details.id as arg_action_plan_detail_id,
                          assessment_barriers.barrier_id ,
                          barriers.description as barrier_description
                          ")
    transport_barrier_collection = step3
    return transport_barrier_collection
  end


  def self.get_non_transport_supportive_services()
    step1 = CodetableItem.where("code_table_id = 168 and id not in (6215,6214)")
    return step1
  end



  # def self.create_non_transport_service_line_items(arg_service_authorization_id)
  #   # 1. Populate service_authorization_line_items
  #   #  Delete
  #   ServiceAuthorizationLineItem.where("service_authorization_id = ?",arg_service_authorization_id).destroy_all
  #   # Insert
  #   msg = "SUCCESS"
  #   service_authorization_object = ServiceAuthorization.find(arg_service_authorization_id)
  #   ldt_service_date = service_authorization_object.service_date
  #   service_authorization_line_item = ServiceAuthorizationLineItem.new
  #   service_authorization_line_item.service_authorization_id = service_authorization_object.id
  #   service_authorization_line_item.service_date = ldt_service_date
  #   service_authorization_line_item.line_item_status = 6369 # generated.#6168
  #   if service_authorization_line_item.save
  #   else
  #     msg = service_authorization_line_item.errors.full_messages.last
  #   end

  #   return msg
  # end


  def self.create_non_supportive_service_plan(arg_action_plan_detail_id)
    # msg = "SUCCESS"

    action_plan_detail_object = ActionPlanDetail.find(arg_action_plan_detail_id)
    action_plan_object = ActionPlan.find(action_plan_detail_object.action_plan_id)
    # if service is not paid,cancelled or rejected.
    # delete
    ServiceAuthorization.where("action_plan_detail_id = ? and supportive_service_flag = 'N'",arg_action_plan_detail_id).destroy_all
    # insert

    service_authorization_object = ServiceAuthorization.new
    service_authorization_object.provider_id = action_plan_detail_object.provider_id
    service_authorization_object.program_unit_id= action_plan_object.program_unit_id
    service_authorization_object.client_id= action_plan_object.client_id
    service_authorization_object.service_start_date= action_plan_detail_object.start_date
    if action_plan_detail_object.end_date.present?
      service_authorization_object.service_end_date= action_plan_detail_object.end_date
    end
    service_authorization_object.status = action_plan_detail_object.activity_status
    service_authorization_object.notes = action_plan_detail_object.notes
    service_authorization_object.action_plan_detail_id= action_plan_detail_object.id
    service_authorization_object.barrier_id= action_plan_detail_object.barrier_id
    service_authorization_object.supportive_service_flag = "N"
    service_authorization_object.service_type = action_plan_detail_object.activity_type
    service_authorization_object.save


  end

  def self.authorize_non_supportive_service_plan(arg_action_plan_detail_id)
    msg = "SUCCESS"

    action_plan_detail_object = ActionPlanDetail.find(arg_action_plan_detail_id)
    action_plan_object = ActionPlan.find(action_plan_detail_object.action_plan_id)
    # if service is not paid,cancelled or rejected.
    # delete
    non_supportive_service_collection = ServiceAuthorization.where("action_plan_detail_id = ? and supportive_service_flag = 'N'",arg_action_plan_detail_id)
    # insert
    if non_supportive_service_collection.present?
        service_authorization_object = non_supportive_service_collection.first
        service_authorization_object.status = 6162 # authorized
        service_authorization_object.save
    else
      msg = "No Service found"
    end

    return msg

  end



  def self.can_service_be_approved?(arg_action_plan_details_id)
    # Rule - Normal non supportive service can be Approved as long as no payment record data entry is not started.
    step1 = ServiceAuthorization.joins("INNER JOIN service_authorization_line_items ON service_authorizations.id = service_authorization_line_items.service_authorization_id")
    step2 = step1.where("service_authorization.action_plan_detail_id = ?",arg_action_plan_details_id)
    if step1.present?
      can_approve = false
    else
      can_approve = true
    end
    return can_approve
  end

  def self.services_pending_approval(arg_program_unit_id)
    step1 = ServiceAuthorization.joins("INNER JOIN action_plan_details ON action_plan_details.id = service_authorizations.action_plan_detail_id
                                        INNER JOIN action_plans ON action_plans.id = action_plan_details.action_plan_id
                                      ")
    step2 = step1.where("action_plan_details.activity_status = 6043
                        AND action_plans.action_plan_status = 6043
                        AND (service_authorizations.status = 6161 or service_authorizations.status = 6043)
                        AND action_plans.program_unit_id = ?",arg_program_unit_id)
    step3 = step2.select("action_plans.*,
                          action_plan_details.*,
                          service_authorizations.*
                          ")
    step4 = step3.order("service_authorizations.id DESC")
    pending_service_collection = step4
    return pending_service_collection
  end


  def validate_supportive_service_start_date_should_be_greater_or_equal_to_activity_start_date
    lb_return = true
    if self.action_plan_detail_id?
        if self.service_date.present?
         if self.service_date < Date.today
             errors[:base] << "Service start date should be greater or equal to current date- #{CommonUtil.format_db_date(Date.today)}."
              lb_return = false
          end
        end#if service_date.present?
        if self.service_start_date.present?
          action_plan_detail_object = ActionPlanDetail.find(self.action_plan_detail_id)
          action_plan_detail_start_date = action_plan_detail_object.start_date
          if self.service_start_date < action_plan_detail_start_date
            errors[:base] << "Service start date should be greater or equal to activity start date #{action_plan_detail_start_date.strftime("%m/%d/%Y")}."
            lb_return = false
          elsif self.service_start_date < Date.today
            errors[:base] << "Service start date should be greater or equal to current date- #{CommonUtil.format_db_date(Date.today)}."
            lb_return = false
          end
        end#self.service_start_date.present?
    end#self.action_plan_detail_id?
    return lb_return
  end

  def self.get_all_supportive_services_for_the_program_unit(arg_program_unit_id)
    step1 = joins("INNER JOIN action_plan_details ON service_authorizations.action_plan_detail_id = action_plan_details.id
                   INNER JOIN action_plans ON action_plans.id = action_plan_details.action_plan_id
                   INNER JOIN CODETABLE_ITEMS ON (CODETABLE_ITEMS.ID = service_authorizations.SERVICE_TYPE AND CODETABLE_ITEMS.CODE_TABLE_ID = 168)")
    step2 = step1.where("action_plans.program_unit_id = ? and action_plan_details.activity_status = 6043",arg_program_unit_id)
    # step2.select("service_authorizations.id,action_plan_details.activity_type, service_authorizations.service_type, service_authorizations.provider_id,
    #               service_authorizations.service_date, service_authorizations.status, service_authorizations.service_start_date,
    #               service_authorizations.service_end_date,service_authorizations.id")
    step2.select("service_authorizations.*,action_plan_details.activity_type")
    # step2.select("service_authorizations.*")
  end

end
