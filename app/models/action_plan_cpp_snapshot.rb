class ActionPlanCppSnapshot < ActiveRecord::Base
	include AuditModule

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


    # def self.get_open_employment_action_plan_from_cpp_snapshot(arg_career_pathway_plan_id)
    # 	where("career_pathway_plan_id = ? and action_plan_type = 2976",arg_career_pathway_plan_id)
    # end






    # def self.get_open_barrier_reduction_plan_from_cpp_snapshot(arg_career_pathway_plan_id)
    #     where("career_pathway_plan_id = ? and action_plan_type = 2977",arg_career_pathway_plan_id)
    # end

end