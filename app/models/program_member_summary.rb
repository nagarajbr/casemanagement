class ProgramMemberSummary < ActiveRecord::Base

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

    def self.get_program_member_summary_collection(arg_run_id,arg_month_sequence)
      program_member_summary_collection = ProgramMemberSummary.where("run_id = ? and month_sequence = ?",arg_run_id,arg_month_sequence)
    end



end
