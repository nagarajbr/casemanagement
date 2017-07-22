class ResourceAdjustment < ActiveRecord::Base
has_paper_trail :class_name => 'ResourceAdjustmentVersion' ,:on => [:update, :destroy]

include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field
  belongs_to :resource_detail

    HUMANIZED_ATTRIBUTES = {
    :reason_code => "Reason",
    :resource_adj_amt => "Resource Adjustment Amount",
    :receipt_date => "Receipt Date",
    :adj_begin_date => "Adjustment Begin Date",
    :adj_end_date => "Adjustment End Date",
    :adj_num_of_months => "Number of Months"
    }

    validates_presence_of :reason_code,message: "is required."
    validates_presence_of :resource_adj_amt,message: "is required."
    validates_presence_of :receipt_date,message: "is required."
    validates_presence_of :adj_begin_date,message: "is required."
    validate  :valid_receipt_date?,:valid_adj_begin_date?,:valid_adj_end_date?,:adj_begin_date_less_than_adj_end_date?,:receipt_date_less_than_adj_begin_date?,:receipt_date_valid?

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
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


  def self.get_resource_adjustment_for_a_detail(arg_resource_detail_id)
  	where("resource_detail_id = ?",arg_resource_detail_id).order("id DESC")
  end


  def valid_receipt_date?
      DateService.valid_date?(self,receipt_date,"Receipt Date")
  end

  def valid_adj_begin_date?
      DateService.valid_date?(self,adj_begin_date,"Adjustment Begin Date")
  end

  def valid_adj_end_date?
      DateService.valid_date?(self,adj_end_date,"Adjustment End Date")
  end

  def adj_begin_date_less_than_adj_end_date?
      DateService.begin_date_cannot_be_greater_than_end_date?(self,adj_begin_date,adj_end_date,"Adjustment Begin Date","Adjustment End Date")
  end

  def receipt_date_less_than_adj_begin_date?
      DateService.begin_date_cannot_be_greater_than_end_date?(self,receipt_date,adj_begin_date,"Receipt Date","Adjustment Begin Date")
  end

   def self.get_resource_adjustment_for_a_detail(arg_resource_detail_id)
    where("resource_detail_id = ?",arg_resource_detail_id).order("id DESC")
  end

 def receipt_date_valid?
      if self.resource_detail.resource_valued_date.present?
        if receipt_date.present? && receipt_date < self.resource_detail.resource_valued_date
          errors[:base] << "Recepit date must be greater than or equal to resource valued date."
          return false
        else
          return true
        end
      end
 end

     def self.resource_details_adjustments_found_for_the_given_resource_detail_id?(arg_resource_detail_id)
      step1 = ResourceAdjustment.where("resource_adjustments.resource_detail_id = ?",arg_resource_detail_id)
      if step1.present?
        return true
      else
        return false
      end
    end




end
