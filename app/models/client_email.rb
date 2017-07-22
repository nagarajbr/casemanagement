class ClientEmail < ActiveRecord::Base
  has_paper_trail :class_name => 'ClientEmailVersion',:on => [:update, :destroy]

  include AuditModule
  belongs_to :client
  belongs_to :income
  before_create :set_create_user_fields
  before_update :set_update_user_field
  def set_create_user_fields
  	user_id = AuditModule.get_current_user.uid
  	self.created_by = user_id
  	self.updated_by = user_id
  end

  def set_update_user_field
    user_id = AuditModule.get_current_user.uid
    self.updated_by = user_id
  end

  def self.get_last_modified_user_id(arg_client_id)
      last_updated_record = nil
      step1 = Address.joins("inner join entity_addresses on entity_addresses.address_id = addresses.id").
                     where("addresses.address_type in (4665,4664) and entity_addresses.entity_id = ? and entity_addresses.entity_type = 6150 ", arg_client_id.to_i).
                     select("addresses.updated_by as updated_by ,addresses.updated_at as updated_at").order(updated_at: :desc)
        last_updated_record = step1.first if step1.present?
        Rails.logger.debug("last_updated_record address = #{last_updated_record.inspect}")
      step2 = ClientEmail.where("client_id = ?",arg_client_id.to_i).
                          select("updated_by as updated_by,updated_at as updated_at ").order(updated_at: :desc)
        if (step2.present? and step2.first.updated_at >= last_updated_record.updated_at)
            last_updated_record = step2.first
        else
            last_updated_record = last_updated_record
        end
        Rails.logger.debug("last_updated_record email = #{last_updated_record.inspect}")
      step3 = Phone.joins("inner join entity_phones on entity_phones.phone_id = phones.id").
                    where("phones.phone_type in (4661,4662,4663) and entity_phones.entity_id = ? and entity_phones.entity_type = 6150 ",arg_client_id.to_i).
                    select("phones.updated_by as updated_by ,phones.updated_at as updated_at").order(updated_at: :desc)
        if (step3.present? and step3.first.updated_at >= last_updated_record.updated_at)
            last_updated_record = step3.first
        else
            last_updated_record = last_updated_record
        end
        Rails.logger.debug("last_updated_record phone = #{last_updated_record.inspect}")
      return last_updated_record
      Rails.logger.debug("last_updated_record  = #{last_updated_record.inspect}")
  end


  def self.get_email_address(arg_client_id)
    result = where("client_id = ?",arg_client_id)
    result = result.first.email_address if result.present?
  end
end
