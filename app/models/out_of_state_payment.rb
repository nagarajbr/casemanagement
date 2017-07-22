class OutOfStatePayment < ActiveRecord::Base
has_paper_trail :class_name => 'OutofstatePaymentVersion',:on => [:update, :destroy]


	include AuditModule

	before_create :set_create_user_fields
	before_update :set_update_user_field
	before_save :default_work_participation_status

	def set_create_user_fields
    	user_id = AuditModule.get_current_user.uid
    	self.created_by = user_id
    	self.updated_by = user_id

    end

    def set_update_user_field
	    user_id = AuditModule.get_current_user.uid
	    self.updated_by = user_id
    end

	attr_accessor :from, :to
	validates_uniqueness_of :payment_month, scope: :client_id, message: "Overlapping months are skipped."

	def validate_data
		# Rails.logger.debug("self.state = #{self.state}")
		result = true
		unless self.state.present?
			errors[:base] << "State is required."
			result = false
		end
		unless self.from.present?
			errors[:base] << "From date is required."
			result = false
		end
		unless self.to.present?
			errors[:base] << "To date is required."
			result = false
		end

		if self.from.present?
			result = DateService.valid_date_before_today?(self,from.to_date,"From")
		end
		if self.to.present?
			result = DateService.valid_date_before_today?(self,to.to_date,"To")
		end
		if self.from.present? && self.to.present?
			unless self.from < self.to
				errors[:base] << "To date must be greater than from date."
				result = false
			end
		end

		return result
	end

	def self.get_payments_for_the_client(arg_client_id)
		where("client_id = ?", arg_client_id)
	end

	def self.get_out_of_state_payment_count_for_client(arg_client_id)
		step1 = where("client_id = ?",arg_client_id)
		if step1.present?
			out_of_state_count = step1.size
		else
			out_of_state_count = 0
		end
		return out_of_state_count
	end

	def default_work_participation_status
		self.work_participation_status = 5667 # Mandatory - TEA
	end

	def self.are_there_any_out_of_state_pymts_for_the_client(arg_client_id)
		where("client_id = ?", arg_client_id).count > 0
	end

end
