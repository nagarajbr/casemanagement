class Phone < ActiveRecord::Base
has_paper_trail :class_name => 'PhoneVersion',:on => [:update,:destroy]


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

    HUMANIZED_ATTRIBUTES = {

      phone_number: "phone number"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end


  belongs_to :client
    # Manoj 07/21/2014
	# Allow length allowed by Database field width. -start
	validates :phone_type,:phone_number, presence: true



	validates_numericality_of :phone_number

	validates_length_of :phone_number, minimum:10, maximum:10, message: " of 10 digits is required."


	def self.get_entity_contact_list(arg_client_id,arg_phone_type)
        step1 = joins("INNER JOIN entity_phones ON entity_phones.phone_id = phones.id")
        step1.where("entity_phones.entity_id = ? and entity_phones.entity_type = ? and phones.phone_type in (4661,4662,4663)",arg_client_id,arg_phone_type).order(phone_type: :desc)
    end
end


