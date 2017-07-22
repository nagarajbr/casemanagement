class Income < ActiveRecord::Base
has_paper_trail :class_name => 'IncomeVersion',:on => [:update, :destroy]

   include AuditModule
   before_create :set_create_user_fields
   before_update :set_update_user_field, :validate_income_begin_and_end_dates


	#Dependencies
    has_many :client_incomes, dependent: :destroy
    has_many :shared_clients_income,through: :client_incomes, source: :client
    has_many :income_details, dependent: :destroy

    attr_accessor :employment_level,:placement_ind,:employment_effective_begin_date,:position_title,
                  :occupation_code,:health_ins_covered,:duties,:employment_effective_end_date,:leave_reason, :validate_empolyment_info





    # Table Validations .
    validates_presence_of :incometype, message: "is required."
    validates_presence_of :frequency,message: "is required."
    validates_presence_of :effective_beg_date,message: "is required."
    validate :begin_date_less_than_end_date?,:validate_employment_data
    validates :amount, format: { with: /\A\d{0,6}(\.{1}\d{0,2})?\z/,
                                 message: "maximum 6 digits and 2 decimals."}
    validate :valid_contract_amt?
    validate :recal_ind_should_be_yes_for_create,:on => [:create]

    HUMANIZED_ATTRIBUTES = {
      incometype: "Type of Income",
      source: "Source",
      verified: "Verified?",
      frequency: "Frequency",
      effective_beg_date: "Begin Date",
      effective_end_date: "End Date" ,
      intended_use_mos: "Number Of Months",
      contract_amt: "Contract Amount",
      inc_avg_beg_date:"Average Begin Date",
      # notes:"Notes",
      recal_ind: "Recalculate Indicator?",
      employer_id: "Employer",
      employment_effective_begin_date: "Employment Begin Date"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    def begin_date_less_than_end_date?
      if effective_beg_date.present?
        if effective_end_date.present?
          if effective_beg_date > effective_end_date
            errors[:base] << "End date should be greater than begin date."
            return false
          else
            return true
          end
        else
          return true
        end
      else
        return false
      end
    end

    def validate_employment_data
      if self.validate_empolyment_info.present? && self.validate_empolyment_info
        validates_presence_of :employer_id,:employment_effective_begin_date
        if self.effective_beg_date.present? && self.employment_effective_begin_date.present? &&
              self.employment_effective_begin_date.to_date > self.effective_beg_date
          errors[:employment_effective_begin_date] << "should be less than income begin date."
        end
      end
    end

    def valid_contract_amt?
      if (contract_amt.present? && ((contract_amt.to_s =~ /\A\d{0,6}(\.{1}\d{0,2})?\z/).nil?))
        errors[:base] << "Invalid contract amount entered."
        return false
      else
        #errors[:base] << "Invalid contract amount entered!#{contract_amt.to_s}"
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

    def validate_income_begin_date_before_update
     if self.income_details.present?
        lowest_income_detail_date_received = self.income_details.order(date_received: :asc).first.date_received
        if self.effective_beg_date > lowest_income_detail_date_received
          errors[:base] << "Income begin date can't be after #{CommonUtil.format_db_date(lowest_income_detail_date_received)}."
          return false
        else
          return true
        end
      else
        return true
      end
    end

    def validate_income_end_date_before_update
      if self.income_details.present?
        latest_income_detail_date_received = self.income_details.order(date_received: :desc).first.date_received
        if self.effective_end_date.present? && self.effective_end_date < latest_income_detail_date_received
          errors[:base] << "Income end date can't be before #{CommonUtil.format_db_date(latest_income_detail_date_received)}."
          return false
        else
          return true
        end
      else
        return true
      end
    end

    def validate_income_begin_and_end_dates
      begin_date_validation = validate_income_begin_date_before_update
      end_date_validation = validate_income_end_date_before_update
      begin_date_validation && end_date_validation
    end

    def self.is_the_client_recieving_ssi(arg_client_id, arg_date)
      result = false
      incomes = Client.find(arg_client_id).incomes
      if incomes.present?
        result = incomes.where("incometype = 2707 and
        ((? between date_trunc('month', effective_beg_date) and date_trunc('month', effective_end_date)+'1month'::interval-'1day'::interval) or (date_trunc('month', effective_beg_date) <= ? and effective_end_date is null))",arg_date, arg_date).count > 0
      end
      return result
    end

    def recal_ind_should_be_yes_for_create
        if self.recal_ind.present? and self.recal_ind == 'N'
           errors[:base] << "Recalculate indicator should be 'yes' while adding a new income record."
        else
        end

    end

    # def self.is_income_type_salary_wages?(arg_income_id)
    #   income_object = Income.find(arg_income_id)
    #   ls_income_type = income_object.incometype.to_s
    #   salary_wages_income_type_collection = SystemParam.where("system_param_categories_id = 9 and key = 'INCOME_TYPE_SALARY_WAGES' and value = ? ", ls_income_type)
    #   if salary_wages_income_type_collection.present?
    #     return true
    #   else
    #     return false
    #   end
    # end

    def self.salary_income_type_present?(arg_income_object)
      ls_income_type = arg_income_object.incometype.to_s
      salary_wages_income_type_collection = SystemParam.where("system_param_categories_id = 9 and key = 'INCOME_TYPE_SALARY_WAGES' and value = ? ", ls_income_type)
      if salary_wages_income_type_collection.present?
        return true
      else
        return false
      end
    end

    # def self.latest_salary_income_type_income_record(arg_client_id)
    #   step1 = Income.joins("INNER JOIN client_incomes
    #                        ON incomes.id = client_incomes.income_id
    #                        INNER JOIN system_params
    #                        ON ( CAST(system_params.value AS integer) = incomes.incometype
    #                             AND system_params.system_param_categories_id = 9
    #                             AND system_params.key = 'INCOME_TYPE_SALARY_WAGES'
    #                           )
    #                    ")
    #   step2 = step1.where("client_incomes.client_id = ?
    #                        and (incomes.effective_end_date is null
    #                             OR incomes.effective_end_date > current_date
    #                             )",arg_client_id
    #                      ).order("effective_beg_date DESC")

    # end

    # def self.latest_master_income_record(arg_client_id)
    #   step1 = Income.joins("INNER JOIN  client_incomes
    #                        ON incomes.id = client_incomes.income_id")
    #   step2 = step1.where("client_incomes.client_id = ?",arg_client_id).order("updated_at DESC")
    #   latest_income_record = step2.first
    #   return latest_income_record

    # end

    # def self.income_information_created_for_this_position_type(arg_client_id, arg_position_type, arg_employer_id)
    #   client = Client.find(arg_client_id)
    #   client.incomes.where("position_type = ? and employer_id = ? and effective_end_date is null",arg_position_type, arg_employer_id).count > 0
    # end

    # Manoj 01/26/2016

    def self.earned_income_records(arg_client_id)
       step1 = Income.joins("INNER JOIN client_incomes
                           ON incomes.id = client_incomes.income_id
                           INNER JOIN system_params
                           ON ( CAST(system_params.value AS integer) = incomes.incometype
                                AND system_params.system_param_categories_id = 9
                                AND system_params.key = 'EARNED_INCOME_TYPES'
                              )
                       ")
      step2 = step1.where("client_incomes.client_id = ?",arg_client_id).order("effective_beg_date  desc")
       return step2



    end

    def self.unearned_income_records(arg_client_id)
      step1 = Income.joins("INNER JOIN client_incomes
                           ON incomes.id = client_incomes.income_id")
      step2 = step1.where("incomes.incometype not in  ( select CAST(system_params.value AS integer)
                                                       from system_params
                                                       where system_params.system_param_categories_id = 9
                                                       AND system_params.key = 'EARNED_INCOME_TYPES'
                                                      )

                           ")

      step3 = step2.where("client_incomes.client_id = ?",arg_client_id).order("effective_beg_date  desc")
      return step3
    end


    # def self.earned_income_records_with_salary_type_incomes(arg_client_id)
    #    step1 = Income.joins("INNER JOIN client_incomes
    #                        ON incomes.id = client_incomes.income_id
    #                        INNER JOIN system_params
    #                        ON ( CAST(system_params.value AS integer) = incomes.incometype
    #                             AND system_params.system_param_categories_id = 9
    #                             AND system_params.key = 'INCOME_TYPE_SALARY_WAGES'
    #                           )
    #                    ")
    #   step2 = step1.where("client_incomes.client_id = ?",arg_client_id).order("effective_beg_date  desc")
    #   return step2



    # end


end


