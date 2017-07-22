class NoticeText < ActiveRecord::Base
include AuditModule

  def self.get_notice_text_from_action_reason_action_type(arg_action_reason,arg_action_type,arg_service_program_id)
  	  result = NoticeText.where("action_reason =? and action_type = ? and service_program_id = ?",arg_action_reason,arg_action_type,arg_service_program_id)
  	  if result.present?
  	  	 noticetext = result.select("notice_texts.*")
         return noticetext
  	  end
  end
  def self.get_notice_text_from_action_reason_action_type_for_application(arg_action_reason,arg_action_type)
  	  result = NoticeText.where("action_reason =? and action_type = ? ",arg_action_reason,arg_action_type)
  	  if result.present?
  	  	 noticetext = result.select("notice_texts.*")
         return noticetext
  	  end
  end
end
