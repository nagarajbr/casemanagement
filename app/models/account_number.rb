class AccountNumber < ActiveRecord::Base
	include AuditModule

	before_create :set_create_user_fields
	before_update :set_update_user_field

  validates_presence_of :account_number, :representative_id, message: "is required"
  validates_uniqueness_of :account_number, :scope => [:representative_id], message: " Duplicate"

	def set_create_user_fields
    	user_id = AuditModule.get_current_user.uid
    	self.created_by = user_id
    	self.updated_by = user_id

    end

    def set_update_user_field
	    user_id = AuditModule.get_current_user.uid
	    self.updated_by = user_id
    end

    def self.get_ebt_account_number_next_value
       conn = ActiveRecord::Base.connection()
      return conn.select_value("SELECT nextval('ebt_account_number_seq')")
    end

    def self.add_new(arg_account_number, arg_representative_id)
      account_number_object = AccountNumber.where("account_number = ? and representative_id = ?",arg_account_number,arg_representative_id)
        if account_number_object.present?
            ls_return = "SUCCESS"
          #  already acccount exists
        else
          account_number_object = AccountNumber.new
          account_number_object.account_number = arg_account_number
          account_number_object.representative_id = arg_representative_id
           if account_number_object.save == true
            ls_return = "NEWRECORD"
             # logger.debug("ls_return - save success ")
           else
             # logger.debug("fail - save failed ")
              ls_error_message = account_number_object.errors.full_messages.last
              error_object = CommonUtil.write_to_attop_error_log_table_without_trace_details("AccountNumber","add_new","Error in adding new account_numbers record ",ls_error_message,arg_assigned_by_user_id)
              ls_return = "Failed to create new account"
            end
        end
           return ls_return
      end

    def self.get_representative_account_number(arg_representative_id)
        step1 = self.where("representative_id = ?",arg_representative_id).first
        if step1.present?
            step2 = step1.account_number
            return step2
        else
            return ""
        end
    end

    def self.used_existing_account?(arg_account_number)
       result = false
      step1 = self.where("account_number = ?", arg_account_number).count
      if step1 > 1
        result = true
      else
        result =  false
      end
      return result
    end
end
