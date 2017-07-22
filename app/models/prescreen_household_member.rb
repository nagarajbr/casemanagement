class PrescreenHouseholdMember < ActiveRecord::Base

   belongs_to :prescreen_household

   attr_accessor :personal_responsibility_agreement,:zip_code



   validates_presence_of :first_name, :last_name,:date_of_birth,:citizenship_flag,:residency_flag,:pregnancy_flag,:disabled_flag,:veteran_flag,:highest_education_grade_completed,:zip_code,:attending_school,:caretaker_flag, message: "is required"
   validate :accept_pra



     HUMANIZED_ATTRIBUTES = {
      citizenship_flag: "US Citizen",
      residency_flag: "Current Arkansas Resident",
      relation_to_primary_member: "Relationship to Primary Member",
      ssn: "SSN",
      first_name: "First Name",
      last_name: "Last Name",
      date_of_birth: "Date of Birth",
      middle_name: "Middle Name",
      suffix: "Suffix",
      gender: "Gender",
      marital_status: "Martital Status",
      identification_type: "Identification Type",
      primary_language: "Primary Language",
      pra_accept: "Accept Terms and Conditions"
    }

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

   def accept_pra
     if personal_responsibility_agreement.present?
        if pra_accept == "1"
          return true
        else
           errors.add(:pra_accept, 'is required.')
        end
    end

  end




   def self.get_primary_household_member_object(arg_prescreen_household_id)
    l_member_collection = PrescreenHouseholdMember.where("prescreen_household_id = ? and primary_member_flag = 'Y' ",arg_prescreen_household_id).first
   end


end
