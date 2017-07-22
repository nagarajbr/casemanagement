class ClientExpense < ActiveRecord::Base
has_paper_trail :class_name => 'ClientExpenseVersion',:on => [:update, :destroy]

  include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field
  after_create :set_expense_step_as_incomplete

  belongs_to :client
  belongs_to :expense

  validates_presence_of :client_id, :expense_id, message: "is required."

  def set_create_user_fields
    user_id = AuditModule.get_current_user.uid
    self.created_by = user_id
    self.updated_by = user_id
  end

  def set_update_user_field
    user_id = AuditModule.get_current_user.uid
    self.updated_by = user_id
  end

  def self.clients_sharing_expense(arg_expense_id,arg_client_id)
    Client.joins(:client_expenses).where("expense_id = ? and client_id <> ?",arg_expense_id,arg_client_id)
  end

   # Manoj - 10/01/2014
  # Income for Benefit members
  def self.get_benefit_members_expenses(arg_program_wizard_id,arg_run_month)
    step1 = ClientExpense.joins("INNER JOIN expenses ON client_expenses.expense_id = expenses.id
                                INNER JOIN program_benefit_members ON client_expenses.client_id = program_benefit_members.client_id")
    step2 = step1.where("program_benefit_members.program_wizard_id = ?",arg_program_wizard_id)
    step3 = step2.where(" (
                            ( ? >= expenses.effective_beg_date AND expenses.effective_end_date is null)
                            OR
                            (? BETWEEN  expenses.effective_beg_date AND expenses.effective_end_date)
                            )",arg_run_month,arg_run_month
                        )
    step4 = step3.select("client_expenses.client_id, expenses.expensetype,expenses.effective_beg_date,expenses.effective_end_date")
    benefit_member_expense_collection = step4
    return benefit_member_expense_collection
  end

  def self.clients_expense_details(arg_expense_id,arg_client_id)
    Client.joins(:client_expenses).where("expense_id = ? and client_id  ?",arg_expense_id,arg_client_id)
  end

  def set_expense_step_as_incomplete
      expense_object = Expense.find(self.expense_id)
      if expense_object.effective_end_date.blank?
        HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(self.client_id,'household_member_expenses_step','I')
      end
  end

end
