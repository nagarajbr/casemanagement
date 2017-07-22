class Employment < ActiveRecord::Base
has_paper_trail :class_name => 'EmploymentVersion',:on => [:update, :destroy]

	# Author : Manoj Patil
  # Date : 08/08/2014
  # Description: Validations


  # Author : Keethana Sheri
  include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field
  after_create :set_employment_step_as_incomplete,:populate_income_and_assessment_data
  after_update :update_income_data


  def set_create_user_fields
    user_id = AuditModule.get_current_user.uid
    self.created_by = user_id
    self.updated_by = user_id
  end

  def set_update_user_field
    user_id = AuditModule.get_current_user.uid
    self.updated_by = user_id
  end

  belongs_to :client
  has_many :employment_details

	# Model Validations .

	validates_presence_of :employer_id, :effective_begin_date, message: "is required."
   validates :position_title, :allow_blank => true,length: { maximum:35 }
  validates :duties, :allow_blank => true,length: { maximum:4000 }
  validates :occupation_code, :allow_blank => true,length: { maximum:11 }
  validate :valid_effective_begin_date?
  validate :valid_effective_end_date?
  validate :begin_date_cannot_be_greater_than_end_date
  validate :validate_employment_leave_reason_if_employment_end_date_present?
  validate :leave_reason_present?

  validate :is_there_any_overlap, :on => :create
  validate :is_there_any_overlap_update, :on => :update






HUMANIZED_ATTRIBUTES ={
  employer_id: "Employer Name",
   placement_ind: "Placement",
   effective_begin_date:"Employment Begin Date",
  employment_level:"Employment Type",
  position_title:"Position Title",
  occupation_code:"Job Code" ,
  health_ins_covered:"Health Coverage",
  duties: "Duties",
  effective_end_date:"Employment End Date",
  leave_reason:"Reason for Leaving"
}

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end



  def valid_effective_begin_date?
      lb_return = true
      if effective_begin_date.present? && effective_begin_date < Date.civil(1900, 1, 1)
          errors[:base] << "Begin date must be after 1900."
          lb_return = false
      end
      return lb_return
  end

  # Rule : Valid date after 1900
  def valid_effective_end_date?

    if effective_end_date.present?
      if effective_end_date < Date.civil(1900, 1, 1)
         errors[:base] << "End date must be after 1900."
        return false
      else
          # Rule: Employment Master End date should be greater than current date.
          # Employment data entry is needed to know if client is currently working or not, so End date should be null or if entered it should be greater than current date.
        if effective_end_date > Date.today
          return true
        else
           errors[:base] << "Currently working employment should have future end date"
        end

      end
    else
      return true
    end
  end

 # check begin date cannot be greater than end date only if both dates are valid.
 def begin_date_cannot_be_greater_than_end_date
   if effective_end_date.present? && effective_end_date >  Date.civil(1900, 1, 1) && effective_begin_date.present? && effective_begin_date >  Date.civil(1900, 1, 1)
        if  (effective_begin_date > effective_end_date)
            local_message = "Begin date can't be before end date."
            errors[:base] << local_message
            return false
        else
            return true
        end
   else
    return true
  end
 end

  def validate_employment_leave_reason_if_employment_end_date_present?
    if effective_end_date.present?
      if leave_reason?
        return true
      else
        errors[:base] << "Reason for leaving is mandatory if end date is present."
        return false
      end
    else
      return true
    end
  end

