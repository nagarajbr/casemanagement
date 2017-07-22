class ServiceAuthorizationLineItem < ActiveRecord::Base
has_paper_trail :class_name => 'SerizAuthLineItemVersion',:on => [:update, :destroy]
 include AuditModule
    before_create :set_create_user_fields
    # before_update :set_update_user_field, :set_line_item_status, :is_actual_cost_changed, :is_actual_distance_changed
    # before_update :set_update_user_field, :is_actual_cost_changed, :is_actual_distance_changed
    before_update :set_update_user_field

 belongs_to :service_authorization
 attr_accessor :non_ts_service


   HUMANIZED_ATTRIBUTES = {
      reason: "Rejection Reason"

    }

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end



 validate :valid_non_transportation_line_item
 validate :rejection_reason_required_if_rejecting,:on => :update
 validate :validate_service_date

  # State machine state management start Kiran 07/21/2015
  # state_machine :state, :initial => :complete do
  #     audit_trail context: [:created_by, :reason]
  #      # audit_trail context: :created_by

  #     state :complete, value: 6165
  #     state :requested, value: 6373
  #     state :rejected, value: 6167
  #     state :approved, value: 6166
  #     state :submitted, value: 6728

  #     event :request do
  #       transition :complete => :requested
  #     end

  #     event :submit do
  #       transition :complete => :submitted
  #     end

  #     event :approve do
  #       transition :requested => :approved
  #     end

  #     event :reject do
  #       transition :requested => :rejected
  #     end

  #     event :complete do
  #       transition :rejected => :complete
  #     end

  # end
  # State machine state management end Kiran 07/21/2015

    # def created_by
    #   # updated user id
    #   AuditModule.get_current_user.uid
    # end


    def valid_non_transportation_line_item
       lb_return = true
        if non_ts_service == "Y"
          if service_date.blank?
            errors.add(:service_date, "is required.")
            lb_return = false
          end

          if actual_cost.blank?
            errors.add(:actual_cost, "is required.")
            lb_return = false
          end
        end
        return lb_return
    end

    def rejection_reason_required_if_rejecting
        lb_return = true
         if state == 6167
            if reason.blank?
               errors.add(:reason, "is required.")
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


    # def self.get_ready_to_be_invoiced_line_items(arg_service_authorization_id)
    #   where("service_authorization_id = ? and line_item_status = 6169",arg_service_authorization_id)
    # end

    # def self.get_amount_to_be_invoiced(arg_service_authorization_id)
    #   ld_amount = 0.00
    #   step1 = where("service_authorization_id = ?  and line_item_status = 6169",arg_service_authorization_id)
    #   step2 = step1.select("sum(actual_cost) as total_invoice_amount")
    #   if step2.present?
    #     invoice_amount_object = step2.first
    #     ld_amount = invoice_amount_object.total_invoice_amount
    #   else
    #     ld_amount = 0.00
    #   end

    #   return ld_amount

    # end

    def self.update_line_items_status(arg_invoice_id, arg_new_status)
      step1 = where("provider_invoice_id = ?",arg_invoice_id)
      step2 = step1.update_all(line_item_status: arg_new_status)
    end

     def self.get_provider_invoice_line_items(arg_invoice_id)
      step1 = ServiceAuthorizationLineItem.joins("INNER JOIN provider_invoices
                                                  ON service_authorization_line_items.provider_invoice_id = provider_invoices.id"
                                                )
      step2 = step1.where("service_authorization_line_items.provider_invoice_id = ?",arg_invoice_id)
      step3 = step2.select("service_authorization_line_items.provider_invoice_id,
                            service_authorization_line_items.id,
                            service_authorization_line_items.service_date,
                            service_authorization_line_items.service_begin_time,
                            service_authorization_line_items.actual_quantity,
                            service_authorization_line_items.unit_of_measure,
                            service_authorization_line_items.actual_cost,
                            service_authorization_line_items.provider_invoice_id
                           ")
      step4 = step3.order("service_authorization_line_items.service_date ASC")
      provider_invoice_line_items_collection = step4
      return provider_invoice_line_items_collection
    end

    def self.get_estimated_service_cost_details(arg_service_authorization_id)
        where("service_authorization_id = ?",arg_service_authorization_id)
    end

    def self.any_generated_line_items_found(arg_srvc_authorization_id)
      where("service_authorization_id = ? and line_item_status in(6168,6369)",arg_srvc_authorization_id).count > 0
    end

    def self.any_submitted_line_items_found(arg_srvc_authorization_id)
       where("service_authorization_id = ? and line_item_status = 6169",arg_srvc_authorization_id).count > 0
    end

    def self.any_processed_line_items_found(arg_srvc_authorization_id)
      where("service_authorization_id = ? and line_item_status = 6170",arg_srvc_authorization_id).count > 0
    end

    def self.any_rejected_line_items_found(arg_srvc_authorization_id)
      where("service_authorization_id = ? and state = 6167",arg_srvc_authorization_id).count > 0
    end

    # def self.get_service_auth_line_items_requested_for_supervisor_approval(arg_service_authorization_id)
    #   # Requesting supervisor approval
    #   requested_data_collection = ServiceAuthorizationLineItem.where("service_authorization_id = ? and state = 6373")
    # end

    def validate_service_date
        if service_date.present?
             if  self.service_authorization.service_start_date.present? && self.service_authorization.service_type != 6215
                if (self.service_authorization.service_start_date..Date.today).cover?(service_date)
                else
                    errors[:base] << "Service date must be between service start date and current date."
                    return false
                end

            end
        end

    end

    # def set_line_item_status
    #   case self.state
    #   when 6373 # requested
    #     self.line_item_status = 6169 # submitted
    #   when 6166 # approved
    #     self.line_item_status = 6170 # processed
    #   when 6167 # rejected
    #     self.line_item_status = 6369 # generated
    #   end
    # end

    def self.can_create_non_transportation_payment_line_item?(arg_srvc_authorization_id)
      result = true
      if ServiceAuthorizationLineItem.where("service_authorization_id = ? and state != 6166",arg_srvc_authorization_id).count > 0
        result = false
      end
      return result
    end

    # def self.get_line_item_id(arg_invoice_id)
    #   where("provider_invoice_id = ?",arg_invoice_id).first.id
    # end


    # def is_actual_cost_changed
    #   # fail
    #   # if actual cost changed override reason should be mandatory
    #   lb_return = true
    #   if actual_cost_changed?
    #     # fail
    #     # unless self.override_reason.present?
    #     if override_reason.blank?
    #       errors.add(:override_reason, "is required since actual cost is not the same as estimated cost")
    #         lb_return = false
    #     end
    #   # else
    #   #   # fail
    #   #   if self.override_reason.present?
    #   #     fail
    #   #     errors.add(:override_reason, "is required if actual cost is not the same as estimated cost")
    #   #     lb_return = false
    #   #   end
    #   #   fail
    #   end
    # end

    # def is_actual_distance_changed
    #   # if actual cost changed override reason should be mandatory
    #   lb_return = true
    #   if actual_quantity_changed?
    #     if actual_cost_changed?
    #     else
    #       errors.add(:actual_cost, "is required to be recalculated for change in actual distance")
    #         lb_return = false
    #     end
    #   end
    # end

end
