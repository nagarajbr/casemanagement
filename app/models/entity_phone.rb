class EntityPhone < ActiveRecord::Base
has_paper_trail :class_name => 'EntityPhoneVersion',:on => [:update, :destroy]


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

	def self.delete_record(arg_entity_type, arg_entity_id, arg_phone_id)
		entity_phone =  where("entity_type = ? and entity_id = ? and phone_id = ?",arg_entity_type, arg_entity_id, arg_phone_id)
		if entity_phone.present?
			entity_phone.first.destroy
		end
	end
end
