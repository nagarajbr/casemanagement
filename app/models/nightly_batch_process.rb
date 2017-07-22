class NightlyBatchProcess < ActiveRecord::Base
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

    def self.get_batch_process_data(arg_entity_type, arg_entity_id, arg_process_type, arg_reason, arg_client_id, arg_run_month)
      Rails.logger.debug("arg_run_month**** = #{arg_run_month.inspect}")
      #  Rails.logger.debug("arg_run_month = #{arg_run_month.strftime("%m/%d/%Y").inspect}")

      result = nil
      night_batch_record = where("(processed <> 'Y' or processed IS NULL) and entity_type = ? and entity_id = ? and process_type = ? and reason = ? and client_id = ? and run_month = ? ",arg_entity_type, arg_entity_id, arg_process_type,arg_reason,arg_client_id,arg_run_month)
      if night_batch_record.present?
         result = night_batch_record.first
      end
     # if arg_run_month.present?
     #     result = night_batch_record.where("run_month = ?",arg_run_month)
     #    Rails.logger.debug("result = #{result.inspect}")
     #  end
     #  if arg_reason.present?
     #    result = night_batch_record.where("reason = ?",arg_reason)
     #  end
     #  if arg_client_id.present?
     #    result = night_batch_record.where("client_id = ?",arg_client_id)
     #  end

      return result
    end
end