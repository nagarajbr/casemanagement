class EligibilityDetermineResult < ActiveRecord::Base
	include AuditModule
	before_create :set_create_user_fields
	before_update :set_update_user_field
	validates_presence_of :run_id, :month_sequence, :message_type
	def set_create_user_fields
    	user_id = AuditModule.get_current_user.uid
    	self.created_by = user_id
    	self.updated_by = user_id
    end

    def set_update_user_field
    	user_id = AuditModule.get_current_user.uid
    	self.updated_by = user_id
    end

    def self.get_results_list(arg_run_id,arg_month_sequence)
        where("run_id = ? and month_sequence = ?",arg_run_id,arg_month_sequence)
    end

     def self.get_critical_errors_results_list(arg_run_id,arg_month_sequence)
        where("run_id = ? and month_sequence = ? and message_type_text = 'Critical' ",arg_run_id,arg_month_sequence)
    end
end
