class Resource < ActiveRecord::Base
has_paper_trail :class_name => 'ResourceVersion' ,:on => [:update, :destroy]

  include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field, :validation_for_date_assert_acquired
	#Dependencies
	has_many :client_resources, dependent: :destroy
  # has_many :shared_clients_resource,through: :client_resources, source: :client
  has_many :resource_details, dependent: :destroy
     # Model Validations .
    HUMANIZED_ATTRIBUTES = {
      resource_type: "Resource Type" ,
      account_number: "Account Number" ,
      description: "Description / Notes" ,
      date_assert_acquired: "Date Resource Acquired" ,
      date_assert_disposed: "Date Resource Disposed" ,
      number_of_owners: "Number Of Owners" ,
      net_value: "Value" ,
      date_value_determined: "Date Value Determined" ,
      use_code: "Ownership Percentage" ,
      verified: "Verified" ,
      year: " Year" ,
      make: " Make"  ,
      model: " Model" ,
      license_number: " License" ,


      }

      def self.human_attribute_name(attr, options = {})
        HUMANIZED_ATTRIBUTES[attr.to_sym] || super
      end

    # Table Validations .
    validates_presence_of :resource_type, message: "is required."
    validate :begin_date_less_than_end_date?
    validate :valid_net_value?
    validate :valid_use_code?
    validate :max_use_code_value
    #validates_presence_of :date_assert_acquired, message: "is required"

    def begin_date_less_than_end_date?
      if date_assert_acquired.present?
        if date_assert_disposed.present?
          if date_assert_acquired > date_assert_disposed
            errors[:base] << "End date should be greater than begin date."
            return false
          else
            return true
          end
        else
          return true
        end
      else
        return true
      end
    end

    def valid_net_value?
      if (net_value.present? && ((net_value.to_s =~ /\A\d{0,6}(\.{1}\d{0,2})?\z/).nil?))
        errors[:base] << "Invalid net value entered. Maximum 6 digits and 2 decimals allowed."
        return false
      else
        #errors[:base] << "Invalid net value entered!#{net_value.to_s}"
        return true
      end
    end

    def valid_use_code?
      if (use_code.present? && ((use_code.to_s =~ /\A\d{0,3}(\.{1}\d{0,2})?\z/).nil?))
        #errors[:base] << "Invalid usage percent entered  percentage is Maximum 100%"
        return false
      else
        #errors[:base] << "Invalid usage percent entered!#{use_code.to_s}"
        return true
      end
    end

    def max_use_code_value
      if self.use_code.present? && self.use_code > 100
        errors[:use_code] << "  is required and maximum percentage is 100%. "
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

  def validation_for_date_assert_acquired
if self.resource_details.present?
      earliest_resource_valued_date = self.resource_details.order(resource_valued_date: :asc).first.resource_valued_date
        if date_assert_acquired > earliest_resource_valued_date
          errors[:base] << "resource begin date can't be after #{CommonUtil.format_db_date( earliest_resource_valued_date)}."
          return false
        else
          return true
        end
    else
      return true
    end
  end

  def self.get_resources_for_client(arg_client_id)
      step1 = joins("INNER JOIN client_resources on resources.id = client_resources.resource_id")
      step2 = step1.where("client_resources.client_id = ?",arg_client_id)
      step3 = step2.select("resources.*")
  end

  def self.get_resource_disregard(arg_resource_id,arg_rule_id)
    # Rails.logger.debug("*************")
     step1 = joins(" INNER JOIN resource_details ON resources.id = resource_details.resource_id
                     INNER JOIN resource_uses ON resource_details.id = resource_uses.resource_details_id
                     INNER JOIN rule_disallows ON resource_uses.usage_code = rule_disallows.disregard_value and rule_disallows.codetable_items_id = resources.resource_type")
    step2 = step1.where(" resources.id = ?
                         AND rule_disallows.rule_id= ?
                         AND rule_disallows.code_table_id = 34
                          AND resource_details.id = (select a.id from resource_details a where a.resource_id = resources.id order by a.resource_valued_date desc limit 1)", arg_resource_id, arg_rule_id)
    step3 = step2.select("resources.id,
                resources.resource_type,
                rule_disallows.disregard_amt_code,
                rule_disallows.disregard_value,
                 resource_uses.usage_code,
                 resource_details.id as resource_detail_id,
                resources.number_of_owners")

  end

  # def self.get_latest_resource_record_collection(arg_client_id)
  #         step1 = Resource.joins("INNER JOIN client_resources
  #                                ON resources.id = client_resources.resource_id
  #                                ")
  #         step2 = step1.where("client_resources.client_id = ?",arg_client_id).order("resources.updated_at DESC")
  #         return step2
  # end

  # def self.check_resource_data_entered_for_all_household_members?(arg_household_id)
  #   lb_return = true
  #   l_return_object = nil
  #   # loop through each household member for presence of resource data - if data is not present return false and exit.
  #   step1 = HouseholdMember.joins("INNER JOIN clients
  #                        ON (household_members.client_id = clients.id

  #                           )
  #                        ")
  #   step2 = step1.where("household_members.household_id = ?",arg_household_id)
  #   hh_member_collection = step2

  #   Rails.logger.debug("hh_member_collection = #{hh_member_collection.inspect}")
  #   hh_member_collection.each do |each_member|
  #     if each_member.resource_add_flag == 'N'
  #       # no process
  #     else
  #       # resource data should be there
  #       latest_resource_collection = Resource.get_latest_resource_record_collection(each_member.client_id)
  #       if latest_resource_collection.blank?
  #         lb_return = false
  #         l_return_object = each_member
  #         break
  #       end
  #     end

  #   end # end of hh_member_collection

  #   if lb_return == true
  #     return true
  #   else
  #     return l_return_object
  #   end

  # end

end
