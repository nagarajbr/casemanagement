class UserLocalOffice < ActiveRecord::Base
	include AuditModule
	#test merge from branch


	validates_presence_of :user_id, :local_office_id,message: "is required"
	# validates :local_office_id,:uniqueness => {:scope => [:user_id],message: "User with same local office exits."}
	validates :local_office_id,:uniqueness => {:scope => [:user_id]}
	before_create :set_create_user_fields
	before_update :set_update_user_field


	    HUMANIZED_ATTRIBUTES = {
        user_id: "User Name",
        local_office_id: "Local Office"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end


	def set_create_user_fields
		Rails.logger.debug("audit_module in UserLocalOffice = #{AuditModule.get_current_user.inspect}")
    	user_id = AuditModule.get_current_user.uid
    	self.created_by = user_id
    	self.updated_by = user_id

    end

    def set_update_user_field
	    user_id = AuditModule.get_current_user.uid
	    self.updated_by = user_id
    end

    def self.get_all_user_locations
        step1 = UserLocalOffice.joins("INNER JOIN users
                                       on  user_local_offices.user_id = users.uid
                                    ")
        step2 = step1.select("user_local_offices.id,
                              user_local_offices.user_id,
                              user_local_offices.local_office_id,
                              users.name as user_name
                            ").order("users.name ASC")
    end

    def self.get_local_offices_for_given_user(arg_user_id)
       UserLocalOffice.where("user_id = ?",arg_user_id)
    end

end
