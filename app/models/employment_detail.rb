class EmploymentDetail < ActiveRecord::Base
has_paper_trail :class_name => 'EmploymentDetailVersion',:on => [:update, :destroy]

 # Author : Manoj Patil
 # Date : 08/13/2014
 # Description : Model Validation with error messages showing Labels rather than database fields.
 include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field
  after_create :set_employment_step_as_complete,:update_income_frequency
  after_update :update_income_frequency

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
    	effective_begin_date: "Begin Date",
    	effective_end_date: "End Date",
    	hours_per_period: "Hours Per Pay Period",
    	salary_pay_amt: "Salary",
    	salary_pay_frequency: "Salary Frequency",
    	current_status: "Status"
  	}

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end






  belongs_to :employment


    # Model Validations
    validates :effective_begin_date,:salary_pay_frequency,:salary_pay_amt,:hours_per_period,:current_status,:position_type, presence: true
    # validates :effective_begin_date, presence: { message: "%{value} can't be blank"}
    # instantiate Dateservice class
	# @l_date_object = DateService.new

	validate :valid_effective_begin_date?
	validate :valid_effective_end_date?
	validate :employment_begin_date_cannot_be_greater_than_end_date?
	#  Rule: Detail begin date and End date range should be within Master Begin and End date range.

	# make sure detail Begin date is within the range of master begin and end date.
	validate :dtl_begin_date_cannot_be_before_master_begin_date?
	validate :dtl_begin_date_cannot_be_after_master_end_date?

	# make sure detail End date is within the range of master begin and end date.
	validate :dtl_end_date_cannot_be_before_master_begin_date?
	validate :dtl_end_date_cannot_be_after_master_end_date?
	validate :validate_employment_detail_end_date_if_employment_end_date_present
	validates :salary_pay_amt, format: { with: /\A\d{0,6}(\.{1}\d{0,2})?\z/,
                                 message: "maximum 6 digits and 2 decimals."}


	def valid_effective_begin_date?
		DateService.valid_date?(self,effective_begin_date,"Begin Date")
	end

	def valid_effective_end_date?
		DateService.valid_date?(self,effective_end_date,"End Date")
	end

	def employment_begin_date_cannot_be_greater_than_end_date?
		# DateService.begin_date_cannot_be_greater_than_end_date?(self,<arg_begin_date>,<arg_end_date>,"Begin Date","End Date")
		DateService.begin_date_cannot_be_greater_than_end_date?(self,effective_begin_date,effective_end_date,"Begin Date","End Date")
	end

	def dtl_begin_date_cannot_be_before_master_begin_date?
		 # DateService.begin_date_cannot_be_greater_than_end_date_with_no_message?(self,<arg_begin_date>,<arg_end_date>)
		if DateService.begin_date_cannot_be_greater_than_end_date_with_no_message?(self,self.employment.effective_begin_date,effective_begin_date)
			return true
		else
			errors[:base] << "Employment detail begin date can not be before employment master begin date."
		end
	end

	def dtl_begin_date_cannot_be_after_master_end_date?
		 # DateService.begin_date_cannot_be_greater_than_end_date_with_no_message?(self,<arg_begin_date>,<arg_end_date>)
		if DateService.begin_date_cannot_be_greater_than_end_date_with_no_message?(self,effective_begin_date,self.employment.effective_end_date)
			return true
		else
			errors[:base] << "Employment detail begin date can not be after employment master end date."
		end
	end

	def dtl_end_date_cannot_be_before_master_begin_date?
		 # DateService.begin_date_cannot_be_greater_than_end_date_with_no_message?(self,<arg_begin_date>,<arg_end_date>)
		if DateService.begin_date_cannot_be_greater_than_end_date_with_no_message?(self,self.employment.effective_begin_date,effective_end_date)
			return true
		else
			errors[:base] << "Employment detail end date can not be before employment master begin date."
		end
	end

	def dtl_end_date_cannot_be_after_master_end_date?
		 # DateService.begin_date_cannot_be_greater_than_end_date_with_no_message?(self,<arg_begin_date>,<arg_end_date>)
		if DateService.begin_date_cannot_be_greater_than_end_date_with_no_message?(self,effective_end_date,self.employment.effective_end_date)
			return true
		else
			errors[:base] << "Employment detail end date cannot be after employment master end date."
		end
	end

	def validate_employment_detail_end_date_if_employment_end_date_present
		employment_end_date = self.employment.effective_end_date
		if employment_end_date.present?
			unless self.effective_end_date.present?
				errors[:base] << "Employment effective end date can't be blank."
				return false
			end
		else
			return true
		end
	end

	# def self.is_there_an_active_employment_more_than_24_hour(arg_client_id, arg_run_month)
	# 	# This is called at ED and minimum nuber of hours per week is 24
	# 	result = false
	# 	step1 = joins("INNER JOIN employments on employments.id = employment_details.employment_id")
 #      	step2 = step1.where("employments.client_id = ? and (employment_details.effective_begin_date <= date_trunc('month', ?::date)+'1month'::interval-'1day'::interval ) and
 #      							employment_details.effective_end_date is null ",arg_client_id, arg_run_month.to_date)
 #      	step3 = step2.select("sum(employment_details.hours_per_period) as hours_per_period ")
 #      	if step3.present?
 #           hours = (step3.first.hours_per_period).to_i
 #           if hours >= 24
 #           	 result = true
 #           	else
 #           	 result = false
 #           end
 #      	end
 #     return result
	# end

	def self.get_active_employment_for_client(arg_client_id, arg_run_month)
		hours = nil
		step1 = joins("INNER JOIN employments on employments.id = employment_details.employment_id")
      	step2 = step1.where("employments.client_id = ? and (employment_details.effective_begin_date <= date_trunc('month', ?::date)+'1month'::interval-'1day'::interval ) and
      							employment_details.effective_end_date is null ",arg_client_id, arg_run_month.to_date)
      	step3 = step2.select("sum(employment_details.hours_per_period) as hours_per_period ")
      	if step3.present?
           hours = (step3.first.hours_per_period).to_i
        end
        return hours

	end

	def self.valid_employment_should_be_present(arg_client_id)
		result = false
		step1 = joins("INNER JOIN employments on employments.id = employment_details.employment_id")
		step2 = step1.where("employments.client_id = ?",arg_client_id)
		step3 = step2.select("employment_details.*").order("effective_begin_date  desc")
		step3.each do |employment|
         # Rails.logger.debug("employment** = #{employment.inspect}")
			if employment.present?
			    if (employment.effective_begin_date? and (employment.effective_end_date? == false))
			    	# Open employment= begin date is present & end date is null
			   	      result = true
			    elsif employment.effective_begin_date? and employment.effective_end_date?
				    if employment.effective_end_date >= Date.today + 3.months
				    	# employment end is after 3 months
				   	    result = true
				   	end
	     	    end
		    end
		end
	    return result
	end

	def self.employment_present(arg_client_id)
		result = false
		step1 = joins("INNER JOIN employments on employments.id = employment_details.employment_id")
		step2 = step1.where("employments.client_id = ?",arg_client_id)
		step3 = step2.select("employment_details.*").order("effective_begin_date  desc")
		step3.each do |employment|
			if employment.present?
			   if (employment.effective_begin_date? and (employment.effective_end_date? == false))
			   	      result = true
			   elsif employment.effective_begin_date? and employment.effective_end_date?
			      if employment.effective_end_date >= Date.today + 3.months
			   	      result = true
			   	  end
	     	   end
		    end
		end
	    return result
	end

	def self.is_there_an_open_employment_for_the_client(arg_client_id)
		step1 = joins("INNER JOIN employments on employments.id = employment_details.employment_id")
		step2 = step1.where("employments.effective_end_date is null and employments.client_id = ?",arg_client_id)
		step2.select("employment_details.*").count > 0
	end

	def self.is_there_an_open_employment_for_the_client_with_employment_level(arg_client_id, arg_employment_level)
		step1 = joins("INNER JOIN employments on employments.id = employment_details.employment_id")
		step2 = step1.where("employments.effective_end_date is null and employments.client_id = ?
							 and employments.employment_level = ?",arg_client_id,arg_employment_level)
		step2.select("employment_details.*").count > 0
	end

	def self.is_there_an_open_full_time_employment_for_the_client(arg_client_id)
		is_there_an_open_employment_for_the_client_with_employment_level(arg_client_id, 2338)
	end

	def self.is_there_an_open_part_time_employment_for_the_client(arg_client_id)
		is_there_an_open_employment_for_the_client_with_employment_level(arg_client_id, 2342)
	end

	def self.is_there_an_open_for_the_client_with_full_insurance(arg_client_id)
		step1 = joins("INNER JOIN employments on employments.id = employment_details.employment_id")
		step2 = step1.where("employments.effective_end_date is null and employments.client_id = ?
							 and employments.health_ins_covered in (2365,2368)",arg_client_id)
		step2.select("employment_details.*").count > 0
	end

	def set_employment_step_as_complete
	  lb_all_employment_detail_records_found = nil
      employment_detail_object = EmploymentDetail.find(self.id)
      employment_object = Employment.find(employment_detail_object.employment_id)

      # employment records
      client_employment_master_collection = Employment.where("client_id = ?",employment_object.client_id)
      if client_employment_master_collection.present?
        client_employment_master_collection.each do |each_client_employment_master_record|
          employment_detail_collection = EmploymentDetail.where("employment_id = ?",each_client_employment_master_record.id)
          if employment_detail_collection.blank?
            lb_all_employment_detail_records_found = false
            break
          else
            lb_all_employment_detail_records_found = true
          end
        end
      end

      if lb_all_employment_detail_records_found == true
        HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(employment_object.client_id,'household_member_employments_step','Y')
      end


	end

	def update_income_frequency
		 employment_detail_object = EmploymentDetail.find(self.id)
         employment_object = Employment.find(employment_detail_object.employment_id)
		 income_collection = Income.where("employment_id = ?",employment_object.id)
		 if income_collection.present?
		 	income_object = income_collection.first
		 	income_object.frequency = employment_detail_object.salary_pay_frequency
		    income_object.save
		 end

	end
    def self.employment_details_records_given_employment_id(arg_employment_id)
         EmploymentDetail.where("employment_id = ? and effective_end_date is null",arg_employment_id).order("effective_begin_date desc")

    end

	 def self.employment_details_found_for_the_given_employment?(arg_employment_id)
      step1 = EmploymentDetail.where("employment_details.employment_id = ?",arg_employment_id)
      if step1.present?
        return true
      else
        return false
      end
    end

    def self.employment_details_record(arg_employment_id,arg_position_type)
    	where("employment_id = ? and position_type = ? and effective_end_date is null",arg_employment_id,arg_position_type)
    end




end
