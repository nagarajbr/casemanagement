class TimeLimit < ActiveRecord::Base
has_paper_trail :class_name => 'TimeLimitVersion',:on => [:update, :destroy]

   belongs_to :client
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



	def self.get_federal_count(arg_client_id)
		where("client_id = ?",arg_client_id)
	end


	def self.get_details_by_client_id(arg_client_id)
		where("client_id = ?",arg_client_id)
	end


end
