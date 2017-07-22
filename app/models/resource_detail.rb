class ResourceDetail < ActiveRecord::Base
has_paper_trail :class_name => 'ResourceDetailVersion' ,:on => [:update, :destroy]
  include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field
  after_create :set_resource_step_as_complete

  belongs_to :resource
  has_many :resource_adjustments, dependent: :destroy

  validate :resource_valued_date_valid?
  validates_presence_of :resource_valued_date, message: "is required."
  validates_presence_of :resource_value, message: "is required."
  validates_presence_of :first_of_month_value, message: "is required."
  validate :valid_resource_value?
  validate :valid_first_of_month_value?
  validate :valid_res_ins_face_value?
  validate :valid_amount_owned_on_resource?
  validate :amount_owned_as_of_date_valid?


  # after_save :resource_details_data_changed


  HUMANIZED_ATTRIBUTES = {
    :resource_valued_date => "Resource Valued Date",
    :resource_value => "Current Resource Value"
    }

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  def resource_valued_date_valid?
    if resource_valued_date.present?
    if self.resource.date_assert_acquired.present? && self.resource.date_assert_disposed.present?
        unless (self.resource.date_assert_acquired..self.resource.date_assert_disposed).cover?(resource_valued_date)
          errors[:base] << "Resource valued date must be between acquired date and disposed date."
          return false
        else
          return true
        end
    else
      if self.resource.date_assert_acquired.present?
        if resource_valued_date.present? && resource_valued_date < self.resource.date_assert_acquired
          errors[:base] << "Resource valued date must be greater than or equal to resource acquired date."
          return false
        else
          return true
        end
      end
    end
  end
end


   def amount_owned_as_of_date_valid?
    if amount_owned_as_of_date.present?
    if self.resource.date_assert_acquired.present? && self.resource.date_assert_disposed.present?
        unless (self.resource.date_assert_acquired..self.resource.date_assert_disposed).cover?(amount_owned_as_of_date)
          errors[:base] << "Amount owed as of date must be between acquired date and disposed date."
          return false
        else
          return true
        end
    else
      if self.resource.date_assert_acquired.present?
        if amount_owned_as_of_date.present? && amount_owned_as_of_date < self.resource.date_assert_acquired
          errors[:base] << "Amount owed as of date must be greater than or equal to resource acquired date."
          return false
        else
          return true
        end
      end
    end
  end
end

  def isValidDeciaml(arg_val, field_name)
  	if (arg_val.present? && ((arg_val.to_s =~ /\A\d{0,6}(\.{1}\d{0,2})?\z/).nil?))
        errors[:base] << "Invalid #{field_name} entered!, max allowed 6 digits and 2 decimals."
        return false
      else
        return true
      end
  end

  def valid_resource_value?
  	isValidDeciaml(resource_value, "Resource Value")
  end

  def valid_first_of_month_value?
  	isValidDeciaml(first_of_month_value, "First Of Month Value")
  end

  def valid_res_ins_face_value?
  	isValidDeciaml(res_ins_face_value, "Face Value")
  end

  def valid_amount_owned_on_resource?
  	isValidDeciaml(amount_owned_on_resource, "Amount owned on resource")
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

  def self.get_resource_details_for_client(arg_client_id)
     step1 = joins("INNER JOIN resources on resources.id = resource_details.resource_id
                    inner join client_resources on resources.id = client_resources.resource_id")
      step2 = step1.where("client_resources.client_id = ?",arg_client_id)
      step3 = step2.select("resource_details.*")
  end

  # def self.get_resource_detail(arg_resource_detail_id)
  #   ResourceDetail.find(arg_resource_detail_id)
  # end

   # def self.get_client_id_from_resource_id(arg_resource_id)

   #    step1 = Resource.joins(" inner join resource_details on resource_details.resource_id = resources.id
   #                           inner join client_resources on client_resources.resource_id = resources.id
   #                           inner join clients on client_resources.client_id = clients.id")
   #    step2 = step1.where("resource_details.resource_id = ? ",arg_resource_id)
   #    step3 = step2.select("clients.id")
   #    step4 = step3.first.id
   #    # arg_client_id = step3
   #    return step4

   #  end


    def set_resource_step_as_complete
      lb_all_resource_detail_records_found = nil
      resource_detail_object = ResourceDetail.find(self.id)
      resource_object = Resource.find(resource_detail_object.resource_id)
      client_resource_collection = ClientResource.where("resource_id = ?",resource_object.id).order("id DESC")
      client_resource_object = client_resource_collection.first
      # income records for client.
      step1 = Resource.joins("INNER JOIN client_resources
                           ON resources.id = client_resources.resource_id
                           and resources.date_assert_disposed is null
                          ")
      step2 = step1.where("client_resources.client_id = ?",client_resource_object.client_id)
      client_resource_master_collection = step2
      if client_resource_master_collection.present?
        client_resource_master_collection.each do |each_client_resource_master_record|
          resource_detail_collection = ResourceDetail.where("resource_id = ?",each_client_resource_master_record.id)
          if resource_detail_collection.blank?
            lb_all_resource_detail_records_found = false
            break
          else
            lb_all_resource_detail_records_found = true
          end
        end
      end

      if lb_all_resource_detail_records_found == true
        HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(client_resource_object.client_id,'household_member_resources_step','Y')
      end
    end


    def self.resource_details_found_for_the_given_resource?(arg_resource_id)
      step1 = ResourceDetail.where("resource_details.resource_id = ?",arg_resource_id)
      if step1.present?
        return true
      else
        return false
      end
    end




end
