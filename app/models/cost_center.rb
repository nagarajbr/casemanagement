class CostCenter < ActiveRecord::Base
has_paper_trail :class_name => 'CostCenterVersion',:on => [:update, :destroy]


	before_create :set_create_user_fields
   	before_update :set_update_user_field
   	before_save :clear_service_type_in_case_of_tea_diversion

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
    	service_program_group: "Service Program",
    	cost_center: "Cost Center",
  		internal_order: "Internal Order",
    	gl_account: "Account",
    	service_type: "Service Type"
    }

    def self.human_attribute_name(attr, options = {})
    	HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    validates_presence_of :service_program_group, :cost_center, :internal_order, :gl_account, message: " is required."
    validate :perform_custom_validations

    def perform_custom_validations
    	 if self.service_program_group.present?
    	 	if self.service_program_group != 3
    	 		validates_presence_of :service_type, message: " is required."
    	 	end
    	 else
    	 	validates_presence_of :service_type, message: " is required."
    	 end
    end

    def self.get_cost_center_info(arg_service_prog, arg_service_type)
      where("service_program_group = ? AND service_type = ?",arg_service_prog, arg_service_type)
    end

    def clear_service_type_in_case_of_tea_diversion
    	if self.service_program_group.present? && self.service_program_group == 3
    		self.service_type = nil
    	end
    end

    def self.is_action_amount_below_threshold_amount(arg_service_program_id,arg_service_type,arg_actual_cost)
      cost_center_object = CostCenter.where("service_program_group = ? and service_type = ?",arg_service_program_id ,arg_service_type).first
      if  arg_actual_cost <= cost_center_object.threshold_amount
        return true
      else
        return false
      end
    end

    def self.provider_payments_threshold_amount(arg_service_program_id,arg_service_type)
      cost_center_object = CostCenter.where("service_program_group = ? and service_type = ?",arg_service_program_id ,arg_service_type).first
      return cost_center_object.threshold_amount
    end

end