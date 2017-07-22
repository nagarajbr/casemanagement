class Immunization < ActiveRecord::Base
	belongs_to :client
	attr_accessor :date_required

	# Model Validations .
	HUMANIZED_ATTRIBUTES = {
		exempt_from_immunization: "Exempt from Immunization?"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end


	validates :client_id,:vaccine_type, presence: true
	validate :valid_date_administered?
	validate :date_administered_is_less_than_dob_error_condition?

	def valid_date_administered?
		#@l_date_object = DateService.new
		DateService.valid_date_before_today?(self,date_administered,"Date Administered")
	end

	# def self.compute_date_required(arg_dob,arg_vaccine_type)
	# 	number_of_months = SystemParam.find(arg_vaccine_type).value.to_i
	# 	l_dt_required = (number_of_months.months).since(arg_dob)
	# 	date_required = l_dt_required
	# end

	def date_administered_is_less_than_dob_error_condition?
		# Rule : Date Administered should be greater than DOB
		if self.client.dob.present?
			l_dob = self.client.dob

			if l_dob >  Date.civil(1900, 1, 1) && date_administered.present? && date_administered >  Date.civil(1900, 1, 1)
		        if  (date_administered < l_dob)
		            local_message = "Date administered can not be less than date of birth."
		            self.errors[:base] << local_message
		            return false
		        else
		            return true
		        end
		    else
		   	  return true
		   end
		else
			 return true
		end


	end


end
