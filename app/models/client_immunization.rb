class ClientImmunization < ActiveRecord::Base
has_paper_trail :class_name => 'ImmunizationVersion',:on => [:update, :destroy]
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

    def self.get_client_immunization(arg_client_id)
      where("client_id = ?",arg_client_id).first
    end

    def self.is_there_an_immunization_associated(arg_client)
		where("client_id = ?",arg_client).count > 0
	end

end
