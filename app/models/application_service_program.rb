class ApplicationServiceProgram < ActiveRecord::Base
has_paper_trail :class_name => 'AppServicePgmVersion',:on => [:update, :destroy]
	# Author : Manojkumar PAtil
	# Date : 09/05/2014

	include AuditModule

    before_create :set_create_user_fields
    before_update :set_update_user_field

    belongs_to :client_application
	  belongs_to :service_program
	 def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
      # at the time of creation status is set to Pending.
      self.status = 4000
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end


    def self.get_application_service_program_object(arg_application_id)
        ApplicationServiceProgram.where("client_application_id = ?", arg_application_id)
    end



end
