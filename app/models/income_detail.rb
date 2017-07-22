class IncomeDetail < ActiveRecord::Base
has_paper_trail :class_name => 'IncomeDetailVersion',:on => [:update, :destroy]

  include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field
  after_create :set_earned_income_step_as_complete,:set_unearned_income_step_as_complete


  belongs_to :income
  has_many :income_detail_adjust_reasons, dependent: :destroy

  validates_presence_of :date_received,message: "is required."
  validates_presence_of :check_type,message: "is required."
  validate :date_received_valid?, :received_date_validations


  validate :valid_gross_amt?
  # after_save :income_details_data_changed

    HUMANIZED_ATTRIBUTES = {
    :date_received => "Date Received",
    :check_type => "Check Type",
    :gross_amt => "Gross Amount",
    :cnt_for_convert_ind => "Count for Converted"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

  def date_received_valid?
    if date_received.present?
      if self.income.effective_end_date.present?
         unless (self.income.effective_beg_date..self.income.effective_end_date).cover?(date_received)
            errors[:base] << "Date received must be between income effective begin date and income effective end date."
            return false
          end

      else
        if date_received < self.income.effective_beg_date
          errors[:base] << "Date received must be greater than or equal to income effective begin date."
          return false
        else
          return true
        end
      end
    end
  end

  def valid_gross_amt?
      if (gross_amt.present? && ((gross_amt.to_s =~ /\A\d{0,6}(\.{1}\d{0,2})?\z/).nil?))
        errors[:base] << "Gross amount cannot be below zero and should be maximum 6 digits and 2 decimals."
        return false
      else
        return true
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

  # def self.get_earliest_income_detail_date_received(arg_income_id)
  #   where("income_id = ?",arg_income_id).order(date_received: :asc).first.date_received
  # end

  # def self.get_latest_income_detail_date_received(arg_income_id)
  #   where("income_id = ?",arg_income_id).order(date_received: :desc).first.date_received
  # end

  def received_date_validations
    if date_received.present? && date_received <= Date.today
      return true
    else

      return false
    end
  end

  # def self.get_income_details_for_income_id_month_and_year(arg_income_detail_struct)
  #   where("income_id = ? and date_received.month = ? and date_received.year = ?",arg_income_detail_struct.income_id,
  #         arg_income_detail_struct.received_month, arg_income_detail_struct.received_year)
  # end

  def self.get_income_detail_by_income_id(arg_income_id)
    where("income_id = ?",arg_income_id)
  end

  def self.get_countable_income(arg_income_id)
    where("income_id = ? and cnt_for_convert_ind = 'Y'", arg_income_id)

  end

  def self.get_actual_income_details(arg_income_id, arg_month, arg_year)
    where("income_id = ? and extract(month from date_received) = ? and extract(year from date_received) = ?",arg_income_id, arg_month, arg_year)
  end

  def self.get_income_details_for_client(arg_client_id)
      step1 = joins("INNER JOIN incomes on incomes.id = income_details.income_id
                    inner join client_incomes on incomes.id = client_incomes.income_id")
      step2 = step1.where("client_incomes.client_id = ?",arg_client_id)
      step3 = step2.select("income_details.*")
  end


 # def self.get_client_id_from_income_id(arg_income_id)

 #      step1 = Income.joins("inner join income_details on income_details.income_id = incomes.id
 #                            inner join client_incomes on client_incomes.income_id = incomes.id
 #                            inner join clients on client_incomes.client_id = clients.id")
 #      step2 = step1.where("income_details.income_id = ? ",arg_income_id)
 #      step3 = step2.select("clients.id")
 #      step4 = step3.first.id
 #      # arg_client_id = step3
 #      return step4

 #    end

      def self.salary_income_type_income_record(arg_client_id)
      step1 = IncomeDetail.joins("INNER JOIN incomes on income_details.income_id = incomes.id
                            INNER JOIN client_incomes
                           ON incomes.id = client_incomes.income_id
                           INNER JOIN system_params
                           ON ( CAST(system_params.value AS integer) = incomes.incometype
                                AND system_params.system_param_categories_id = 9
                                AND system_params.key = 'INCOME_TYPE_SALARY_WAGES'
                              )
                       ")
      step2 = step1.where("client_incomes.client_id = ?
                           and (incomes.effective_end_date is null
                                OR incomes.effective_end_date > current_date
                                )",arg_client_id
                         ).order("effective_beg_date DESC")
      step3 = step2.select("incomes.*, income_details.*")
    end

    def self.latest_client_income_detail_records(arg_client_id, arg_income_type)
      step1 = IncomeDetail.joins("INNER JOIN incomes on income_details.income_id = incomes.id
                          INNER JOIN client_incomes
                          ON incomes.id = client_incomes.income_id")
      step2 = step1.where("client_incomes.client_id = ?
                           and (incomes.effective_end_date is null
                                OR incomes.effective_end_date > current_date) and
                            incomes.incometype = ?",arg_client_id, arg_income_type).order("effective_beg_date DESC")
      #step3 = step2.select("incomes.frequency, income_details.date_received, income_details.net_amt")
      step3 = step2.select("client_incomes.client_id,incomes.*, income_details.*")

    end


    def set_earned_income_step_as_complete
      lb_all_income_detail_records_found = nil
      income_detail_object = IncomeDetail.find(self.id)
      income_object = Income.find(income_detail_object.income_id)
      client_income_collection = ClientIncome.where("income_id = ?",income_object.id).order("id DESC")
      if client_income_collection.present?
          # Rails.logger.debug("MANOJ= client_income_collection IS PRESENT")
          client_income_object = client_income_collection.first
           # Rails.logger.debug("client_income_object_first = #{client_income_object.inspect}")
          # income records for client.
          step1 = Income.joins("INNER JOIN client_incomes
                               ON incomes.id = client_incomes.income_id
                               and incomes.effective_end_date is null
                               INNER JOIN system_params
                               ON ( CAST(system_params.value AS integer) = incomes.incometype
                                    AND system_params.system_param_categories_id = 9
                                    AND system_params.key = 'EARNED_INCOME_TYPES'
                                  )
                              ")
          # Rails.logger.debug("client_income_object_later = #{client_income_object.inspect}")
          step2 = step1.where("client_incomes.client_id = ?",client_income_object.client_id)
          client_income_master_collection = step2
          if client_income_master_collection.present?
            client_income_master_collection.each do |each_client_income_master_record|
              income_detail_collection = IncomeDetail.where("income_id = ?",each_client_income_master_record.id)
              if income_detail_collection.blank?
                lb_all_income_detail_records_found = false
                break
              else
                lb_all_income_detail_records_found = true
              end
            end
          end

          if lb_all_income_detail_records_found == true
            HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(client_income_object.client_id,'household_member_incomes_step','Y')
          end
      end


    end

    def set_unearned_income_step_as_complete
      lb_all_income_detail_records_found = nil
      income_detail_object = IncomeDetail.find(self.id)
      income_object = Income.find(income_detail_object.income_id)
      client_income_collection = ClientIncome.where("income_id = ?",income_object.id).order("id DESC")
      client_income_object = client_income_collection.first
      # income records for client.
      step1 = Income.joins("INNER JOIN client_incomes
                           ON incomes.id = client_incomes.income_id
                           and incomes.effective_end_date is null
                           and incomes.incometype not in (select CAST(system_params.value AS integer)
                                                          from system_params
                                                          where system_params.system_param_categories_id = 9
                                                          AND system_params.key = 'EARNED_INCOME_TYPES'
                                                          )
                          ")

      step2 = step1.where("client_incomes.client_id = ?",client_income_object.client_id)
      client_income_master_collection = step2
      if client_income_master_collection.present?
        client_income_master_collection.each do |each_client_income_master_record|
          income_detail_collection = IncomeDetail.where("income_id = ?",each_client_income_master_record.id)
          if income_detail_collection.blank?
            lb_all_income_detail_records_found = false
            break
          else
            lb_all_income_detail_records_found = true
          end
        end
      end

      if lb_all_income_detail_records_found == true
        HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(client_income_object.client_id,'household_member_unearned_incomes_step','Y')
      end


    end



    def self.income_details_found_for_the_given_income?(arg_income_id)
      step1 = IncomeDetail.where("income_details.income_id = ?",arg_income_id)
      if step1.present?
        return true
      else
        return false
      end
    end





end
