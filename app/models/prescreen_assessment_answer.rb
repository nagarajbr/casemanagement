class PrescreenAssessmentAnswer < ActiveRecord::Base

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

	 def self.get_answer_collection(arg_prescreen_household_id,arg_qstn_id)
     Rails.logger.debug("MNP ****arg_prescreen_household_id = #{arg_prescreen_household_id}")
      where("prescreen_household_id = ? and assessment_question_id = ?",arg_prescreen_household_id,arg_qstn_id)
    end

    def self.get_answer_collection_for_question_value(arg_prescreen_household_id,arg_qstn_id,arg_value)
      ans_checked_collection = where("prescreen_household_id = ? and assessment_question_id = ? and answer_value=?",arg_prescreen_household_id,arg_qstn_id,arg_value)
      if ans_checked_collection.present?
        return true
      else
         return false
      end
    end

     def self.get_answers_collection_for_prescreen_household_id(arg_prescreen_household_id)
      where("prescreen_household_id = ?",arg_prescreen_household_id).order("id ASC")
    end

end
