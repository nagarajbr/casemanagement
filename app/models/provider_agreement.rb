class ProviderAgreement < ActiveRecord::Base
has_paper_trail :class_name => 'ProviderAgreementVersion',:on => [:update, :destroy]

  include AuditModule

  before_create :set_create_user_fields
  before_update :set_update_user_field

  belongs_to :provider
	has_many :provider_agreement_areas, dependent: :destroy

   attr_accessor :provider_name,:local_office_manager_name,:local_office_name,:served_areas

	 HUMANIZED_ATTRIBUTES = {
      provider_service_id: "Service Type",
      dws_local_office_id: "Served Area",
      dws_local_office_manager_id: "Local Office Manager",
      agreement_start_date: "Agreement Start Date",
      agreement_end_date: "Agreement End Date",
      termination_reason: "Termination Reason",
      termination_date: "Termination Date",
      reason: "Rejection Reason"

    }

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end


  validates_presence_of :provider_service_id, :agreement_start_date,:agreement_end_date, message: "is required"
  validate :validate_start_date?,:validate_end_date?,:start_date_less_than_end_date?
  validate :valid_agreement_date?
  # validate :validate_no_overlapping_dates, :on => :create
  validate :validate_no_overlapping_dates_update, :on => :update
  # validate :termination_reason_and_date_required?
  validate :termination_date_should_be_before_end_date?,:on => :update
  validate  :termination_reason_and_date_required,:on => :update
  validate  :rejection_reason_required_if_rejecting,:on => :update
  validate  :second_step_validations,:on => :update


  # State machine state management start Manoj 07/14/2014
  state_machine :state, :initial => :incomplete do
    audit_trail context: [:created_by, :reason]
     # audit_trail context: :created_by

    state :incomplete, value: 6164
    state :complete, value: 6165
    state :requested, value: 6373
    state :rejected, value: 6167
    state :approved, value: 6166
    state :terminated, value: 6266

    event :complete do
        transition :incomplete => :complete
    end

    event :request do
          transition :complete => :requested
    end

    event :approve do
        transition :requested => :approved
    end

    event :reject do
        transition :requested => :rejected
    end
    event :terminated do
      transition :requested => :terminated
    end

    event :terminate do
        transition :approved => :terminated
    end

  end
  # State machine state management end Manoj 07/14/2014

  def created_by
    # updated user id
     AuditModule.get_current_user.uid
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


  def start_date_less_than_end_date?
    DateService.begin_date_cannot_be_greater_than_end_date?(self,agreement_start_date,agreement_end_date,"Agreement start date","Agreement end date")
  end

  def termination_date_should_be_before_end_date?
    if termination_date.present?
      if termination_date < agreement_end_date
        return true
       else
         local_message = "Termination date must be prior to agreement end date"
         self.errors[:base] << local_message
         return false
        end
      else
        return true
       end
  end

  def validate_no_overlapping_dates
      if self.provider_service_id.present? && self.agreement_start_date.present? && self.agreement_end_date.present?
        if ProviderService.check_agreement_overlapping_dates(self.provider_id,self.provider_service_id,self.agreement_start_date,self.agreement_end_date)
          local_message = "This provider service agreement overlaps with an existing agreement"
          self.errors[:base] << local_message
          return false
        else
          return true
        end
      else
        return true
      end
  end

     def validate_no_overlapping_dates_update

      if self.get_process_object == "provider_agreement_county_second"
        if self.provider_service_id.present? && self.agreement_start_date.present? && self.agreement_end_date.present?
          if ProviderService.check_agreement_overlapping_dates_update(self.provider_id,
                                                                      self.provider_service_id,
                                                                      self.agreement_start_date,
                                                                      self.agreement_end_date,
                                                                      self.id,
                                                                      self.dws_local_office_id
                                                                      )
            local_message = "This provider service agreement overlaps with an existing agreement"
            self.errors[:base] << local_message
            return false
          else
            return true
          end
        else
          return true
        end
      else
        return true
      end
    end




  # provider agreement multi step form creation of data. - start
    attr_writer :current_step,:process_object

    def steps
       %w[provider_agreement_details_first provider_agreement_county_second provider_agreement_review_last]
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


