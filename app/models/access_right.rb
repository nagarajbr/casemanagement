class AccessRight < ActiveRecord::Base
	include AuditModule
  	belongs_to :ruby_element




    def self.user_authorized_to_access(arg_element_id)
      li_role_id = AuditModule.get_current_user.get_role_id()
      step1 = joins("INNER JOIN ruby_elements on ruby_elements.id = access_rights.ruby_element_id")
      step2 = step1.where("ruby_elements.id = ?
                             and access_rights.access = 'Y'
                             and access_rights.role_id = ?
                          ",arg_element_id,li_role_id)
        if step2.present?
          return true
        else
          return false
        end
    end


end
