class IncomeDetailAdjustReason < ActiveRecord::Base
has_paper_trail :class_name => 'IncomeDetailAdjustVersion',:on => [:update, :destroy]

  include AuditModule
  before_create :set_create_user_fields
  before_update :validate_update_data
  belongs_to :income_detail

  validates_presence_of :adjusted_amount, :adjusted_reason, message: "is required."
  validates :adjusted_amount, format: { with: /\A\d{0,6}(\.{1}\d{0,2})?\z/,
                                 message: "maximum 6 digits and 2 decimals."}


  def self.get_adjusted_total(income_detail_id)
  	where("income_detail_id = ?", income_detail_id ).sum("adjusted_amount")
  end

   def self.get_adjusted_income_detail_id(income_detail_id)
    where("income_detail_id = ?", income_detail_id )
  end

  def set_create_user_fields
    user_id = AuditModule.get_current_user.uid
    self.created_by = user_id
    self.updated_by = user_id
  end

  def validate_update_data
    if self.adjusted_amount.present? || self.adjusted_reason.present?
      set_update_user_field
      return true
    else
      return false
    end
  end

  def set_update_user_field
    user_id = AuditModule.get_current_user.uid
    self.updated_by = user_id
  end

  def self.get_adjustment_utility_portion(arg_income_detail_id, arg_rule_id)
    step1 = joins('INNER JOIN "rule_adjustments" ON "rule_adjustments"."adjust_value" = "income_detail_adjust_reasons"."adjusted_reason"
      INNER JOIN "income_details" ON "income_details"."id" = "income_detail_adjust_reasons"."income_detail_id"')
    step2 = step1.where("rule_adjustments.rule_id = ? and income_detail_adjust_reasons.income_detail_id = ?", arg_rule_id, arg_income_detail_id)
    step3 = step2.select("rule_adjustments.as_resource_ind,income_detail_adjust_reasons.adjusted_reason,income_detail_adjust_reasons.adjusted_amount")

  end

  def self.save_income_detail_adjust_reason(arg_income_detail_adjust_reason_object,arg_income_detail_object,arg_client_id)

         begin
            ActiveRecord::Base.transaction do
              IncomeDetailAdjustReasonService.process_actions_for_income_details_adjust_reason_change(arg_income_detail_adjust_reason_object, arg_client_id,nil,arg_income_detail_object.date_received)
              #1. save income_detail_adjust_reason
              # arg_income_detail_adjust_reason_object.save!
              # 2.income_detail
              adjusted_total = IncomeDetailAdjustReason.get_adjusted_total(arg_income_detail_object.id)
              arg_income_detail_object.adjusted_total = adjusted_total
              arg_income_detail_object.net_amt = (arg_income_detail_object.gross_amt - adjusted_total)
              arg_income_detail_object.save!
          end
            msg = "SUCCESS"
           rescue => err
              error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetailAdjustReason-Model","save_income_detail_adjust_reason",err,AuditModule.get_current_user.uid)
              msg = "Failed to save adjustment details - for more details refer to error ID: #{error_object.id}."
          end
  end

    def self.income_detail_adjust_reason_found_for_the_given_income_detail?(arg_income_detail_id)
      step1 = IncomeDetailAdjustReason.where("income_detail_adjust_reasons.income_detail_id = ?",arg_income_detail_id)
      if step1.present?
        return true
      else
        return false
      end
    end

end
