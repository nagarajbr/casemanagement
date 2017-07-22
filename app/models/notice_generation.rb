class NoticeGeneration < ActiveRecord::Base

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

    # def self.get_notice_generation_details_from_notice_generations_id(arg_id)
    #     step1 = NoticeGeneration.joins("inner join notice_generation_details on notice_generation_details.notice_generations_id = notice_generations.id").where("notice_generations.id = ?",arg_id)
    #     step2 = step1.select("notice_generation_details.name")
    #     result = step2
    #     if result.present?
    #        return result
    #     else
    #        return ""
    #     end

    # end

    def self.get_notice_generation_record(arg_reference_id,arg_reference_type)
      result = where("reference_id = ? and reference_type = ? and notice_status != 6613",arg_reference_id,arg_reference_type)
      result = result.present? ? result.first : nil
      return result
    end

    def self.is_notice_record_required(arg_notice_generated_date,
                                        arg_action_type,
                                        arg_action_reason,
                                        arg_reference_id,
                                        arg_reference_type)
      notice_generation_object = NoticeGeneration.where("notice_generated_date = ? and action_type = ? and action_reason = ? and notice_status = 6614 and reference_id = ? and reference_type = ?", arg_notice_generated_date, arg_action_type, arg_action_reason,arg_reference_id,arg_reference_type)
      if notice_generation_object.present?
        result = true
      else
        result = false
      end
      return result
    end


end