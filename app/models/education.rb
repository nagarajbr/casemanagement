class Education < ActiveRecord::Base
has_paper_trail :class_name => 'EducationVersion',:on => [:update, :destroy]

after_save :complete_education_step

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
		school_type: "School Type",
		school_name:"School Name",
		attendance_type: "Attendance Type",
		school_address_1: "Address",
		school_address_2: "City, State, Zip",
		effective_beg_date: "Begin Date",
		effective_end_date:"End Date",
		expected_grad_date:"Expected Graduation Date",
		degree_obtained: "Degree Obtained",
		high_grade_level: "Highest Grade Completed",
		major_study: "Major",
		effort: "Average Hrs/wrk"


    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    validates_presence_of :school_type, message: "is required."
	validates_presence_of :high_grade_level,message: "is required."
	validate :begin_date_cannot_be_less_than_end_date
	validates_presence_of :effective_beg_date, message: "is required."
	validate :valid_end_date?
	validate :valid_graduation_date?
	validate :education_end_date_cant_be_future_date
	validate :end_date_present?
	validate :effort_should_be_less_than_168

	# def valid_begin_date?
	# 	if effective_beg_date.present?
	# 		if effective_beg_date < Date.civil(1900,1,1)
	# 			errors.add(:effective_beg_date, "must be after 1900.")
 #                return false
 #            else
 #            	 return true
 #            end
	# 	else
	# 		 return true
	# 	end
	# end

	def valid_end_date?
		if effective_end_date.present?
			if effective_end_date < Date.civil(1900,1,1)
				errors.add(:effective_end_date, "must be after 1900.")
                return false
            else
            	 return true
            end
		else
			 return true
		end
	end

	def valid_graduation_date?
		if expected_grad_date.present?
			if expected_grad_date < Date.civil(1900,1,1)
				errors.add(:expected_grad_date, "must be after 1900.")
                return false
            else
            	 return true
            end
		else
			 return true
		end
	end

	def begin_date_cannot_be_less_than_end_date

	    if (effective_beg_date.present?) && (effective_end_date.present?) && (effective_beg_date > effective_end_date)
		      # errors.add(:expense_due_date, "can't be before Expense Begin date")

		    local_message = "Begin date cannot be after end date."

		    errors[:base] << local_message
		    return false
		else
			return true
	    end
  	end

  	def self.is_there_an_education_associated(arg_client_id)
  		where("client_id = ? and effective_beg_date is not null and effective_end_date is null",arg_client_id).count > 0
  	end


  	def self.check_if_minor_parent_has_an_eligible_education(arg_client_id)
  		# where("id = arg_education_id and high_grade_level not in (2215,2216,2217,2218,2219,2220,2221,2222,2223,2224,2225,2233").count > 0
  			result = true
  			currently_enrolled = where("client_id = ? and effective_beg_date is not null and effective_end_date is null",arg_client_id).count > 0
  			unless currently_enrolled
  				result = false
  				educations = where("client_id = ?",arg_client_id)
	  			educations.each do |education|
	  				result = where("id = arg_education_id and high_grade_level in (2226,2238)", education.id).count > 0
	  				if result
	  					break
	  				end
	  			end
  			end
  			return result
  	end

  	def education_end_date_cant_be_future_date
  		if self.effective_end_date.present? && self.effective_end_date > Date.today
  			errors[:base] << "Education end date can't be after #{CommonUtil.format_db_date(Date.today)}."
  			return false
  		else
  			return true
  		end
  	end

	def end_date_present?
		if effective_end_date.present?
		if expected_grad_date?
			errors[:base] << " Expected graduation date should not be populated if end date for education details is present."
				return false
			else
				return true
			end
		end

	end
	 def effort_should_be_less_than_168
	 	if effort.present?
	 		if effort <= 168
	         return true
	     else
	     	errors[:base] << " Average hours per week should be less than equal to 168 hours."
	    	end
	    end

	 end

	 def self.client_higher_educations_collections(arg_client_id)
	 	where("client_id = ? and high_grade_level in (2226,2227,2228,2229,2230,2231,2232,2234,2235,2238)",arg_client_id)
	 end

	 def complete_education_step
	 	HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(self.client_id,'household_member_education_step','Y')
	 end
end