# provider agreement multi step form creation of data. - - End

  def self.get_provider_agreements(arg_provider_id)
    ProviderAgreement.where("provider_id = ?", arg_provider_id).order("id DESC")
  end



  def valid_agreement_date?
    if provider_service_id.present? && agreement_start_date.present? && agreement_end_date.present?
      provider_service_object = ProviderService.find(provider_service_id)
      if provider_service_object.end_date.present?
        if ( (agreement_start_date >= provider_service_object.start_date) && (agreement_end_date <= provider_service_object.end_date) )
            return true
        else
           local_message = "Agreement Date Range should be inside Provider Services Date Range: #{provider_service_object.start_date.strftime("%m/%d/%Y")} - #{provider_service_object.end_date.strftime("%m/%d/%Y")}"
          self.errors[:base] << local_message
          return false
        end
      else
        if ( agreement_start_date >= provider_service_object.start_date )
            return true
        else
            local_message = "Agreement Start Date should be after Provider Service Start Date: #{provider_service_object.start_date.strftime("%m/%d/%Y")}"
            self.errors[:base] << local_message
            return false
          end
      end
    else
      return true
    end
  end

  def termination_reason_and_date_required
    lb_return = true
     if state == 6266
         if termination_date.blank?
            errors.add(:termination_date, "is required")
            lb_return = false
         end
        if termination_reason.blank?
           errors.add(:termination_reason, "is required")
           lb_return = false
         end
     end
     return lb_return
end

def rejection_reason_required_if_rejecting
    lb_return = true
     if state == 6167
        if reason.blank?
           errors.add(:reason, "is required")
           lb_return = false
         end
     end
     return lb_return
end

  def second_step_validations
     lb_return = true
    if self.get_process_object == "provider_agreement_county_second"

      if dws_local_office_id.blank?
        errors.add(:dws_local_office_id, "is required")
        lb_return = false
      end

      if dws_local_office_manager_id.blank?
        errors.add(:dws_local_office_manager_id, "is required")
        lb_return = false
      end
    end
    return lb_return
  end





  def self.agreement_details_to_print(arg_agreement_id)
    provider_agreement_object = ProviderAgreement.find(arg_agreement_id)
    provider_object = Provider.find(provider_agreement_object.provider_id)
    provider_agreement_object.provider_name = provider_object.provider_name
    user_object = User.find(provider_agreement_object.dws_local_office_manager_id)
    provider_agreement_object.local_office_manager_name = user_object.name
    codetable_item_object = CodetableItem.find(provider_agreement_object.dws_local_office_id)
    provider_agreement_object.local_office_name = codetable_item_object.short_description
    ls_served_areas = ProviderAgreement.get_formatted_provider_areas(arg_agreement_id)
    provider_agreement_object.served_areas = ls_served_areas
    logger.debug("provider_agreement_object contents = #{provider_agreement_object.inspect}")
    return provider_agreement_object



    # provider_name,:local_office_manager_name,:local_office_name,:served_areas

  end




  def self.get_formatted_provider_areas(arg_agreement_id)
    service_area_collection = ProviderAgreementArea.get_distinct_local_offices(arg_agreement_id)
    ls_return = ""
    service_area_collection.each do |service_area|
      ls_description = CodetableItem.get_short_description(service_area.served_local_office_id)
      ls_return = ls_return + ls_description+","
    end
    ls_return_length = ls_return.length
    ls_return_length = ls_return_length - 2
    ls_return[0..ls_return_length]
  end

  def validate_start_date?
     if agreement_start_date.present?
         #provider agreement start date should not be more than 3 months in the future and no more than 1 month in the past from the current date.
        ldate_previous_month = Date.today - 1.month
        ldate_future_month = Date.today + 3.month

        if (ldate_previous_month..ldate_future_month).include?(self.agreement_start_date)
            return true
        else
           local_message = "Agreement start date should be with in the range #{ldate_previous_month.strftime("%m/%d/%Y")} and #{ldate_future_month.strftime("%m/%d/%Y")}"
            self.errors[:base] << local_message
            return false
        end
      else
        return true
      end


  end

  def validate_end_date?
      if agreement_end_date.present? && agreement_start_date.present?
        # Provider agreement end date should not be more than 12 months in the future and not less than the agreement start date.
        # ldate_today = Date.today
        ldate_today = agreement_start_date
        ldate_future_month =ldate_today + 12.month

        if (ldate_today..ldate_future_month).include?(self.agreement_end_date)
            return true
        else

            local_message = "Agreement end date should be future date and less than #{ldate_future_month.strftime("%m/%d/%Y")}(one year from Start Date)."
            self.errors[:base] << local_message
            return false
        end
      else
        return true
      end

  end

  # def self.save_provider_agreement(arg_provider_agreement_object)
  #   agreement_collection = ProviderAgreement.where("provider_id = ? and provider_service_id = ? and state = 6164",arg_provider_agreement_object.provider_id,arg_provider_agreement_object.provider_service_id)

  #   if agreement_collection.present?
  #     provider_agreement_object = agreement_collection.first
  #     provider_agreement_object.agreement_start_date = arg_provider_agreement_object.agreement_start_date
  #     provider_agreement_object.agreement_end_date = arg_provider_agreement_object.agreement_end_date
  #     provider_agreement_object.save
  #   else
  #     provider_agreement_object = arg_provider_agreement_object
  #     provider_agreement_object.save
  #   end
  #   return provider_agreement_object
  # end






end
