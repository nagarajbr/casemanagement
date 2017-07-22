class ProgramMonthSummary < ActiveRecord::Base
	include AuditModule

	before_create :set_create_user_fields
	before_update :set_update_user_field


	# has_many :program_benefit_members


	def set_create_user_fields
		user_id = AuditModule.get_current_user.uid
		self.created_by = user_id
		self.updated_by = user_id
    end

    def set_update_user_field
	    user_id = AuditModule.get_current_user.uid
	    self.updated_by = user_id
    end


    def self.get_program_month_summary_collection(arg_run_id,arg_month_sequence)
    	program_month_summary_collection = ProgramMonthSummary.where("run_id = ? and month_sequence = ?",arg_run_id,arg_month_sequence)
    end

    def self.get_program_month_summary_collection_from_run_id(arg_run_id)
    	where("run_id = ?",arg_run_id)
    end

    def self.update_resource_details(arg_run_id,arg_month_sequence,arg_resource_total,arg_eligibility_ind)
        self.where(run_id: arg_run_id ,month_sequence:arg_month_sequence).update_all(tot_resources: arg_resource_total, budget_eligible_ind: arg_eligibility_ind)

   	end

end
