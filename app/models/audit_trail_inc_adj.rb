class AuditTrailIncAdj < ActiveRecord::Base
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

    def self.get_audit_income_adjust_details(arg_run_id, arg_month_sequence, arg_member_sequence, arg_b_detail_sequence, arg_audit_id, arg_sudit_detail_id)
    	where("run_id = ? and month_sequence = ? and member_sequence = ? and b_details_sequence = ?
    	 and audit_trail_masters_id = ?   and audit_trail_income_details_id = ?",arg_run_id, arg_month_sequence, arg_member_sequence, arg_b_detail_sequence, arg_audit_id, arg_sudit_detail_id)
    end
end
