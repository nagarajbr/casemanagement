class AssessmentBarrierDetail < ActiveRecord::Base
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

    def self.get_assessment_barrier_details(arg_assessment_id)
    	where("assessment_barrier_id in (select id from assessment_barriers where client_assessment_id = ?) ",arg_assessment_id).order("assessment_barrier_id,id ASC")
    end

    def self.get_barrier_details(arg_assessment_barrier_id)
        where("assessment_barrier_id = ?",arg_assessment_barrier_id).order("display_order ASC")
    end
end
