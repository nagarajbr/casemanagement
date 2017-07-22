class AuditTrailShared < ActiveRecord::Base
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

	  def self.get_income_shared_information(arg_run_id,arg_month_sequence,arg_member_sequence,arg_b_details_id,arg_audit_id)
        step1 = joins(" INNER JOIN clients ON audit_trail_shareds.client_id = clients.id")
        step2 = step1.where("audit_trail_shareds.run_id = ? and audit_trail_shareds.month_sequence = ?  and audit_trail_shareds.member_sequence = ?  and audit_trail_shareds.b_details_sequence = ? and audit_trail_shareds.audit_trail_masters_id = ? ",arg_run_id,arg_month_sequence,arg_member_sequence,arg_b_details_id,arg_audit_id)
        step3 = step2.select("audit_trail_shareds.client_id,audit_trail_shareds.run_id,audit_trail_shareds.month_sequence,
         audit_trail_shareds.member_sequence,audit_trail_shareds.b_details_sequence,audit_trail_shareds.updated_at,
         audit_trail_shareds.updated_by,audit_trail_shareds.client_id,clients.ssn,clients.first_name,clients.last_name,clients.middle_name,
		 clients.suffix")
    end


end
