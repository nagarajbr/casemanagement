class ExpenseDetail < ActiveRecord::Base
has_paper_trail :class_name => 'ExpenseDetailVersion',:on => [:update, :destroy]

  include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field
  after_create :set_expense_step_as_complete

	belongs_to :expense
  validates :expense_id,:expense_due_date, :expense_amount, presence: true
	validate :payment_date_cannot_be_less_than_expense_start_date
  validate :payment_date_cannot_be_greater_than_expense_end_date
  validates :expense_amount, format: { with: /\A\d{0,6}(\.{1}\d{0,2})?\z/,
                                 message: "maximum 6 digits and 2 decimals."}
  #validates_presence_of :expense_due_date

   HUMANIZED_ATTRIBUTES = {
    :expense_due_date => "Expense Due Date",
    :expense_amount => "Amount"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

  def payment_date_cannot_be_less_than_expense_start_date

    if (expense_due_date.present?) && (expense_due_date < self.expense.effective_beg_date)
      # errors.add(:expense_due_date, "can't be before Expense Begin date")

      local_message = "Date can't be before expense begin date"

      errors[:base] << local_message
      return false
    end
  end

  def payment_date_cannot_be_greater_than_expense_end_date

    if (expense_due_date.present?) && (self.expense.effective_end_date.present?) && (expense_due_date > self.expense.effective_end_date)
      # errors.add(:expense_due_date, "can't be before Expense Begin date")

      local_message = "Date can't be after expense end date"

      errors[:base] << local_message
      return false
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

  def self.get_expense_details_for_client(arg_client_id)
     step1 = joins("INNER JOIN expenses on expenses.id = expense_details.expense_id
                    inner join client_expenses on expenses.id = client_expenses.expense_id")
      step2 = step1.where("client_expenses.client_id = ?",arg_client_id)
      step3 = step2.select("expense_details.*")
  end


  def set_expense_step_as_complete
      lb_all_expense_detail_records_found = nil
      expense_detail_object = ExpenseDetail.find(self.id)
      expense_object = Expense.find(expense_detail_object.expense_id)
      client_expense_collection = ClientExpense.where("expense_id = ?",expense_object.id).order("id DESC")
      client_expense_object = client_expense_collection.first
      # income records for client.
      step1 = Expense.joins("INNER JOIN client_expenses
                           ON expenses.id = client_expenses.expense_id
                           and expenses.effective_end_date is null
                          ")
      step2 = step1.where("client_expenses.client_id = ?",client_expense_object.client_id)
      client_expense_master_collection = step2
      if client_expense_master_collection.present?
        client_expense_master_collection.each do |each_client_expense_master_record|
          expense_detail_collection = ExpenseDetail.where("expense_id = ?",each_client_expense_master_record.id)
          if expense_detail_collection.blank?
            lb_all_expense_detail_records_found = false
            break
          else
            lb_all_expense_detail_records_found = true
          end
        end
      end

      if lb_all_expense_detail_records_found == true
        HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(client_expense_object.client_id,'household_member_expenses_step','Y')
      end

  end


    def self.expense_details_found_for_the_given_expense?(arg_expense_id)
      step1 = ExpenseDetail.where("expense_details.expense_id = ?",arg_expense_id)
      if step1.present?
        return true
      else
        return false
      end
    end



end





