class AssessmentCareer < ActiveRecord::Base
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

    def self.get_assessment_career(arg_client_id, arg_assessment_id)
    	result = where("client_id = ? and assessment_id = ?",arg_client_id, arg_assessment_id)
    	if result.present?
    		result = result.first
    	end
    	return result
    end

    def self.get_latest_assessment_career(arg_client_id)
        result = where("client_id = ?",arg_client_id).order("assessment_id desc")
        if result.present?
            result = result.first
        end
        return result
    end
end