class PrimaryContact < ActiveRecord::Base
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

    validates :reference_id,:uniqueness => {:scope => [:reference_type]}

    # def self.get_primary_contact_for_household(arg_household_id)
    #   get_primary_contact(arg_household_id, 6744)
    # end

    def self.get_primary_contact_for_application(arg_application_id)
    	get_primary_contact(arg_application_id, 6587)
    end

    def self.get_primary_contact_for_program_unit(arg_program_unit_id)
      get_primary_contact(arg_program_unit_id, 6345)
    end

    def self.get_primary_contact(arg_reference_id, arg_reference_type)
      primary_contact = nil
    	primary_contacts = where("reference_id = ? and reference_type = ?",arg_reference_id, arg_reference_type)
      primary_contact = primary_contacts.first if primary_contacts.present?
      return primary_contact
    end
end