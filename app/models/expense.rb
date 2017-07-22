class Expense < ActiveRecord::Base
has_paper_trail :class_name => 'ExpenseVersion',:on => [:update, :destroy]

  include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field, :validate_expense_begin_and_end_dates

	#Dependencies
	has_many :expense_details
	has_many :client_expenses , dependent: :destroy
    has_many :shared_clients_expense, through: :client_expenses, source: :client
    validates_presence_of :expensetype, message: "is required."
   	validates_presence_of :frequency,message: "is required."
  	validates_presence_of :effective_beg_date,message: "is required."

    validates :amount, format: { :with => /\A\d{0,8}(\.\d{0,2})?\z/}
    validates :creditor_name, length: { maximum: 35 }
    validates :creditor_contact, length: { maximum: 35 }




  	validate :effective_end_date_be_greater_than_effective_beg_date

    HUMANIZED_ATTRIBUTES = {
      #client_barrier_id: "",
      expensetype: "Type Of Expense",
      frequency: "Frequency",
      effective_beg_date: "Begin Date",
      effective_end_date: "End Date",
      creditor_name: "Policy/Acct#",
      creditor_contact: "Creditor Name ",
      creditor_phone: "Phone Number",
      creditor_ext: "Extension",
      verified: "Verified" ,
      exp_calc_months: "Number Of Months",
      budget_recalc_ind: "Recalculate Indicator ",
      notes: "Notes"
    }

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  validates_length_of :creditor_phone, minimum:10, maximum:10, :allow_blank => true,message: " of 10 digits is required."
  validates :creditor_ext, numericality: true,:allow_blank => true,length: { maximum: 5 }

  	def effective_end_date_be_greater_than_effective_beg_date
  		if (effective_end_date.present?) && (effective_end_date < effective_beg_date)
  			local_message = "End date cannot be before begin date."
      		errors[:base] << local_message
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



    def validate_effective_beg_date_before_update
         if self.expense_details.present?
            lowest_expense_details_date_received = self.expense_details.order(expense_due_date: :asc).first.expense_due_date
            if self.effective_beg_date > lowest_expense_details_date_received
              errors[:base] << "Expense begin date can't be after #{CommonUtil.format_db_date(lowest_expense_details_date_received)}."
              return false
            else
              return true
            end
          else
            return true
          end
        end

        def validate_effective_end_date_before_update
          if self.expense_details.present?
            latest_expense_details_date_received = self.expense_details.order(expense_due_date: :desc).first.expense_due_date
            if self.effective_end_date.present? && self.effective_end_date < latest_expense_details_date_received
              errors[:base] << "Expense end date can't be before #{CommonUtil.format_db_date(latest_expense_details_date_received)}."
              return false
            else
              return true
            end
          else
            return true
          end
        end

        def validate_expense_begin_and_end_dates
          begin_date_validation = validate_effective_beg_date_before_update
          end_date_validation = validate_effective_end_date_before_update
          begin_date_validation && end_date_validation
        end

        # def self.get_latest_expense_record_collection(arg_client_id)
        #   step1 = Expense.joins("INNER JOIN client_expenses
        #                          ON expenses.id = client_expenses.expense_id
        #                          ")
        #   step2 = step1.where("client_expenses.client_id = ?",arg_client_id).order("expenses.updated_at DESC")
        #   return step2
        # end
end
