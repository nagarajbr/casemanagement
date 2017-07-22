class Alien < ActiveRecord::Base
has_paper_trail :class_name => 'AlienVersion',:on => [:update, :destroy]
	 include AuditModule
	 before_create :set_create_user_fields
     before_update :set_update_user_field
     attr_accessor :client_citizenship

     HUMANIZED_ATTRIBUTES = {
      citizenship: "Citizenship",
      sves_type: "Citizenship Verification Type",
      # residency: "Arkansas State Resident?",
      refugee_status: "Immigration Status",
      country_of_origin: "Country of origin" ,
      alien_DOE: "Alien Date Of Entry",
      alien_no: "Alien Number"
    }

  def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end


	 belongs_to :client
	 validate :valid_if_citizenship_is_No, :valid_alien_DOE?
   validates_presence_of :client_id




	def valid_if_citizenship_is_No
	      if client_citizenship == "N" && client_citizenship.present?
	       		# validates :refugee_status, :alien_DOE, presence: true
	       		if refugee_status == nil then
	       			 errors.add(:refugee_status, "is required.")
	       		end
	       		if alien_DOE == nil then
	       			 errors.add(:alien_DOE, "is required.")
	       		end
            if alien_DOE.present? && alien_DOE > Date.current then
              errors.add(:alien_DOE, "must be before today.")
            end

	      end
  	end


	 def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

    # def self.has_residency(arg_client_id)
    #   where("client_id = ? and residency is not null", arg_client_id).count > 0

    # end


  def valid_alien_DOE?
      if alien_DOE.present?
        if alien_DOE < Date.civil(1900,1,1)
          errors.add(:alien_DOE, "must be after 1900.")
                  return false
              else
                 return true
              end
      else
         return true
      end
    end

  #def self.is_a_state_resident(arg_client_id)
    # result = false
    #   physical_address = Address.get_non_mailing_address(arg_client_id, 6150)
    #   if physical_address.present?
    #      if physical_address.first.state == 5793
    #         result = true
    #       else
    #         result = false
    #      end

    #   end
    #   return result
    # # where("client_id = ? and residency = 'Y'",arg_client_id).count > 0
  #end

  def self.is_a_citizen_or_eligible_alien(arg_client_id)
    result = Client.where("id = ? and citizenship = 'Y'",arg_client_id).count > 0
    unless result
      result = where("client_id = ? and refugee_status is not null", arg_client_id).count > 0
    end
    return result
  end


end
