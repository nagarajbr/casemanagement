class AuditTrailIncomeDetail < ActiveRecord::Base
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

	def self.get_income_details_based_on_run_id(arg_run_id)
        where("run_id = ? ",arg_run_id,)
    end

    def self.get_audit_trail_income_details(arg_run_id, arg_month_id, arg_member_id, arg_details_id, arg_audit_id)
        where("run_id = ? and month_sequence = ? and member_sequence = ? and b_details_sequence = ? and audit_trail_masters_id = ? ",arg_run_id, arg_month_id, arg_member_id, arg_details_id, arg_audit_id)
    end

end