def leave_reason_present?
  if leave_reason.present?
      if effective_end_date?
        return true
      else
        errors[:base] << " End date is mandatory if reason for leaving present."
        return false
      end
    else
      return true
    end
  end



  def is_there_any_overlap
    employement_date_over_lap = false
    if effective_begin_date.present?

          employement_date_over_lap = Employment.where("client_id = ? and employer_id =? and effective_end_date is null",self.client_id,self.employer_id).count>0
          ls_employer_name = Employer.get_employer_name(self.employer_id).first.employer_name if Employer.get_employer_name(self.employer_id).present?
          if employement_date_over_lap
           errors[:base] << " Client is already working with this employer: #{ls_employer_name}."
           end

          unless employement_date_over_lap
            same_employement_records =  Employment.where("client_id = ? and employer_id =? ",self.client_id,self.employer_id)
            # Rails.logger.debug("employee = #{same_employement_records.inspect}")

            same_employement_records.each do |record|
              start_date = self.effective_begin_date
              end_date = self.effective_end_date.present? ? self.effective_end_date : start_date
              record.effective_end_date = record.effective_end_date.present? ? record.effective_end_date : record.effective_begin_date
                while start_date <= end_date
                  if (record.effective_begin_date..record.effective_end_date).cover?(start_date)
                    errors[:base] << "Client is already working with this employer: #{ls_employer_name}."
                    employement_date_over_lap = true
                    break
                  end
                  start_date = start_date + 1
                end
              if employement_date_over_lap
                break
              end
            end
          end


        end

    return employement_date_over_lap
  end

  def is_there_any_overlap_update
        employement_date_over_lap = false
        if effective_begin_date.present?
                employement_date_over_lap = Employment.where("client_id = ? and employer_id =? and id != ? and effective_end_date is null",self.client_id,self.employer_id,self.id).count>0
                ls_employer_name = Employer.get_employer_name(self.employer_id).first.employer_name if Employer.get_employer_name(self.employer_id).present?
                if employement_date_over_lap
                 errors[:base] << " Client is already working with this employer: #{ls_employer_name}."
                 end

            unless employement_date_over_lap
              same_employement_records =  Employment.where("client_id = ? and employer_id =? and id != ? ",self.client_id,self.employer_id, self.id)
              same_employement_records.each do |record|
                start_date = self.effective_begin_date
                end_date = self.effective_end_date.present? ? self.effective_end_date : start_date
                record.effective_end_date = record.effective_end_date.present? ? record.effective_end_date : record.effective_begin_date
                  while start_date <= end_date
                    if (record.effective_begin_date..record.effective_end_date).cover?(start_date)
                      errors[:base] << "Client is already working with this employer: #{ls_employer_name}."
                      employement_date_over_lap = true
                      break
                    end
                    start_date = start_date + 1
                  end
                if employement_date_over_lap
                  break
                end
              end
            end
          end

    return employement_date_over_lap
  end

  def self.employment_records_for_client(arg_client)
    employment_collection = Employment.where("client_id = ?",arg_client).order("id desc")
    return employment_collection
  end

  def set_employment_step_as_incomplete
    HouseholdMemberStepStatus.readjust_steps_after_child_has_salaried_employment_income(self.client_id)
    HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(self.client_id,'household_member_employments_step','I')
  end

  def populate_income_and_assessment_data
     # 1. Populate Income master from employment master
    employer_object = Employer.find(self.employer_id)

    income_object = Income.new
    income_object.incometype = self.income_type
    income_object.frequency = 2317  # "Monthly"
    income_object.source = employer_object.employer_name
    income_object.effective_beg_date = self.effective_begin_date
    income_object.recal_ind = 'Y'
    income_object.employment_id = self.id
    income_object.save

    # Client Income.
    client_income_object = ClientIncome.new
    client_income_object.client_id = self.client_id
    client_income_object.income_id = income_object.id
    client_income_object.save

    #  earned income flag in client table
    client_object = Client.find(self.client_id)
    client_object.earned_income_flag = 'Y'


    # populate are you currently working  & future job offer

    if self.effective_begin_date > Date.today
      Rails.logger.debug("FUTURE DATE")
      client_object.job_offer_flag = 'Y'
      client_object.currently_working_flag = 'N'
    else
       Rails.logger.debug("LESS THAN CURRENT DATE")
      client_object.currently_working_flag = 'Y'
      client_object.job_offer_flag = nil
    end
    client_object.save

    # populate assessment data.
    ClientAssessmentAnswer.populate_assessment_and_assessment_answer_from_employment_step(client_object.id)


  end



  def update_income_data
     employer_object = Employer.find(self.employer_id)
     # find the income id for the employment id
     income_collection = Income.where("employment_id = ?",self.id).order("id DESC")
     if income_collection.present?
        income_object = income_collection.first
        income_object.source = employer_object.employer_name
        income_object.effective_beg_date = self.effective_begin_date
        income_object.save
     end
  end

  def self.is_client_having_employment?(arg_client_id)
    if Employment.where("client_id = ?",arg_client_id).present?
      return true
    else
      return false
    end
  end

  def self.employment_list_for_client(arg_client_id)
    step1 = joins("INNER JOIN employment_details ON employments.id = employment_details.employment_id")
    step2 = step1.where("employments.client_id = ?",arg_client_id)
      step3 = step2.select("distinct employment_details.position_type as occupation")
      return step3

  end


end
