class ClientIncome < ActiveRecord::Base
has_paper_trail :class_name => 'ClientIncomeVersion',:on => [:update, :destroy]

  include AuditModule
  belongs_to :client
  belongs_to :income
  before_create :set_create_user_fields
  before_update :set_update_user_field
  after_create :set_income_step_as_incomplete

  def set_create_user_fields
  	#Rails.logger.debug "***********************set_create_user_fields called"
  	user_id = AuditModule.get_current_user.uid
  	self.created_by = user_id
  	self.updated_by = user_id
  end

  def set_update_user_field
    user_id = AuditModule.get_current_user.uid
    self.updated_by = user_id
  end

  def self.clients_sharing_income(arg_income_id,arg_client_id)
    Client.joins(:client_incomes).where("income_id = ? and client_id <> ?",arg_income_id,arg_client_id)
  end

  # Manoj - 10/01/2014
  # Income for Benefit members
  def self.get_benefit_members_incomes(arg_program_wizard_id,arg_run_month)
    step1 = ClientIncome.joins("INNER JOIN incomes ON client_incomes.income_id = incomes.id
                                INNER JOIN program_benefit_members ON client_incomes.client_id = program_benefit_members.client_id")
    step2 = step1.where("program_benefit_members.program_wizard_id = ?",arg_program_wizard_id)
    step3 = step2.where(" (
                            ( ? >= incomes.effective_beg_date AND incomes.effective_end_date is null)
                            OR
                            (? BETWEEN  incomes.effective_beg_date AND incomes.effective_end_date)
                            )",arg_run_month,arg_run_month
                        )
    step4 = step3.select("client_incomes.client_id, incomes.incometype,incomes.source,incomes.effective_beg_date,incomes.effective_end_date")
    benefit_member_income_collection = step4
    return benefit_member_income_collection
  end

  def self.get_income_details_for_a_client(arg_client_id,arg_rule_id)
    step1 = joins("INNER JOIN incomes ON incomes.id = client_incomes.income_id
                   INNER JOIN rule_details ON rule_details.codetable_items_id = incomes.incometype")
    step2 = step1.where("client_incomes.client_id = ? and  rule_details.rule_id= ? and rule_details.code_table_id = 36", arg_client_id,arg_rule_id)
    step3 = step2.select("incomes.id, incomes.incometype, incomes.classification, incomes.effective_beg_date, incomes.effective_end_date,
                          incomes.contract_amt, incomes.intended_use_mos, incomes.inc_avg_beg_date, incomes.frequency,rule_details.criteria_a_ind,
                          rule_details.criteria_b_ind, incomes.source, incomes.recal_ind")
  end

  def self.clients_income_details(arg_income_id,arg_client_id)
    Client.joins(:client_incomes).where("income_id = ? and client_id = ?",arg_income_id,arg_client_id)
  end

  # def self.is_client_getting_salry_wages_income?(arg_client_id)
  #   step1 = ClientIncome.joins("INNER JOIN incomes
  #                               ON (client_incomes.income_id = incomes.id
  #                                   and incomes.incometype = 2811
  #                                 )
  #                               ")
  #   step2 = step1.where("client_incomes.client_id = ?",arg_client_id)
  #   if step2.present?
  #     return true
  #   else
  #     return false
  #   end
  # end

  def set_income_step_as_incomplete
      # Rule: when both income & income detail data is entered for client, then only step is considered complete.
      #  when only Income (Master) record is created we mark the step as incomplete, then after income detail for all income records for client is saved - we mark step as complete.
      #  get income record
      income_object = Income.find(self.income_id)
      if income_object.effective_end_date.blank?
          earned_income_collection = SystemParam.where("system_params.system_param_categories_id = 9
                                     AND system_params.key = 'EARNED_INCOME_TYPES'
                                     AND  CAST(system_params.value AS integer) = ?",income_object.incometype)
          if earned_income_collection.present?
            HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(self.client_id,'household_member_incomes_step','I')
          else
            HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(self.client_id,'household_member_unearned_incomes_step','I')
          end
      end

      # mark client earned income flag as yes.
      client_object = Client.find(self.client_id)
      client_object.earned_income_flag = 'Y'
      client_object.save

  end

end
