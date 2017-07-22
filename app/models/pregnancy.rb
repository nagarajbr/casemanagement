class Pregnancy < ActiveRecord::Base
has_paper_trail :class_name => 'PregnancyVersion',:on => [:update, :destroy]

	# Author : Manojkumar PAtil
	# Date : 08/04/2014
	# Description : Model Validations

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

	# Model Validations .
	HUMANIZED_ATTRIBUTES = {
		pregnancy_due_date:"Pregnancy Due Date" ,
		number_of_unborn:"Expected Number of Children" ,
		pregnancy_termination_date: "Pregnancy Termination Date"

    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

	validates_presence_of  :pregnancy_due_date, message: "is required."
	validate :check_gender_for_pregnancy?
	validates_presence_of :number_of_unborn, message: "is required."
	validate :valid_unborn_children?
	validate :valid_due_date?
	validate :valid_termination_date?



	# Rule : Client's Gender should be equal to Female for Pregnancy record.
  	def check_gender_for_pregnancy?
  		l_client_object = self.client
  		l_gender = l_client_object.gender

  		# female = 4478
  		if l_gender.present?
  			logger.debug "gender of client= #{l_gender.inspect}"
	  		if l_gender == 4479 #!= 4478 and l_gender != 4480
	  			errors[:base] << "Client's gender should not be male."
	  			return false
	  		else
	  			return true
	  		end
	  	else
	  		errors[:base] << "Gender is not populated for selected client."
	  		return false
	  	end
  	end

  	# Rule : Valid number of unborn children > 0
  	def valid_unborn_children?
  		if number_of_unborn.present?
  			if number_of_unborn > 0
  				return true
  			else
  				errors[:base] << "Valid number of unborn children is more than zero."
  				 return false
  			end
  		else
  			return false
  		end
  	end

  	# Rule : Valid date after 1900
  	def valid_due_date?

		if pregnancy_due_date.present?
			if  pregnancy_due_date >= Date.today
			    return true
			else
			    errors.add(:pregnancy_due_date, "should be greater than or equal to the current date.")
				return false
			end
		else
			return false
		end
	end

	# Rule : Valid date after 1900
	def valid_termination_date?

		if pregnancy_termination_date.present?
			if pregnancy_termination_date > Date.today
			  errors.add(:pregnancy_termination_date, "should be less than or equal to the current date.")
			  return false
			else
				return true
			end
		else
			return true
		end
	end



		# def self.check_pregnancy_data_entered_for_all_household_members?(arg_household_id)
		# 	    lb_return = true
		# 	    l_return_object = nil
		# 	    # loop through each household member for presence of pregnancy data - if data is not present return false and exit.
		# 	    step1 = HouseholdMember.joins("INNER JOIN clients
		# 	                         ON (household_members.client_id = clients.id

		# 	                            )
		# 	                         ")
		# 	    step2 = step1.where("household_members.household_id = ?",arg_household_id)
		# 	    hh_member_collection = step2

		# 	    Rails.logger.debug("hh_member_collection = #{hh_member_collection.inspect}")
		# 	    hh_member_collection.each do |each_member|
		# 	      if each_member.pregnancy_charcteristics_found_add_flag == 'N'
		# 	        # no process
		# 	      else
		# 	        # pregnancy data should be there
		# 	        latest_pregnancy_data_collection = Pregnancy.where(" client_id = ?",each_member.client_id)
		# 	        if latest_pregnancy_data_collection.blank?
		# 	          lb_return = false
		# 	          l_return_object = each_member
		# 	          break
		# 	        end
		# 	      end

		# 	    end # end of hh_member_collection

		# 	    if lb_return == true
		# 	      return true
		# 	    else
		# 	      return l_return_object
		# 	    end
	 #  	end

	def self.current_pregnancy_for_client(arg_client_id)
		where("client_id = ? and pregnancy_due_date >= current_date",arg_client_id)
	end

end
